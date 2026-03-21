terraform {
  required_version = ">= 1.0.0"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 4.0"
    }
  }
}

provider "datadog" {}

module "website_monitor" {
  source = "../../../datadog_website_monitor"

  url         = var.url
  service     = var.service
  environment = var.environment
  team        = var.team

  alert_recipients                    = var.alert_recipients
  locations                           = var.locations
  min_failure_duration_seconds        = var.min_failure_duration_seconds
  min_location_failed                 = var.min_location_failed
  renotify_interval_minutes           = var.renotify_interval_minutes
  request_headers                     = var.request_headers
  response_time_warning_threshold_ms  = var.response_time_warning_threshold_ms
  response_time_critical_threshold_ms = var.response_time_critical_threshold_ms
  test_status                         = var.test_status
  tick_every_seconds                  = var.tick_every_seconds
  extra_tags                          = var.extra_tags
}

output "synthetic_test_id" {
  value = module.website_monitor.synthetic_test_id
}

output "availability_monitor_id" {
  value = module.website_monitor.availability_monitor_id
}

output "latency_monitor_id" {
  value = module.website_monitor.latency_monitor_id
}

output "dashboard_url" {
  value = module.website_monitor.dashboard_url
}
