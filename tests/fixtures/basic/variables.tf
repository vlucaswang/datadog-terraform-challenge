variable "url" {
  type = string
}

variable "service" {
  type = string
}

variable "environment" {
  type = string
}

variable "team" {
  type = string
}

variable "alert_recipients" {
  type    = list(string)
  default = []
}

variable "locations" {
  type    = list(string)
  default = ["aws:us-east-2", "aws:eu-west-2"]
}

variable "min_failure_duration_seconds" {
  type    = number
  default = 0
}

variable "min_location_failed" {
  type    = number
  default = 1
}

variable "renotify_interval_minutes" {
  type    = number
  default = 60
}

variable "request_headers" {
  type    = map(string)
  default = {}
}

variable "response_time_warning_threshold_ms" {
  type    = number
  default = 1500
}

variable "response_time_critical_threshold_ms" {
  type    = number
  default = 3000
}

variable "test_status" {
  type    = string
  default = "paused"
}

variable "tick_every_seconds" {
  type    = number
  default = 300
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
