# Datadog Observability as Code: Technical Challenge

## 📖 Background

Your team at **HappyDev** seeks to enable clients to provision their own standardized observability infrastructure using Infrastructure as Code (IaC) while adhering to Datadog best practices (such as Unified Service Tagging and alerting standards).

To this end, your team maintains a centralized git repository of Terraform modules to be used by all client engineering teams. These modules encapsulate Datadog monitoring patterns, ensuring that every new service gets high-quality, pre-configured dashboards and alerts out of the box.

## 🎯 Challenge

You have been tasked with adding a _Public Website Monitoring_ module to this repository. The first consumer of this module will be the client's engineering blog: `https://www.vlucaswang.com/`.

This module should be highly reusable and must provision the following resources using the official HashiCorp Datadog provider:

- **Synthetic Monitoring**: An API test (or Browser test) that continuously checks the availability of the provided URL from at least two different global locations. It should ensure the site returns a `200 OK` and that the SSL certificate is valid.
- **Alerting**: A Datadog Monitor that triggers a `Critical` alert if the synthetic test fails, and a `Warning` alert if the site's latency crosses a reasonable threshold.
- **Service Dashboard**: A basic, templated Datadog Dashboard that displays the uptime percentage and latency history of the website.
- **Tagging**: The module must enforce the client's Unified Service Tagging standards (`env`, `service`, `team`).

## 🧭 Guidelines

- The module must be generic and reusable. While the first target is `https://www.vlucaswang.com/`, the module should accept standard inputs (like URL, service name, environment, and alert recipients) so it can monitor *any* website.
- Create the module in a directory named `datadog_website_monitor`.
- We expect the code to be clean, modular, and to pass `terraform fmt` and `terraform validate`. We are assessing your knowledge of HCL and the Datadog API structure.
- You do *not* need to successfully `terraform apply` this against a live Datadog account, but the logic and provider configuration should be sound.
- Use of AI Tooling is allowed. If used, you are responsible/accountable for all code written and must be able to explain the configuration.
- Feel free to document any of the following in `notes.md`:
  - Trade-offs made (e.g., why choose an API test over a Browser test for this use case?)
  - Default thresholds chosen for alerting and why.
  - Future improvements you would make with more time.
- We know that time is precious and we don’t want this challenge to consume too much of yours - please don’t spend more than 2-3 hours on it. 🙏

## 📮 Submission

When you are totally finished, please ensure your code is on the `main` branch, create an empty file called `completed.txt` in the root of the repository, `commit`, and `push`. Then let your technical recruiter know that you're done.

Thank you for taking the time to complete this challenge - we look forward to reviewing your IaC approach! 🙌
