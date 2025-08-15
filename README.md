# DevOps "Work Anywhere" Toolbox

A batteries-included Docker workspace with frequently used DevOps CLIs preinstalled:

- **Concourse**: `fly` (v7 default)
- **Halfpipe** CLI (built from source)
- **HashiCorp**: `terraform`, `vault`
- **Kubernetes**: `kubectl` (latest stable at build time)
- **Cloud**: `aws` (CLI v2), `gcloud` (Google Cloud CLI), `cf` (Cloud Foundry v8)
- Utilities: `git`, `vim`, `curl`, `jq`, `nmap`, `tcpdump`, `traceroute`, `netcat`, `ping`, etc.

Persistent **home** and **workspace** volumes let you stop/start the container without losing kubeconfigs, cloud creds, history, etc.

> Built 2025-08-15 for amd64/arm64 (multi-arch downloads).

## Quick start

```bash
# 1) Clone this repo and cd in
docker compose build
docker compose up -d

# 2) Open a shell
docker exec -it devops-toolbox bash

# 3) (Optional) put credentials in ./workspace/creds and copy .env.example -> .env
```

### Authentication helpers

Run these inside the container. They read env vars from `/workspace/.env` if present.

```bash
# AWS: SSO or static keys
/opt/toolkit/scripts/login_aws.sh

# Google Cloud: service account or user login
/opt/toolkit/scripts/login_gcloud.sh

# Vault: token or AppRole
/opt/toolkit/scripts/login_vault.sh

# Kubernetes: use a kubeconfig file or pull GKE creds
/opt/toolkit/scripts/login_kube.sh

# Cloud Foundry: user+pass or SSO passcode
/opt/toolkit/scripts/login_cf.sh

# Concourse fly
/opt/toolkit/scripts/login_fly.sh

# Terraform Cloud (writes ~/.terraform.d/credentials.tfrc.json)
/opt/toolkit/scripts/login_terraform.sh
```

### Volumes

- `devops-home` → `/home/devops` (persists **.aws**, **.kube**, **.config/gcloud**, **.cf**, **.terraform.d**, history, etc.)
- `workspace` → `/workspace` (your project files)

Mount extra secrets at run time as needed, e.g. `~/.ssh` read-only.

### Build args

- `FLY_VERSION` (default: `7.14.0`), override with `--build-arg FLY_VERSION=7.13.2`.
- `UID`, `GID` for host user mapping.

### Notes & sources

- HashiCorp official apt repo for **Terraform**/**Vault** (see docs).  
- **kubectl** installed from Kubernetes official binary download (latest stable at build) — keep client within one minor of your cluster.  
- **AWS CLI v2** installed using the official installer (x86_64 / aarch64).  
- **gcloud** installed via Google’s official apt repo.  
- **Cloud Foundry** v8 CLI installed per upstream instructions.

See the references in the main chat response for links.

### Troubleshooting

- On Apple Silicon or ARM hosts, Docker will pass `TARGETARCH=arm64` so the right binaries are fetched.
- If `fly` download fails for your arch/version, set a different `FLY_VERSION` in `.env` and rebuild.
- If `gcloud` prompts interactively during build on some corporate networks, build behind open internet or preseed via `--build-arg` proxies.


## License

MIT for the glue code in this repo; each tool remains under its own license.
