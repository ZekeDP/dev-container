# Car Rental Dev Environment - Ubuntu 22.04 LTS

Rock-solid dev container for **full-stack development** with Java 21 backend and modern frontend.

## ✨ Features

- 🔧 **Full-Stack Ready**: Automated setup for both backend and frontend repositories
- 🐳 **Ubuntu 22.04 LTS**: Long-term support until April 2027
- ☕ **Java 21**: Eclipse Temurin JDK (latest LTS)
- 🔄 **Auto-Clone**: Repositories automatically cloned via SSH on container startup
- ⚙️ **Parameterized Paths**: Single configuration point for all directory paths
- 🔐 **SSH Integration**: Host SSH keys automatically shared with container
- 📦 **Build Cache**: Persistent Gradle and Maven caches for faster builds
- 🌐 **Port Forwarding**: Backend (8080) and Frontend (5173) pre-configured

## 🚀 Quick Start

### Prerequisites

1. **VS Code** with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. **Docker Desktop** installed and running
3. **SSH Keys** configured for GitHub at `~/.ssh/`
4. **Access** to both backend and frontend repositories

### Setup Steps

#### 1. Clone This Repository
```bash
git clone <this-repo-url>
cd dev-container
```

#### 2. Configure Environment
```bash
# Copy the example configuration
cp config/.env.example config/.env

# Edit the configuration
nano config/.env
```

**Required Configuration** (`config/.env`):
```bash
# Project home directory (change if needed)
PROJECT_HOME=/car-rental

# Repository URLs (REQUIRED - update these!)
BACKEND_REPO=git@github.com:YourOrg/car-rental-app-be.git
FRONTEND_REPO=git@github.com:YourOrg/car-rental-app-fe.git

# Clone method (ssh or https)
CLONE_METHOD=ssh

# Application ports
BACKEND_PORT=8080
FRONTEND_PORT=5173
```

#### 3. Verify SSH Keys
```bash
# Check that your SSH keys exist
ls -la ~/.ssh/

# Test GitHub connection
ssh -T git@github.com
# Should see: "Hi YourUsername! You've successfully authenticated..."
```

#### 4. Open in VS Code
```bash
code .
```

#### 5. Start the Dev Container
- Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
- Type: **"Dev Containers: Reopen in Container"**
- Wait 2-3 minutes for initial setup

The container will automatically:
- ✅ Build the Ubuntu 22.04 environment
- ✅ Install Java 21 (Temurin JDK)
- ✅ Copy your SSH keys
- ✅ Clone backend repository to `/car-rental/workspace/backend`
- ✅ Clone frontend repository to `/car-rental/workspace/frontend`
- ✅ Configure Git settings
- ✅ Display setup summary

#### 6. Verify Setup
```bash
# Check Java version
java -version
# Should show: openjdk version "21.x.x"

# Check repositories were cloned
ls -la /car-rental/workspace/
# Should see: backend/ and frontend/

# Navigate to backend
cd /car-rental/workspace/backend
./gradlew build
```

## 📁 Directory Structure

```
/car-rental/                      # Project home (container)
├── .devcontainer/                # Dev container configuration
│   ├── devcontainer.json        # VS Code dev container settings
│   ├── docker-compose.yml       # Container orchestration
│   └── Dockerfile               # Ubuntu 22.04 + Java 21 image
├── config/                       # Configuration files
│   ├── .env.example             # Environment template
│   └── .env                     # Active configuration (gitignored)
├── scripts/                      # Setup automation scripts
│   ├── run-all.sh              # Master orchestrator
│   ├── 01-load-env.sh          # Load environment variables
│   ├── 02-configure-git.sh     # Git configuration
│   ├── 03-setup-ssh.sh         # SSH key setup
│   ├── 04-clone-repo.sh        # Repository cloning
│   └── 05-finalize.sh          # Final setup steps
├── workspace/                    # Cloned repositories (gitignored)
│   ├── backend/                 # Backend repository
│   └── frontend/                # Frontend repository
├── docs/                         # Documentation
└── logs/                         # Application logs
```

