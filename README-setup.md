# Datadog Public Website Monitoring Module

## Setup

Install dependencies and configure local tooling:

```bash
brew bundle
asdf plugin add terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf install terraform
pre-commit install
pre-commit install-hooks
```

## Datadog Authentication

Configure provider credentials through environment variables before planning or applying:

```bash
export DD_API_KEY="..."
export DD_APP_KEY="..."
export DD_HOST="https://api.ap2.datadoghq.com"
```

`DATADOG_API_URL` can be changed for non-US1 Datadog sites.

## Usage

Read the [simple example](datadog_website_monitor/examples/simple/main.tf) for the default workflow. The module interface is documented in the [module README](datadog_website_monitor/README.md).

## What This Module Enforces

- Unified service tags: `env`, `service`, and `team`
- HTTPS website checks from multiple locations
- Synthetic failure alerting for availability regressions
- Metric-based latency alerting for slow user experience
- A standard dashboard for uptime and latency visibility

## Requirements

- Terraform >= 1.0
- Datadog provider ~> 4.0

## Development

Development uses pre-commit, `terraform fmt`, `terraform validate`, and `tflint` for consistency and baseline quality checks.
