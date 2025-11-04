#!/usr/bin/env bash
set -euo pipefail

echo "==========================================="
echo "🚀 Ubuntu 22.04 Dev Container Setup"
echo "==========================================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
WORKSPACE_ROOT="/workspace"
BACKEND_DIR="${WORKSPACE_ROOT}/backend"
BACKEND_REPO="${BACKEND_REPO:-}"
CLONE_METHOD="${CLONE_METHOD:-ssh}"

# Helper functions
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }
print_header() { echo -e "${CYAN}▶ $1${NC}"; }

# Display OS information
echo ""
print_header "System Information"
if [ -f /etc/os-release ]; then
    source /etc/os-release
    echo "   OS: ${PRETTY_NAME}"
    echo "   Version: ${VERSION}"
    print_success "Ubuntu 22.04 LTS - Stable & Reliable"
fi

# Validate Java
echo ""
print_header "Java Environment"
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    print_success "Java: ${JAVA_VERSION}"
    
    if java -version 2>&1 | grep -q "Temurin"; then
        print_success "Eclipse Temurin JDK (recommended)"
    fi
    
    if [ -n "${JAVA_HOME:-}" ]; then
        print_info "JAVA_HOME: ${JAVA_HOME}"
    fi
else
    print_error "Java not found!"
    exit 1
fi

# Validate Git
echo ""
print_header "Git Configuration"
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    print_success "Git: ${GIT_VERSION}"
else
    print_error "Git not found!"
    exit 1
fi

# Configure Git
git config --global --add safe.directory "${WORKSPACE_ROOT}"
git config --global init.defaultBranch main
git config --global core.editor nano 2>/dev/null || true
print_success "Git configured"

# SSH Setup
if [ "${CLONE_METHOD}" = "ssh" ]; then
    echo ""
    print_header "SSH Configuration"
    
    if [ -d "/home/vscode/.ssh" ]; then
        chmod 700 /home/vscode/.ssh 2>/dev/null || true
        find /home/vscode/.ssh -type f -exec chmod 600 {} \; 2>/dev/null || true
        print_success "SSH permissions set"
        
        print_info "Testing GitHub connection..."
        SSH_TEST=$(ssh -T git@github.com -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 2>&1 || true)
        
        if echo "$SSH_TEST" | grep -q "successfully authenticated\|Hi"; then
            print_success "GitHub SSH verified"
        else
            print_warning "GitHub SSH test completed"
        fi
    else
        print_warning "SSH directory not mounted"
        print_info "To use SSH: ensure ~/.ssh is mounted in docker-compose.yml"
    fi
fi

# Clone repository
echo ""
print_header "Repository Management"
if [ -n "${BACKEND_REPO}" ]; then
    if [ -d "${BACKEND_DIR}/.git" ]; then
        print_warning "Repository already exists: ${BACKEND_DIR}"
        cd "${BACKEND_DIR}"
        CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
        print_info "Current branch: ${CURRENT_BRANCH}"
    else
        print_info "Cloning repository..."
        print_info "URL: ${BACKEND_REPO}"
        print_info "Method: ${CLONE_METHOD}"
        
        mkdir -p "$(dirname "${BACKEND_DIR}")"
        
        if git clone "${BACKEND_REPO}" "${BACKEND_DIR}"; then
            print_success "Repository cloned"
            cd "${BACKEND_DIR}"
            
            CURRENT_BRANCH=$(git branch --show-current)
            print_info "Branch: ${CURRENT_BRANCH}"
            
            FILE_COUNT=$(find . -type f -not -path '*/\.git/*' | wc -l)
            print_info "Files: ${FILE_COUNT}"
            
            # Make wrappers executable
            [ -f gradlew ] && chmod +x gradlew && print_success "Gradle wrapper ready"
            [ -f mvnw ] && chmod +x mvnw && print_success "Maven wrapper ready"
        else
            print_error "Clone failed"
            print_info "Check: repository URL, SSH keys, network"
            exit 1
        fi
    fi
else
    print_warning "BACKEND_REPO not set"
    print_info "Set BACKEND_REPO in .env to auto-clone"
fi

# Create directories
echo ""
print_header "Workspace Structure"
mkdir -p "${WORKSPACE_ROOT}"/{backend,frontend,docs,logs,config} 2>/dev/null || true
print_success "Directories created"

# Check build tools
if [ -d "${BACKEND_DIR}" ]; then
    echo ""
    print_header "Build Tools"
    
    if [ -f "${BACKEND_DIR}/gradlew" ]; then
        print_success "Gradle wrapper found"
        [ -x "${BACKEND_DIR}/gradlew" ] && print_success "Gradle executable" || chmod +x "${BACKEND_DIR}/gradlew"
    fi
    
    if [ -f "${BACKEND_DIR}/mvnw" ]; then
        print_success "Maven wrapper found"
        [ -x "${BACKEND_DIR}/mvnw" ] && print_success "Maven executable" || chmod +x "${BACKEND_DIR}/mvnw"
    fi
    
    [ -f "${BACKEND_DIR}/pom.xml" ] && print_info "Maven project detected"
    [ -f "${BACKEND_DIR}/build.gradle" ] && print_info "Gradle project detected"
    [ -f "${BACKEND_DIR}/build.gradle.kts" ] && print_info "Gradle Kotlin DSL detected"
fi

# Environment summary
echo ""
echo "==========================================="
print_header "Environment Summary"
echo "==========================================="
print_info "OS: Ubuntu 22.04 LTS"
print_info "Java: $(java -version 2>&1 | head -1 | cut -d'"' -f2)"
print_info "Workspace: ${WORKSPACE_ROOT}"
print_info "User: $(whoami)"
print_info "Shell: ${SHELL}"
print_info "Clone Method: ${CLONE_METHOD}"
print_info "Backend Port: ${BACKEND_PORT:-8080}"
print_info "Frontend Port: ${FRONTEND_PORT:-5173}"
print_info "Spring Profile: ${SPRING_PROFILES_ACTIVE:-dev}"

# Run validation
echo ""
if [ -f "${WORKSPACE_ROOT}/scripts/validate.sh" ]; then
    print_header "Validation"
    bash "${WORKSPACE_ROOT}/scripts/validate.sh"
fi

# Success message
echo ""
echo "==========================================="
print_success "Setup Complete! 🎉"
echo "==========================================="
echo ""
print_info "Next Steps:"
echo ""
echo "  📂 Navigate to backend:"
echo "     cd /workspace/backend"
echo ""
echo "  🔨 Build project:"
echo "     ./gradlew build        # Gradle"
echo "     ./mvnw clean install   # Maven"
echo ""
echo "  🚀 Run application:"
echo "     ./gradlew bootRun      # Gradle"
echo "     ./mvnw spring-boot:run # Maven"
echo ""
echo "  🌐 Access API:"
echo "     http://localhost:8080"
echo ""