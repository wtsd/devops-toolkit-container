# Onboarding and Environment Questionnaire

> **Purpose:**  
> This document is helps a new DevOps Engineer to go through the department, gather info, verify, and document all the essential knowledge. This process should provide a general understanding of the department's work and organization's resources, systems, technologies, POCs (points of contact), and structure.
> Once filled, it serves as a permanent reference and living document throughout your career here.

---

## 1. Personal & Team Information

| Field | Details |
|-------|----------|
| **Name** |  |
| **Start Date** |  |
| **Team / Department** |  |
| **Manager** |  |
| **Technical Lead** |  |
| **Mentor** |  |
| **Team Members** |  |
| **Team Time Zones** |  |
| **Daily Standup Time** |  |
| **Preferred Communication Channels** | (Slack, Teams, Zoom, Jira, etc) |
| **On-call / PagerDuty Rotation** |  |

---

## 2. Organization Overview

<details>
<summary>Expand Section</summary>

| Field | Details |
|-------|----------|
| **Company Mission / Core Products** |  |
| **Engineering Org Structure** |  |
| **Key Stakeholders (Product, Security, QA, etc.)** |  |
| **Change Management Process** |  |
| **Incident Response Workflow** |  |
| **Postmortem / RCA Template** |  |
| **Escalation Path and Timeline** |  |
| **Incident Channels** |  |

</details>

---

## 3. Cloud & Infrastructure

<details>
<summary>Expand Section</summary>

| Topic | Details |
|--------|----------|
| **Primary Cloud Providers** | (AWS / GCP / Azure / Other) |
| **Accounts / Orgs / Projects** |  |
| **Regions Used** |  |
| **Networking Overview** | (VPCs, Peering, VPNs, etc.) |
| **Environments** | (Dev / Stage / Prod — differences) |
| **Kubernetes Clusters** | (Names, regions, versions, access) |
| **Container Registry** | (ECR / GCR / ACR / etc.) |
| **Infrastructure as Code** | (Terraform / Ansible / etc.) |
| **Secrets Management** | (Vault, SSM, etc) |
| **Monitoring & Logging** | (Prometheus, Grafana, Datadog, Loki, etc.) |
| **Alerting System** | (PagerDuty, Opsgenie, etc.) |
| **Backup & Restore Policy** |  |
| **Disaster Recovery Setup** |  |

</details>

---

## 4. CI/CD Pipelines

<details>
<summary>Expand Section</summary>

| Topic | Details |
|--------|----------|
| **CI/CD Tools** | (Jenkins, GitHub Actions, ArgoCD, etc) |
| **Pipeline Structure** | (branching, promotion, etc.) |
| **Deployment Strategy** | (Blue/Green, Rolling, Canary) |
| **Infrastructure Repos** |  |
| **Application Repos** |  |
| **Code Review Process** |  |
| **Artifact Storage** | (S3, Artifactory, etc) |
| **Access & Permissions** |  |
| **Rollback Process** |  |

</details>

---

## 5. Credentials & Access Checklist

<details>
<summary>Expand Section</summary>

| Category | Tool / System | Access Granted | Test Command | Verified |
|-----------|----------------|----------------|---------------|-----------|
| Cloud Console |  |  | Login via web UI | ☐ |
| Kubernetes |  | `kubectl get nodes` |  | ☐ |
| CI/CD Tool |  |  |  | ☐ |
| Git Repositories |  | `git clone <repo>` |  | ☐ |
| Monitoring / Dashboards |  |  |  | ☐ |
| Secret Store |  |  |  | ☐ |
| VPN / Bastion Hosts |  | `ssh test` |  | ☐ |
| Ticketing System |  |  |  | ☐ |
| Internal Wiki / Docs |  |  |  | ☐ |

</details>

---

## 6. Communication & Notifications

<details>
<summary>Expand Section</summary>

| Topic | Details |
|--------|----------|
| **Incident Reporting Channel** |  |
| **Team Channel** |  |
| **Priority Alerts Channel** |  |
| **Meeting Cadence** |  |
| **Email Lists / Groups** |  |
| **Notification Routing Rules** |  |
| **Outage Communication Protocol** |  |

</details>

---

## 7. Security, Compliance & Governance

<details>
<summary>Expand Section</summary>

| Topic | Details |
|--------|----------|
| **Security Team Contact** |  |
| **Access Review Cycle** |  |
| **MFA / SSO Policy** |  |
| **Secrets Rotation Policy** |  |
| **Logging Retention** |  |
| **Compliance Frameworks** | (SOC2, ISO27001, etc) |
| **Security Scanning Tools** | (Trivy, Snyk, et) |
| **Approved OS / Software List** |  |

</details>

---

## 8. Local Development Setup

<details>
<summary>Expand Section</summary>

| Topic | Details |
|--------|----------|
| **Workstation OS / Setup Guide** |  |
| **Required CLI Tools** | (kubectl, helm, docker, terraform, etc.) |
| **Environment Variables / Configs** |  |
| **Local Sandbox / Test Environment** |  |
| **Debugging Tools** | (logs, traces, dashboards) |

</details>

---

## 9. Observability & Operations

<details>
<summary>Expand Section</summary>

| Topic | Details |
|--------|----------|
| **Monitoring Tools** |  |
| **Dashboards / Metrics Links** |  |
| **Log Aggregation** |  |
| **Tracing System** |  |
| **Common Alerts to Watch** |  |
| **Runbooks / Playbooks** |  |
| **SLO / SLA Overview** |  |

</details>

---

## 10. Maintenance & Routine Tasks 

<details>
<summary>Expand Section</summary>

| Task | Frequency | Owner | Notes |
|------|------------|--------|-------|
| Cluster Upgrades |  |  |  |
| Patch Management |  |  |  |
| Backup Verification |  |  |  |
| Access Review |  |  |  |
| Secrets Rotation |  |  |  |
| Cost Optimization Review |  |  |  |

</details>

---

## 11. Documentation & Knowledge Base

<details>
<summary>Expand Section</summary>

| Topic | Location / Link | Notes |
|--------|------------------|-------|
| **Internal Wiki** |  |  |
| **Architecture Diagrams** |  |  |
| **Runbooks / Playbooks** |  |  |
| **System Design Docs** |  |  |
| **Onboarding Docs** |  |  |
| **Postmortem Archive** |  |  |

</details>

---

## 12. Personal Notes & Observations

Add here anything you discover, optimize, or want to revisit later.  

This can include shortcuts, tribal knowledge, pitfalls, or configuration gotchas.

```text
Example:
- VPN drops connection every 12 hours, auto-reconnect alias added.
- Terraform state bucket policy tightened with versioning.
- Use `make bootstrap` for local dev setup.
```

