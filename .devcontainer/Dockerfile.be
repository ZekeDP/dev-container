# Minimal Debian base
FROM debian:bookworm

# Metadata (optional)
LABEL maintainer="you@example.com" \
      description="Debian (bookworm) Dev Container with Temurin JDK 21"

# Noninteractive apt
ENV DEBIAN_FRONTEND=noninteractive

# Base tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget gnupg git unzip zip tar jq sudo which bash-completion \
 && rm -rf /var/lib/apt/lists/*

# --- Install Java 21 (Temurin) on Debian via Adoptium repo ---
# Add Adoptium GPG key & repo
RUN mkdir -p /etc/apt/keyrings \
 && curl -fsSL https://packages.adoptium.net/artifactory/api/gpg/key/public \
    | gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb bookworm main" \
    > /etc/apt/sources.list.d/adoptium.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends temurin-21-jdk \
 && rm -rf /var/lib/apt/lists/*

# Create non-root 'vscode' user (Dev Containers expects one)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
 && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
 && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
 && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /workspaces

# JAVA_HOME for Temurin 21 (path can vary slightly by arch)
ENV JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Set git clone method and backend repo via environment variables 
ENV CLONE_METHOD=ssh
ENV BACKEND_GIT=git@github.com:ZekeDP/car-rental-app-be.git

# Stay alive for VS Code to attach
CMD ["sleep", "infinity"]
