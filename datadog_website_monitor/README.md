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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | 4.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [datadog_dashboard_json.this](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/dashboard_json) | resource |
| [datadog_monitor.availability](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.latency](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_synthetics_test.this](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/synthetics_test) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment tag for the monitored website. | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Unified service tag value for the monitored website. | `string` | n/a | yes |
| <a name="input_team"></a> [team](#input\_team) | Team tag for the monitored website. | `string` | n/a | yes |
| <a name="input_url"></a> [url](#input\_url) | HTTPS URL to monitor. | `string` | n/a | yes |
| <a name="input_alert_recipients"></a> [alert\_recipients](#input\_alert\_recipients) | Notification handles such as @slack-channel or @pagerduty-service. | `list(string)` | `[]` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional Datadog tags to apply to all managed resources. | `map(string)` | `{}` | no |
| <a name="input_locations"></a> [locations](#input\_locations) | Managed Datadog locations that execute the synthetic test. | `list(string)` | <pre>[<br/>  "aws:us-east-2",<br/>  "aws:eu-west-2"<br/>]</pre> | no |
| <a name="input_min_failure_duration_seconds"></a> [min\_failure\_duration\_seconds](#input\_min\_failure\_duration\_seconds) | Minimum duration a failure must persist before alerting. | `number` | `0` | no |
| <a name="input_min_location_failed"></a> [min\_location\_failed](#input\_min\_location\_failed) | How many locations must fail before the synthetic check is considered failed. | `number` | `1` | no |
| <a name="input_renotify_interval_minutes"></a> [renotify\_interval\_minutes](#input\_renotify\_interval\_minutes) | How often Datadog re-notifies while an alert remains active. | `number` | `60` | no |
| <a name="input_request_headers"></a> [request\_headers](#input\_request\_headers) | Optional headers to send with the HTTP synthetic request. | `map(string)` | `{}` | no |
| <a name="input_response_time_critical_threshold_ms"></a> [response\_time\_critical\_threshold\_ms](#input\_response\_time\_critical\_threshold\_ms) | Critical threshold for average website latency in milliseconds. | `number` | `3000` | no |
| <a name="input_response_time_warning_threshold_ms"></a> [response\_time\_warning\_threshold\_ms](#input\_response\_time\_warning\_threshold\_ms) | Warning threshold for average website latency in milliseconds. | `number` | `1500` | no |
| <a name="input_test_status"></a> [test\_status](#input\_test\_status) | Whether the synthetic test should be active immediately. | `string` | `"live"` | no |
| <a name="input_tick_every_seconds"></a> [tick\_every\_seconds](#input\_tick\_every\_seconds) | How often Datadog runs the synthetic test. | `number` | `300` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_monitor_id"></a> [availability\_monitor\_id](#output\_availability\_monitor\_id) | Datadog monitor ID for failed synthetic runs. |
| <a name="output_dashboard_id"></a> [dashboard\_id](#output\_dashboard\_id) | Datadog dashboard ID. |
| <a name="output_dashboard_url"></a> [dashboard\_url](#output\_dashboard\_url) | Datadog dashboard URL. |
| <a name="output_latency_monitor_id"></a> [latency\_monitor\_id](#output\_latency\_monitor\_id) | Datadog monitor ID for website latency. |
| <a name="output_synthetic_test_id"></a> [synthetic\_test\_id](#output\_synthetic\_test\_id) | Datadog synthetic test ID. |
<!-- END_TF_DOCS -->