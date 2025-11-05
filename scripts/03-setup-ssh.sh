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

# Check if host SSH directory is mounted
if [ ! -d "/tmp/host-ssh" ]; then
    echo "⚠ SSH directory not mounted at /tmp/host-ssh"
    echo ""
    exit 0
fi

# Create user's SSH directory if it doesn't exist
mkdir -p /home/vscode/.ssh

# Copy SSH keys from read-only mount to user directory
echo "   Copying SSH keys..."
cp -r /tmp/host-ssh/* /home/vscode/.ssh/ 2>/dev/null || {
    echo "⚠ Failed to copy SSH keys"
    exit 0
}

# Fix permissions
chmod 700 /home/vscode/.ssh
find /home/vscode/.ssh -type f -exec chmod 600 {} \;
find /home/vscode/.ssh -type f -name "*.pub" -exec chmod 644 {} \;

echo "   Keys copied with proper permissions"

# Test GitHub connection
if ssh -T git@github.com -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new 2>&1 | grep -q "successfully authenticated\|Hi"; then
    echo "✓ GitHub SSH verified"
else
    echo "⚠ SSH test completed (connection may have timed out)"
fi

echo ""