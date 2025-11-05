#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Configuring Git..."

# Verify git is installed
if ! command -v git &> /dev/null; then
    echo "✗ Git not found!"
    exit 1
fi

# Configure git
git config --global --add safe.directory /workspace
git config --global init.defaultBranch main
git config --global core.editor nano

echo "✓ Git configured"
echo ""