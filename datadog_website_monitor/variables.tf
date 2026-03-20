variable "url" {
  description = "HTTPS URL to monitor."
  type        = string

  validation {
    condition     = can(regex("^https://", var.url))
    error_message = "The monitored URL must start with https:// so TLS validation is meaningful."
  }
}

variable "service" {
  description = "Unified service tag value for the monitored website."
  type        = string
}

variable "environment" {
  description = "Environment tag for the monitored website."
  type        = string
}

variable "team" {
  description = "Team tag for the monitored website."
  type        = string
}

variable "alert_recipients" {
  description = "Notification handles such as @slack-channel or @pagerduty-service."
  type        = list(string)
  default     = []
}

variable "locations" {
  description = "Managed Datadog locations that execute the synthetic test."
  type        = list(string)
  default     = ["aws:us-east-2", "aws:eu-west-2"]

  validation {
    condition     = length(var.locations) >= 2
    error_message = "Provide at least two Datadog managed locations."
  }
}

variable "request_headers" {
  description = "Optional headers to send with the HTTP synthetic request."
  type        = map(string)
  default     = {}
}

variable "tick_every_seconds" {
  description = "How often Datadog runs the synthetic test."
  type        = number
  default     = 300
}

variable "min_failure_duration_seconds" {
  description = "Minimum duration a failure must persist before alerting."
  type        = number
  default     = 0
}

variable "min_location_failed" {
  description = "How many locations must fail before the synthetic check is considered failed."
  type        = number
  default     = 1
}

variable "renotify_interval_minutes" {
  description = "How often Datadog re-notifies while an alert remains active."
  type        = number
  default     = 60
}

variable "response_time_warning_threshold_ms" {
  description = "Warning threshold for average website latency in milliseconds."
  type        = number
  default     = 1500
}

variable "response_time_critical_threshold_ms" {
  description = "Critical threshold for average website latency in milliseconds."
  type        = number
  default     = 3000
}

variable "test_status" {
  description = "Whether the synthetic test should be active immediately."
  type        = string
  default     = "live"

  validation {
    condition     = contains(["live", "paused"], var.test_status)
    error_message = "test_status must be either live or paused."
  }
}

variable "extra_tags" {
  description = "Additional Datadog tags to apply to all managed resources."
  type        = map(string)
  default     = {}
}
