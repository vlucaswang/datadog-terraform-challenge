# Candidate Notes

## Tooling Decisions

- Tooling Provision: `brew` to standardize local dependencies across contributors.
- Terraform Version: `asdf` to keep the Terraform CLI version deterministic and aligned with the repo.
- Code Quality: `pre-commit` is configured for `terraform fmt`, `terraform validate`, `tflint`, and `terraform-docs` so the module stays reviewable and consistent.
- Documentation: Kept a dedicated `README-setup.md` plus a module README and example usage, following the same structure as the S3 challenge repo.

## Design Decisions

- Synthetic Type: Chose an API HTTP test instead of a Browser test.
  - Faster, cheaper, and easier to reason about for a public availability check.
  - Enough for the challenge requirements: HTTP 200 verification, TLS validation, multi-location execution, and latency telemetry.

- Alerting Model: Split alerting into two concerns.
  - Synthetic test: owns endpoint reachability and TLS validity.
  - Metric monitors: provide explicit, Terraform-managed alert policies for failed runs and latency thresholds.
  - This keeps availability and performance signals separate, which is easier for responders and future module consumers.

- Tagging: Enforced `env`, `service`, and `team` at the module boundary and propagated them to the synthetic test, monitors, and dashboard.
  - This mirrors Unified Service Tagging intent, even though the challenge swaps `version` for `team`.

- Monitor Strategy:
  - Availability monitor uses `synthetics.test_runs` filtered on `status:failure`.
  - Latency monitor uses `synthetics.http.response.time`.
  - Both are scoped with a module-specific synthetic tag to avoid accidental aggregation across unrelated tests.

- Dashboard Strategy:
  - Uptime percentage is computed from successful and total synthetic runs.
  - Separate visualizations show failed run count and latency history.
  - The dashboard is JSON-backed to keep layouting flexible without fighting nested dashboard HCL.

## Development Process

- Setup: mirrored the reference challenge by adding repo bootstrap files first (`.tool-versions`, `Brewfile`, `.gitignore`, `pre-commit`, terraform-docs config, setup README).
- Implementation: created a reusable `datadog_website_monitor` module with a narrow golden path and sensible defaults.
- Documentation: added a simple example targeting `https://www.vlucaswang.com/` and documented trade-offs and thresholds here.
- Verification: attempted local Terraform validation after bootstrapping the repo; any remaining validation gap is called out in the final summary.

## Trade-offs

### API Test vs. Browser Test
- Chose: API HTTP test.
- Pros: Lower cost, lower flakiness, simpler Terraform configuration, direct access to HTTP and TLS timing metrics.
- Cons: Does not validate rendered DOM or client-side JavaScript failures.
- Mitigation: A browser test could be added later as an optional mode for frontend-heavy properties.

### Separate Availability and Latency Monitors
- Chose: Two monitors instead of one overloaded alert.
- Pros: Clearer routing and alert semantics; availability pages people immediately, latency warns before hard downtime.
- Cons: Slightly more Terraform surface area.
- Mitigation: Both monitors are generated from the same scope and message conventions, so the module remains simple to consume.

### Default Thresholds
- Chose: warning at `1500ms`, critical at `3000ms`.
- Pros: Reasonable for a public content site while still catching user-visible regressions.
- Cons: Not all websites have the same latency budget.
- Mitigation: Thresholds are module inputs, so teams can tune them per property.

## Wider Considerations

### Operations
- Alert recipients are an input because routing differs between teams and clients.
- A module-specific scope tag is used to prevent one service's checks from polluting another service's monitors.

### Security
- HTTPS is required by input validation.
- Insecure TLS is explicitly disabled in the synthetic options so certificate problems fail the check instead of being ignored.

### Future Enhancements
- Add browser-test mode for SPA and complex frontend journeys.
- Support private locations for internal-only endpoints.
- Add optional SSL-expiry-specific checks and alerting if a client wants proactive certificate age monitoring.
- Add CI that runs `terraform init -backend=false`, `validate`, and `tflint` automatically on pull requests.
