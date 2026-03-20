output "synthetic_test_id" {
  description = "Datadog synthetic test ID."
  value       = datadog_synthetics_test.this.id
}

output "availability_monitor_id" {
  description = "Datadog monitor ID for failed synthetic runs."
  value       = datadog_monitor.availability.id
}

output "latency_monitor_id" {
  description = "Datadog monitor ID for website latency."
  value       = datadog_monitor.latency.id
}

output "dashboard_id" {
  description = "Datadog dashboard ID."
  value       = datadog_dashboard_json.this.id
}

output "dashboard_url" {
  description = "Datadog dashboard URL."
  value       = datadog_dashboard_json.this.url
}