## 🔧 Usage

### Backend Development

#### Navigate to Backend
```bash
cd /car-rental/workspace/backend
```

#### Build
```bash
# Gradle
./gradlew clean build

# Maven
./mvnw clean install
```

#### Run Backend Server
```bash
# Gradle
./gradlew bootRun

# Maven
./mvnw spring-boot:run

# Access at: http://localhost:8080
```

#### Run Tests
```bash
./gradlew test     # Gradle
./mvnw test        # Maven
```

### Frontend Development

#### Navigate to Frontend
```bash
cd /car-rental/workspace/frontend
```

#### Install Dependencies
```bash
npm install
# or
yarn install
```

#### Run Development Server
```bash
npm run dev
# or
yarn dev

# Access at: http://localhost:5173
```

#### Build for Production
```bash
npm run build
# or
yarn build
```

### Working with Both Services

#### Terminal Multiplexing
Open multiple terminals in VS Code:
- `Ctrl+Shift+` ` (backtick) - Open new terminal
- Run backend in one terminal, frontend in another

#### Example Workflow
```bash
# Terminal 1 - Backend
cd /car-rental/workspace/backend
./gradlew bootRun

# Terminal 2 - Frontend
cd /car-rental/workspace/frontend
npm run dev
```

## 📦 Package Management

Ubuntu uses **APT**:
```bash
# Install package
sudo apt install package-name

# Update packages
sudo apt update
sudo apt upgrade

# Search
apt search package-name
```

## ⚙️ Configuration

### Changing Project Home Directory

To use a different project root path (default is `/car-rental`):

1. **Update `config/.env`**:
   ```bash
   PROJECT_HOME=/your-custom-path
   ```

2. **Update `.devcontainer/devcontainer.json`**:
   ```json
   "workspaceFolder": "/your-custom-path",
   ```
   *Note: This field doesn't support environment variable substitution*

3. **Rebuild the container**:
   - Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
   - Type: **"Dev Containers: Rebuild Container"**

All scripts and paths will automatically use the new location!

### Environment Variables

All configuration is in `config/.env`:

```bash
# Project Configuration
PROJECT_HOME=/car-rental              # Container mount point

# Repository Configuration
BACKEND_REPO=git@github.com:...       # Backend repository URL
FRONTEND_REPO=git@github.com:...      # Frontend repository URL
CLONE_METHOD=ssh                      # ssh or https

# Application Ports
BACKEND_PORT=8080                     # Spring Boot server port
FRONTEND_PORT=5173                    # Vite/React dev server port

# Spring Boot
SPRING_PROFILES_ACTIVE=dev            # Active Spring profile

# Database (Optional)
DB_HOST=localhost                     # Database host
DB_PORT=5432                          # Database port
DB_NAME=car_rental_dev                # Database name
DB_USER=dev_user                      # Database user
DB_PASSWORD=dev_password              # Database password
```

## 🐛 Troubleshooting

### Container Won't Start
```bash
# Check running containers
docker ps

# View container logs
docker logs java-backend-dev-ubuntu

# Check Docker Desktop is running
# Make sure you have enough disk space
```

### Rebuild Container
If you encounter issues or update configuration:
- Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
- Type: **"Dev Containers: Rebuild Container"**

### SSH/Clone Issues

**Problem**: `Permission denied (publickey)` when cloning repositories

**Solution**:
```bash
# 1. Check SSH keys exist on host
ls -la ~/.ssh/
# Should see: id_rsa, id_ed25519, or similar

# 2. Test GitHub connection from host
ssh -T git@github.com
# Should see: "Hi YourUsername! You've successfully authenticated..."

# 3. If keys don't exist, generate them
ssh-keygen -t ed25519 -C "your_email@example.com"

# 4. Add to GitHub
cat ~/.ssh/id_ed25519.pub
# Copy output and add to GitHub → Settings → SSH Keys

# 5. Rebuild container
```

**Inside Container**:
```bash
# Check if keys were copied
ls -la ~/.ssh/

