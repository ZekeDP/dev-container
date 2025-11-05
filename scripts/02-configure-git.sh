#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Configuring Git..."

# Use PROJECT_HOME from environment, or default to /car-rental
PROJECT_HOME="${PROJECT_HOME:-/car-rental}"

# Verify git is installed
if ! command -v git &> /dev/null; then
    echo "✗ Git not found!"
    exit 1
fi

# Configure git
git config --global --add safe.directory ${PROJECT_HOME}
git config --global init.defaultBranch main
git config --global core.editor nano

echo "✓ Git configured"
echo ""