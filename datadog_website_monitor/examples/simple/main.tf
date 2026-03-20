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
  source = "../../"

  url         = "https://www.vlucaswang.com/"
  service     = "engineering-blog"
  environment = "production"
  team        = "platform"

  alert_recipients = ["@slack-observability"]

  extra_tags = {
    target = "public-website"
  }
}

output "synthetic_test_id" {
  description = "Synthetic test ID"
  value       = module.website_monitor.synthetic_test_id
}

output "latency_monitor_id" {
  description = "Latency monitor ID"
  value       = module.website_monitor.latency_monitor_id
}

output "dashboard_url" {
  description = "Dashboard URL"
  value       = module.website_monitor.dashboard_url
}
