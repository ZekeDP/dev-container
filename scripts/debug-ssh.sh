#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "🔍 SSH Debugging"
echo "=========================================="
echo ""

echo "1. Checking /tmp/host-ssh mount..."
if [ -d "/tmp/host-ssh" ]; then
    echo "   ✓ /tmp/host-ssh exists"
    ls -la /tmp/host-ssh/ | head -10
else
    echo "   ✗ /tmp/host-ssh NOT found"
fi
echo ""

echo "2. Checking ~/.ssh directory..."
if [ -d "$HOME/.ssh" ]; then
    echo "   ✓ ~/.ssh exists"
    ls -la ~/.ssh/
else
    echo "   ✗ ~/.ssh NOT found"
fi
echo ""

echo "3. Checking SSH key permissions..."
if [ -f "$HOME/.ssh/id_ed25519" ]; then
    echo "   ✓ id_ed25519 found"
    ls -l ~/.ssh/id_ed25519
elif [ -f "$HOME/.ssh/id_rsa" ]; then
    echo "   ✓ id_rsa found"
    ls -l ~/.ssh/id_rsa
else
    echo "   ✗ No SSH keys found"
fi
echo ""

echo "4. Testing GitHub SSH connection..."
ssh -T git@github.com -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new 2>&1 || true
echo ""

echo "5. Checking SSH agent..."
if [ -n "${SSH_AUTH_SOCK:-}" ]; then
    echo "   SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
    if [ -S "$SSH_AUTH_SOCK" ]; then
        echo "   ✓ SSH agent socket exists"
        ssh-add -l 2>&1 || echo "   (No keys in agent or agent not responding)"
    else
        echo "   ✗ SSH agent socket not found"
    fi
else
    echo "   ℹ SSH_AUTH_SOCK not set"
fi
echo ""

echo "6. Testing git clone with verbose output..."
echo "   Repository: ${BACKEND_REPO:-not set}"
if [ -n "${BACKEND_REPO:-}" ]; then
    GIT_SSH_COMMAND="ssh -v" git ls-remote "$BACKEND_REPO" 2>&1 | head -20
fi
echo ""

echo "=========================================="
echo "Debug complete"
echo "=========================================="
