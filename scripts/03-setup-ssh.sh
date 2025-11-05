#!/usr/bin/env bash
set -euo pipefail

echo "🔑 Setting up SSH..."

# Only run if using SSH method
CLONE_METHOD="${CLONE_METHOD:-ssh}"

if [ "$CLONE_METHOD" != "ssh" ]; then
    echo "⊘ Skipping (using HTTPS)"
    echo ""
    exit 0
fi

# Check if SSH directory exists
if [ ! -d "/home/vscode/.ssh" ]; then
    echo "⚠ SSH directory not mounted"
    echo ""
    exit 0
fi

# Fix permissions
chmod 700 /home/vscode/.ssh 2>/dev/null || true
find /home/vscode/.ssh -type f -exec chmod 600 {} \; 2>/dev/null || true

# Test GitHub connection
if ssh -T git@github.com -o ConnectTimeout=5 2>&1 | grep -q "successfully authenticated\|Hi"; then
    echo "✓ GitHub SSH verified"
else
    echo "⚠ SSH test completed"
fi

echo ""