# Test from inside container
ssh -T git@github.com
```

### Repository Already Exists

If repositories were partially cloned or failed:
```bash
# Remove the directories
rm -rf /car-rental/workspace/backend
rm -rf /car-rental/workspace/frontend

# Re-run clone script
bash /car-rental/scripts/04-clone-repo.sh
```

### Port Conflicts

If ports 8080 or 5173 are already in use:

1. **Update `config/.env`**:
   ```bash
   BACKEND_PORT=8081
   FRONTEND_PORT=5174
   ```

2. **Update `.devcontainer/docker-compose.yml`**:
   ```yaml
   ports:
     - "8081:8080"
     - "5174:5173"
   ```

3. **Rebuild the container**

### Java Version Issues
```bash
# Check Java version
java -version
# Should show: openjdk version "21.x.x"

# Check JAVA_HOME
echo $JAVA_HOME
# Should show: /usr/lib/jvm/temurin-21-jdk-amd64
```

### Permission Issues
```bash
# If you get permission errors in workspace
sudo chown -R vscode:vscode /car-rental/workspace/
```

## 🏗️ Architecture

### How It Works

1. **Docker Compose** orchestrates the container with volume mounts and port forwarding
2. **Dockerfile** builds Ubuntu 22.04 image with Java 21 and configures the environment
3. **Setup Scripts** run automatically on container creation:
   - Load environment variables from `config/.env`
   - Configure Git with safe directories
   - Set up SSH keys from host machine
   - Clone backend and frontend repositories
   - Create necessary directories
4. **VS Code** connects to the container and provides integrated development experience

### Repository Management

- **Infrastructure Repository** (this repo): Contains dev container configuration and scripts
- **Backend Repository**: Cloned to `/car-rental/workspace/backend` (gitignored)
- **Frontend Repository**: Cloned to `/car-rental/workspace/frontend` (gitignored)

Each cloned repository maintains its own `.git` directory and can be independently managed.

### Path Parameterization

All paths are controlled by the `PROJECT_HOME` variable:
- **Single source of truth**: `config/.env`
- **Dockerfile**: Uses ARG and ENV for build-time and runtime configuration
- **Docker Compose**: Passes PROJECT_HOME to build args and volume mounts
- **All scripts**: Use `${PROJECT_HOME}` variable with `/car-rental` as default

This means you can change the entire project structure by updating one variable!

## 🤝 Contributing

### For Team Members

1. **Never commit cloned repositories** - They're gitignored for a reason
2. **Keep `config/.env` local** - Contains your personal configuration
3. **Update `config/.env.example`** - When adding new environment variables
4. **Test before committing** - Rebuild container to verify changes work
5. **Document changes** - Update this README when modifying setup

### Adding New Environment Variables

1. Add to `config/.env.example` with description
2. Add to this README in the Configuration section
3. Update relevant scripts if needed
4. Notify team members to update their local `.env` files

## 🚀 Advanced Usage

### Custom Build Tools

To add additional tools (e.g., Node.js, Python):

1. **Edit `.devcontainer/Dockerfile`**:
   ```dockerfile
   # Install Node.js
   RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
       apt-get install -y nodejs
   ```

2. **Rebuild container**

### Database Integration

To add a database service:

1. **Update `.devcontainer/docker-compose.yml`**:
   ```yaml
   services:
     postgres:
       image: postgres:15
       environment:
         POSTGRES_PASSWORD: dev_password
       ports:
         - "5432:5432"
   ```

2. **Rebuild container**

### Multiple Environments

Create environment-specific configurations:
- `config/.env.dev`
- `config/.env.staging`
- `config/.env.prod`

Load them in scripts as needed.

## 📝 License

[Your License Here]

## 📞 Support

For issues or questions:
- **Dev Container Issues**: Check troubleshooting section above
- **Backend Issues**: Refer to backend repository documentation
- **Frontend Issues**: Refer to frontend repository documentation

---

**Happy Coding!** 🚀