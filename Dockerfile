# syntax=docker/dockerfile:1.6
# DevOps "work anywhere" toolbox
# Supports amd64 and arm64
ARG DEBIAN_FRONTEND=noninteractive
ARG BASE_IMAGE=debian:bookworm-slim
FROM ${BASE_IMAGE} AS base

ARG DEBIAN_FRONTEND=noninteractive
ARG UID=1000
ARG GID=1000
ARG USERNAME=devops

# Versions (override at build time with --build-arg)
ARG FLY_VERSION=7.14.0

# Detect arch for multi-arch downloads
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH}

# Prepare apt and base tooling
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget gnupg apt-transport-https lsb-release \
    software-properties-common \
    git vim nano less unzip zip jq make \
    iproute2 iputils-ping dnsutils netcat-openbsd traceroute tcpdump nmap \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------
# HashiCorp repo: terraform & vault
# ---------------------------
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends gpg && rm -rf /var/lib/apt/lists/*; \
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release; echo $VERSION_CODENAME) main" > /etc/apt/sources.list.d/hashicorp.list; \
    apt-get update && apt-get install -y --no-install-recommends terraform vault && rm -rf /var/lib/apt/lists/*

# ---------------------------
# kubectl (downloaded from Kubernetes releases)
# ---------------------------
RUN set -eux; \
    case "${TARGETARCH:-amd64}" in \
      amd64) KARCH=amd64 ;; \
      arm64) KARCH=arm64 ;; \
      *) KARCH=amd64 ;; \
    esac; \
    KVER=$(curl -L -s https://dl.k8s.io/release/stable.txt); \
    curl -L -o /usr/local/bin/kubectl "https://dl.k8s.io/release/${KVER}/bin/linux/${KARCH}/kubectl"; \
    chmod +x /usr/local/bin/kubectl

# ---------------------------
# AWS CLI v2 (official installer)
# ---------------------------
RUN set -eux; \
    case "${TARGETARCH:-amd64}" in \
      amd64) AWSURL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" ;; \
      arm64) AWSURL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" ;; \
      *) AWSURL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" ;; \
    esac; \
    curl -sSL "$AWSURL" -o /tmp/awscliv2.zip; \
    unzip -q /tmp/awscliv2.zip -d /tmp; \
    /tmp/aws/install; \
    rm -rf /tmp/aws /tmp/awscliv2.zip

# ---------------------------
# Google Cloud CLI (apt)
# ---------------------------
RUN set -eux; \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list; \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg; \
    apt-get update && apt-get install -y --no-install-recommends google-cloud-cli && rm -rf /var/lib/apt/lists/*

# ---------------------------
# Cloud Foundry CLI v8 (apt)
# ---------------------------
RUN set -eux; \
    (apt-get update && apt-get install -y --no-install-recommends curl gnupg) > /dev/null 2>&1 || true; \
    curl -fsSL https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | gpg --dearmor -o /usr/share/keyrings/cloudfoundry-keyring.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/cloudfoundry-keyring.gpg] https://packages.cloudfoundry.org/debian stable main" > /etc/apt/sources.list.d/cloudfoundry.list; \
    apt-get update > /dev/null 2>&1; \
    apt-get install -y --no-install-recommends cf8-cli && rm -rf /var/lib/apt/lists/*; \
    ln -sf /usr/bin/cf8 /usr/local/bin/cf

# ---------------------------
# Concourse fly CLI
# ---------------------------
RUN set -eux; \
    case "${TARGETARCH:-amd64}" in \
      amd64) FARCH=amd64 ;; \
      arm64) FARCH=arm64 ;; \
      *) FARCH=amd64 ;; \
    esac; \
    curl -L -o /tmp/fly.tgz "https://github.com/concourse/concourse/releases/download/v${FLY_VERSION}/fly-${FLY_VERSION}-linux-${FARCH}.tgz"; \
    tar -xzf /tmp/fly.tgz -C /usr/local/bin/ fly; \
    chmod +x /usr/local/bin/fly; \
    rm -f /tmp/fly.tgz

# ---------------------------
# Build Halfpipe in a separate stage to avoid shipping Go toolchain
# ---------------------------
FROM golang:1.22-bookworm AS halfpipe-build
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH}
WORKDIR /src
RUN git clone --depth=1 https://github.com/springernature/halfpipe.git .
RUN set -eux; ARCH=${TARGETARCH:-amd64}; case "$ARCH" in amd64|arm64) ;; *) ARCH=amd64 ;; esac; CGO_ENABLED=0 GOOS=linux GOARCH=$ARCH go build -o /out/halfpipe ./cmd/halfpipe

# ---------------------------
# Final image
# ---------------------------
FROM base AS final
ARG DEBIAN_FRONTEND=noninteractive
ARG UID=1000
ARG GID=1000
ARG USERNAME=devops

# Copy in binaries from base (kubectl, terraform, vault, aws, gcloud, cf, fly)
RUN ln -sf /usr/local/aws-cli/v2/current/bin/aws /usr/local/bin/aws
RUN ln -sf /usr/local/aws-cli/v2/current/bin/aws_completer /usr/local/bin/aws_completer
RUN ln -sf /usr/bin/cf8 /usr/local/bin/cf
ENV PATH="/usr/lib/google-cloud-sdk/bin:${PATH}"

# Halfpipe binary
COPY --from=halfpipe-build /out/halfpipe /usr/local/bin/halfpipe
RUN chmod +x /usr/local/bin/halfpipe

# Create non-root user and workspace
RUN groupadd -g ${GID} ${USERNAME} && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME}
RUN mkdir -p /workspace && chown -R ${USERNAME}:${USERNAME} /workspace /home/${USERNAME}

# Quality of life: bashrc with completions
RUN echo 'export PATH=/usr/local/bin:/usr/bin:/usr/lib/google-cloud-sdk/bin:$PATH' >> /etc/profile.d/toolkit.sh && \
    echo 'alias k=kubectl' >> /etc/profile.d/toolkit.sh && \
    echo 'complete -C aws_completer aws || true' >> /etc/profile.d/toolkit.sh && \
    echo 'source <(kubectl completion bash) 2>/dev/null || true' >> /etc/profile.d/toolkit.sh && \
    echo 'source <(gcloud completion bash) 2>/dev/null || true' >> /etc/profile.d/toolkit.sh

# Scripts & entrypoint
COPY scripts/ /opt/toolkit/scripts/
COPY entrypoint.sh /entrypoint.sh
RUN chmod -R +x /opt/toolkit/scripts && chmod +x /entrypoint.sh

USER ${USERNAME}
WORKDIR /workspace
ENV HOME=/home/${USERNAME}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
