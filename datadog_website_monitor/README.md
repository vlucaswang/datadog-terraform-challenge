<!-- BEGIN_TF_DOCS -->
# Datadog website monitor module

## Purpose
Create a reusable Datadog public website monitoring baseline with an HTTP synthetic check, latency alerting, a service dashboard, and enforced service tags.

## Defaults
- Synthetic Type: API HTTP check for lightweight and reliable uptime coverage
- Coverage: Runs from at least two managed Datadog locations by default
- SSL Validation: HTTPS certificate validation remains enabled by keeping insecure TLS disabled
- Alerting: Separate availability and latency monitors with sane defaults
- Tagging: Enforces `env`, `service`, and `team` tags on every managed resource
- Dashboard: Provides uptime percentage, failed-run history, and latency trends for the target site

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| datadog | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| datadog_dashboard_json.this | resource |
| datadog_monitor.availability | resource |
| datadog_monitor.latency | resource |
| datadog_synthetics_test.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment tag for the monitored website. | `string` | n/a | yes |
| service | Unified service tag value for the monitored website. | `string` | n/a | yes |
| team | Team tag for the monitored website. | `string` | n/a | yes |
| url | HTTPS URL to monitor. | `string` | n/a | yes |
| alert_recipients | Notification handles such as `@slack-channel` or `@pagerduty-service`. | `list(string)` | `[]` | no |
| extra_tags | Additional Datadog tags to apply to all managed resources. | `map(string)` | `{}` | no |
| locations | Managed Datadog locations that execute the synthetic test. | `list(string)` | `["aws:us-east-2", "aws:eu-west-2"]` | no |
| min_failure_duration_seconds | Minimum duration a failure must persist before alerting. | `number` | `0` | no |
| min_location_failed | How many locations must fail before the synthetic check is considered failed. | `number` | `1` | no |
| renotify_interval_minutes | How often Datadog re-notifies while an alert remains active. | `number` | `60` | no |
| request_headers | Optional headers to send with the HTTP synthetic request. | `map(string)` | `{}` | no |
| response_time_critical_threshold_ms | Critical threshold for average website latency in milliseconds. | `number` | `3000` | no |
| response_time_warning_threshold_ms | Warning threshold for average website latency in milliseconds. | `number` | `1500` | no |
| test_status | Whether the synthetic test should be active immediately. | `string` | `"live"` | no |
| tick_every_seconds | How often Datadog runs the synthetic test. | `number` | `300` | no |

## Outputs

| Name | Description |
|------|-------------|
| availability_monitor_id | Datadog monitor ID for failed synthetic runs. |
| dashboard_id | Datadog dashboard ID. |
| dashboard_url | Datadog dashboard URL. |
| latency_monitor_id | Datadog monitor ID for website latency. |
| synthetic_test_id | Datadog synthetic test ID. |
<!-- END_TF_DOCS -->
