# CI Load Test with KinD + Ingress + k6

## Overview
This repository demonstrates a CI-driven approach to validating Kubernetes ingress routing and service stability under load.
It implements a CI workflow that:
- Provisions a multi-node Kubernetes cluster using KinD
- Deploys NGINX Ingress Controller
- Deploys two http-echo services (foo, bar)
- Routes traffic via host-based ingress
- Runs load tests using k6
- Posts load test results as a comment on the PR

The workflow runs automatically on every Pull Request to the default branch - main.

## Architecture
- GitHub Actions runner
- KinD (1 control-plane + 2 workers)
- ingress-nginx controller
- foo / bar http-echo services
- k6 for load testing

All components run entirely inside the CI runner to avoid external dependencies or cloud costs.

## CI Workflow
1. Triggered on pull_request
2. Create KinD cluster
3. Deploy ingress-nginx
4. Deploy foo & bar services
5. Wait for readiness (deployments, ingress controller, routing)
6. Run load test
7. Post results to PR

## Design Choices
- KinD for fast, reproducible multi-node Kubernetes without external infra
- NGINX ingress for hostname-based routing
- k6 for deterministic load testing
- Declarative Kubernetes manifests
- CI-first design to ensure all validation is automated and reviewable

## Failure Handling
- Health checks before load testing
- CI fails fast on any deployment issue
- Ingress routing is validated before executing load tests

## How to Verify
- Open a Pull Request
- Check GitHub Actions → CI job
- Verify PR comment with load test results

## Limitations
- KinD ingress exposure relies on localhost port mapping
- Load tests are synthetic and intended for functional validation, not capacity planning

## Time Spent
~4 hours

## Sample CI Execution

A sample Pull Request was created to demonstrate the CI workflow:

- CI triggered on Pull Request
- KinD cluster provisioned
- NGINX Ingress deployed and validated
- Host-based routing verified (`foo.localhost`, `bar.localhost`)
- k6 load test executed
- Load test results posted back to the PR as a comment

Artifacts from the sample run are available under `ci-sample/`:

- `ci-run.png` – Successful GitHub Actions workflow execution
- `pr-sample.png` – Sample Pull Request with CI comment
- `ci-results.txt` – Full k6 load test output

The full k6 output is stored as a text file to keep the PR comment readable while preserving complete results.