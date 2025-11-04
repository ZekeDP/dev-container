# Dev Container Setup Guide

## Overview

This project provides a containerized development environment for a Java backend application using VS Code Dev Containers.

## Architecture

```
.devcontainer/
├── Dockerfile.be           # Backend container image definition
├── devcontainer.json       # VS Code Dev Container configuration
└── docker-compose.dev.yml  # Docker Compose orchestration (alternative method)

scripts/
└── git-setup.sh           # Automatic repository cloning script

context.env                 # Shared environment variables
.env                       # Git configuration (SSH/HTTPS)
```

## Prerequisites

1. **Docker Desktop** installed and running
2. **VS Code** with "Dev Containers" extension
3. **SSH Keys** configured for GitHub (if using SSH clone method)

## Setup Methods

### Method A: VS Code Dev Container (Recommended)

This method uses `devcontainer.json` for a seamless VS Code experience.

1. **Configure SSH Access** (if using SSH):
   ```bash
   # Ensure your SSH keys exist at ~/.ssh/
   ls ~/.ssh/id_rsa ~/.ssh/id_ed25519
   ```

2. **Update devcontainer.json**:
   - Edit `.devcontainer/devcontainer.json`
   - Update the SSH mount path for your OS:
     - **macOS/Linux**: `"source=${localEnv:HOME}/.ssh,..."`
     - **Windows**: `"source=C:\\Users\\YourName\\.ssh,..."`

3. **Configure Repository**:
   Edit `.env`:
   ```env
   CLONE_METHOD=ssh  # or 'https'
   BACKEND_GIT=git@github.com:your-username/your-repo.git
   ```

4. **Open in Container**:
   - Open this folder in VS Code
   - Press `F1` → "Dev Containers: Reopen in Container"
   - Wait for container build and postCreateCommand to complete

5. **Verify Setup**:
   ```bash
   # Check Java installation
   java -version  # Should show Java 21
   
   # Check cloned repository
   ls dev-container/backend/
   ```

### Method B: Docker Compose (Standalone)

Use this if you prefer command-line workflows or don't use VS Code.

1. **Start Container**:
   ```bash
   cd .devcontainer
   docker-compose -f docker-compose.dev.yml up -d
   ```

2. **Attach to Container**:
   ```bash
   docker exec -it devhost-be bash
   ```

3. **Manual Clone** (if needed):
   ```bash
   ./scripts/git-setup.sh
   ```

## Environment Variables

### `.env` - Git Configuration
- `CLONE_METHOD`: `ssh` or `https`
- `BACKEND_GIT`: Repository URL to clone

### `context.env` - Runtime Configuration
- `BACKEND_PORT`: Backend service port (default: 8080)
- `FRONTEND_PORT`: Frontend service port (default: 5173)
- `SPRING_PROFILES_ACTIVE`: Spring Boot profile (default: dev)

## Directory Structure After Setup

```
project-root/
├── .devcontainer/          # Container configuration
├── dev-container/
│   └── backend/           # Cloned backend repository (auto-created)
├── scripts/               # Utility scripts
└── [your workspace files]
```

## Common Tasks

### Running the Backend Application

```bash
# Navigate to backend directory
cd dev-container/backend

# Build with Gradle (if using Gradle)
./gradlew build

# Run Spring Boot application
./gradlew bootRun

# Or with Maven
./mvnw spring-boot:run
```

### Updating Dependencies

```bash
# Update Gradle wrapper
./gradlew wrapper --gradle-version=latest

# Or update Maven wrapper
./mvnw wrapper:wrapper
```

### Rebuilding Container

```bash
# In VS Code: F1 → "Dev Containers: Rebuild Container"

# Or with Docker Compose:
docker-compose -f .devcontainer/docker-compose.dev.yml down
docker-compose -f .devcontainer/docker-compose.dev.yml up --build -d
```

## Troubleshooting

### SSH Key Issues

**Problem**: `Permission denied (publickey)` when cloning

**Solutions**:
1. Verify SSH key is added to GitHub: https://github.com/settings/keys
2. Test SSH connection: `ssh -T git@github.com`
3. Check SSH mount path in `devcontainer.json` matches your system

### Container Won't Start

**Problem**: Container exits immediately

**Solutions**:
1. Check Docker Desktop is running
2. View logs: `docker logs devhost-be`
3. Verify `.env` file exists and is properly formatted

### Java Version Mismatch

**Problem**: Wrong Java version in container

**Solutions**:
1. Rebuild container from scratch
2. Verify `JAVA_HOME` in Dockerfile points to correct JDK path

### Port Conflicts

**Problem**: Port 8080 already in use

**Solutions**:
1. Change `BACKEND_PORT` in `context.env`
2. Stop other services using port 8080
3. Update `docker-compose.dev.yml` port mappings if needed

## Customization

### Adding VS Code Extensions

Edit `.devcontainer/devcontainer.json`:
```json
"extensions": [
  "vscjava.vscode-java-pack",
  "your.extension-id"
]
```

### Installing Additional Tools

Edit `.devcontainer/Dockerfile.be`:
```dockerfile
RUN apt-get update && apt-get install -y \
    your-package-here \
 && rm -rf /var/lib/apt/lists/*
```

### Changing Java Version

1. Update Dockerfile.be to reference different Temurin version
2. Rebuild container

## Architecture Decisions

### Why Debian Bookworm?
- Stable, well-supported base
- Smaller than Ubuntu
- Good package availability

### Why Temurin JDK?
- Open-source, maintained by Eclipse Adoptium
- Long-term support for Java 21
- Better licensing than Oracle JDK

### Why Non-Root User?
- Security best practice
- Matches file permissions on host
- VS Code Dev Containers convention

## Next Steps

- [ ] Add database service to `docker-compose.dev.yml` if needed
- [ ] Configure frontend dev container (if applicable)
- [ ] Set up CI/CD pipeline
- [ ] Add test database configuration

## Contributing

When modifying this setup:
1. Test both VS Code and Docker Compose methods
2. Update this README with any configuration changes
3. Ensure scripts have LF line endings (not CRLF)
