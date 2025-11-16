FROM ubuntu:22.04

LABEL maintainer="dev@example.com"
LABEL description="Java 21 Development on Ubuntu 22.04 LTS"

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Manila

# Install base tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    bash-completion \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    nano \
    openssh-client \
    procps \
    software-properties-common \
    sudo \
    tar \
    unzip \
    vim \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Temurin JDK 21 (Eclipse Adoptium)
RUN wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add - && \
    add-apt-repository --yes https://packages.adoptium.net/artifactory/deb/ && \
    apt-get update && \
    apt-get install -y temurin-21-jdk && \
    rm -rf /var/lib/apt/lists/*

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-arm64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Install Node.js 20 LTS (for React frontend)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# Project home directory configuration
ARG PROJECT_HOME=/car-rental
ENV PROJECT_HOME=${PROJECT_HOME}

# Create workspace
RUN mkdir -p ${PROJECT_HOME} && chown ${USERNAME}:${USERNAME} ${PROJECT_HOME}

# Switch to non-root user
USER ${USERNAME}
WORKDIR ${PROJECT_HOME}

# Configure git
RUN git config --global --add safe.directory ${PROJECT_HOME}

CMD ["sleep", "infinity"]