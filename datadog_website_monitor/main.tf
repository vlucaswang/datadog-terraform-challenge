locals {
  url_without_scheme = trimprefix(var.url, "https://")
  url_host           = element(split("/", local.url_without_scheme), 0)

  synthetic_scope = "${var.service}-${var.environment}-${replace(replace(local.url_host, ".", "-"), ":", "-")}"

  synthetic_name       = "[${upper(var.environment)}] ${var.service} public website availability"
  availability_name    = "[${upper(var.environment)}] ${var.service} public website failed checks"
  latency_monitor_name = "[${upper(var.environment)}] ${var.service} public website latency"
  dashboard_title      = "[${upper(var.environment)}] ${var.service} public website"

  notification_handles = join(" ", var.alert_recipients)

  scope_tags = [
    "env:${var.environment}",
    "service:${var.service}",
    "team:${var.team}",
    "website_scope:${local.synthetic_scope}",
  ]

  resource_tags = [
    "managed_by:terraform",
    "module:datadog_website_monitor",
    "website_host:${local.url_host}",
  ]

  extra_tags = [for key, value in var.extra_tags : "${key}:${value}"]

  tags         = concat(local.scope_tags, local.resource_tags, local.extra_tags)
  metric_scope = join(",", local.scope_tags)

  availability_query   = "sum(last_10m):sum:synthetics.test_runs{${local.metric_scope},status:failure}.as_count() >= 1"
  latency_metric_query = "avg:synthetics.http.response.time{${local.metric_scope}}"
  latency_query        = "avg(last_15m):${local.latency_metric_query} > ${var.response_time_critical_threshold_ms}"
  uptime_query         = "sum:synthetics.test_runs{${local.metric_scope}}.as_count()"
  uptime_ok_query      = "sum:synthetics.test_runs{${local.metric_scope},status:success}.as_count()"
  failed_runs_query    = "sum:synthetics.test_runs{${local.metric_scope},status:failure}.as_count()"

  synthetic_message = trimspace(join("\n", compact([
    "Public website synthetic check failed for ${var.url}.",
    "Service: ${var.service}",
    "Environment: ${var.environment}",
    length(local.notification_handles) > 0 ? "Notify: ${local.notification_handles}" : null,
  ])))
  availability_message = trimspace(join("\n", compact([
    "Synthetic failures detected for ${var.url}.",
    "This monitor tracks `synthetics.test_runs` with `status:failure` for the scoped website check.",
    length(local.notification_handles) > 0 ? "Notify: ${local.notification_handles}" : null,
  ])))
  latency_message = trimspace(join("\n", compact([
    "Website latency is elevated for ${var.url}.",
    "Warning above ${var.response_time_warning_threshold_ms}ms and critical above ${var.response_time_critical_threshold_ms}ms.",
    length(local.notification_handles) > 0 ? "Notify: ${local.notification_handles}" : null,
  ])))
}

resource "datadog_synthetics_test" "this" {
  name      = local.synthetic_name
  type      = "api"
  subtype   = "http"
  status    = var.test_status
  message   = local.synthetic_message
  locations = var.locations
  tags      = local.tags

  request_definition {
    method = "GET"
    url    = var.url
  }

  request_headers = var.request_headers

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = var.response_time_critical_threshold_ms
  }

  options_list {
    tick_every           = var.tick_every_seconds
    min_failure_duration = var.min_failure_duration_seconds
    min_location_failed  = var.min_location_failed
    follow_redirects     = true
    allow_insecure       = false

    monitor_options {
      renotify_interval = var.renotify_interval_minutes
    }
  }
}

resource "datadog_monitor" "availability" {
  name    = local.availability_name
  type    = "metric alert"
  message = local.availability_message
  query   = local.availability_query

  include_tags        = true
  notify_no_data      = false
  require_full_window = false
  renotify_interval   = var.renotify_interval_minutes
  validate            = false
  tags                = local.tags

  monitor_thresholds {
    critical = 1
  }
}

resource "datadog_monitor" "latency" {
  name    = local.latency_monitor_name
  type    = "metric alert"
  message = local.latency_message
  query   = local.latency_query

  include_tags        = true
  notify_no_data      = false
  require_full_window = false
  renotify_interval   = var.renotify_interval_minutes
  validate            = false
  tags                = local.tags

  monitor_thresholds {
    warning  = var.response_time_warning_threshold_ms
    critical = var.response_time_critical_threshold_ms
  }
}

resource "datadog_dashboard_json" "this" {
  dashboard = jsonencode({
    title       = local.dashboard_title
    description = "Terraform-managed public website dashboard for ${var.url}"
    layout_type = "ordered"
    notify_list = []
    template_variables = [
      {
        name    = "env"
        prefix  = "env"
        default = var.environment
      },
      {
        name    = "service"
        prefix  = "service"
        default = var.service
      },
      {
        name    = "team"
        prefix  = "team"
        default = var.team
      },
    ]
    widgets = [
      {
        definition = {
          title = "Uptime Percentage"
          type  = "query_value"
          requests = [
            {
              formulas = [
                {
                  formula = "100 * (query1 / query2)"
                }
              ]
              queries = [
                {
                  data_source = "metrics"
                  name        = "query1"
                  query       = local.uptime_ok_query
                },
                {
                  data_source = "metrics"
                  name        = "query2"
                  query       = local.uptime_query
                },
              ]
              response_format = "scalar"
            },
          ]
          autoscale   = true
          precision   = 2
          custom_unit = "%"
        }
      },
      {
        definition = {
          title = "Failed Runs"
          type  = "timeseries"
          requests = [
            {
              q            = local.failed_runs_query
              display_type = "bars"
              style = {
                palette    = "warm"
                line_type  = "solid"
                line_width = "normal"
              }
            },
          ]
          yaxis = {
            scale        = "linear"
            include_zero = true
            label        = "failed runs"
          }
        }
      },
      {
        definition = {
          title = "Latency History"
          type  = "timeseries"
          requests = [
            {
              q            = local.latency_metric_query
              display_type = "line"
              style = {
                palette    = "dog_classic"
                line_type  = "solid"
                line_width = "normal"
              }
            },
          ]
          markers = [
            {
              display_type = "warning dashed"
              label        = "warning"
              value        = "y = ${var.response_time_warning_threshold_ms}"
            },
            {
              display_type = "error dashed"
              label        = "critical"
              value        = "y = ${var.response_time_critical_threshold_ms}"
            },
          ]
          yaxis = {
            scale        = "linear"
            include_zero = true
            label        = "ms"
          }
        }
      },
    ]
  })
}
