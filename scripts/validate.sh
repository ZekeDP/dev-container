#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Environment Validation"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

check_pass() { echo -e "${GREEN}✓${NC} $1"; ((PASS++)); }
check_fail() { echo -e "${RED}✗${NC} $1"; ((FAIL++)); }
check_warn() { echo -e "${YELLOW}⚠${NC} $1"; ((WARN++)); }
check_info() { echo -e "${BLUE}ℹ${NC}   $1"; }

# Operating System
echo "Operating System:"
if [ -f /etc/os-release ]; then
    if grep -q "Ubuntu" /etc/os-release 2>/dev/null; then
        check_pass "Ubuntu detected"
        VERSION=$(grep VERSION_ID /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "unknown")
        check_info "Version: ${VERSION}"
        
        if [ "$VERSION" = "22.04" ]; then
            check_pass "Ubuntu 22.04 LTS (recommended)"
        fi
    else
        check_warn "Not Ubuntu"
    fi
else
    check_warn "Cannot detect OS"
fi
echo ""

# Java
echo "Java:"
if command -v java &>/dev/null; then
    check_pass "Java installed"
    
    JAVA_VER=$(java -version 2>&1 | head -1 || echo "unknown")
    if echo "$JAVA_VER" | grep -q "21"; then
        check_pass "Java 21"
    else
        check_fail "Not Java 21"
    fi
    
    if echo "$JAVA_VER" | grep -q "Temurin"; then
        check_pass "Eclipse Temurin"
    fi
else
    check_fail "Java not installed"
fi

if [ -n "${JAVA_HOME:-}" ]; then
    if [ -d "${JAVA_HOME}" ]; then
        check_pass "JAVA_HOME: ${JAVA_HOME}"
    else
        check_fail "JAVA_HOME set but invalid: ${JAVA_HOME}"
    fi
else
    check_warn "JAVA_HOME not set"
fi
echo ""

# Git
echo "Git:"
if command -v git &>/dev/null; then
    check_pass "Git installed"
    GIT_VER=$(git --version 2>/dev/null | awk '{print $3}' || echo "unknown")
    check_info "Version: ${GIT_VER}"
else
    check_fail "Git not installed"
fi
echo ""

# SSH
echo "SSH:"
if [ -d /home/vscode/.ssh ]; then
    check_pass "SSH directory exists"
    
    # Try to get permissions, don't fail if stat doesn't work
    PERMS=$(stat -c %a /home/vscode/.ssh 2>/dev/null || stat -f %A /home/vscode/.ssh 2>/dev/null || echo "unknown")
    if [ "$PERMS" = "700" ]; then
        check_pass "Permissions correct (700)"
    elif [ "$PERMS" = "unknown" ]; then
        check_warn "Cannot check permissions (likely OK)"
    else
        check_warn "Permissions: ${PERMS} (should be 700)"
    fi
    
    # Check for SSH keys
    if ls /home/vscode/.ssh/id_* 1>/dev/null 2>&1; then
        check_pass "SSH keys found"
    else
        check_warn "No SSH keys"
    fi
else
    check_warn "SSH not mounted (OK if using HTTPS)"
fi
echo ""

# Workspace
echo "Workspace:"
if [ -d /workspace ]; then
    check_pass "Workspace directory exists"
    if [ -w /workspace ]; then
        check_pass "Workspace writable"
    else
        check_fail "Workspace not writable"
    fi
else
    check_fail "Workspace directory missing"
fi
echo ""

# Build Tools
echo "Build Tools:"
if [ -d /workspace/backend ]; then
    FOUND_TOOL=false
    
    if [ -f /workspace/backend/gradlew ]; then
        check_pass "Gradle wrapper found"
        FOUND_TOOL=true
        if [ -x /workspace/backend/gradlew ]; then
            check_pass "Gradle executable"
        else
            check_warn "Gradle not executable (will be fixed)"
        fi
    fi
    
    if [ -f /workspace/backend/mvnw ]; then
        check_pass "Maven wrapper found"
        FOUND_TOOL=true
        if [ -x /workspace/backend/mvnw ]; then
            check_pass "Maven executable"
        else
            check_warn "Maven not executable (will be fixed)"
        fi
    fi
    
    if [ "$FOUND_TOOL" = false ]; then
        check_warn "No build wrapper found"
    fi
else
    check_warn "Backend not cloned yet"
fi
echo ""

# Caches
echo "Dependency Caches:"
if [ -d /home/vscode/.gradle ]; then
    check_pass "Gradle cache exists"
else
    check_warn "Gradle cache not created yet"
fi

if [ -d /home/vscode/.m2 ]; then
    check_pass "Maven cache exists"
else
    check_warn "Maven cache not created yet"
fi
echo ""

# Package Manager
echo "Package Manager:"
if command -v apt &>/dev/null; then
    check_pass "APT available"
else
    check_fail "APT not found"
fi
echo ""

# Network
echo "Network Connectivity:"
if ping -c 1 -W 2 github.com &>/dev/null; then
    check_pass "GitHub reachable"
else
    check_warn "Cannot reach GitHub"
fi

if ping -c 1 -W 2 packages.adoptium.net &>/dev/null; then
    check_pass "Adoptium reachable"
else
    check_warn "Cannot reach Adoptium"
fi
echo ""

# Required Commands
echo "Required Commands:"
for cmd in curl wget jq tar unzip; do
    if command -v "$cmd" &>/dev/null; then
        check_pass "$cmd"
    else
        check_fail "$cmd missing"
    fi
done
echo ""

# Summary
echo "========================================"
echo "Summary:"
echo "========================================"
echo -e "  ${GREEN}✓ Passed:  ${PASS}${NC}"
[ $WARN -gt 0 ] && echo -e "  ${YELLOW}⚠ Warnings: ${WARN}${NC}"
[ $FAIL -gt 0 ] && echo -e "  ${RED}✗ Failed:  ${FAIL}${NC}"
echo "========================================"

# Exit with success even if there are warnings
# Only fail on critical issues
if [ $FAIL -gt 0 ]; then
    echo ""
    echo -e "${RED}⚠️  Some checks failed${NC}"
    echo "The container may still work. Review issues above."
    echo ""
    exit 0  # Changed to 0 to not block container startup
elif [ $WARN -gt 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Core checks passed (warnings are OK)${NC}"
    exit 0
else
    echo ""
    echo -e "${GREEN}✓ All checks passed!${NC}"
    exit 0
fi