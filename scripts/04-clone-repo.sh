#!/usr/bin/env bash
set -euo pipefail

echo "📦 Cloning Repository..."

BACKEND_REPO="${BACKEND_REPO:-}"
BACKEND_DIR="/workspace/backend"

# Check if repo is configured
if [ -z "$BACKEND_REPO" ]; then
    echo "⊘ BACKEND_REPO not set - skipping clone"
    echo ""
    exit 0
fi

# Check if already cloned
if [ -d "$BACKEND_DIR/.git" ]; then
    echo "⊘ Repository already exists"
    cd "$BACKEND_DIR"
    echo "   Branch: $(git branch --show-current)"
    echo ""
    exit 0
fi

# Clone the repository
echo "   URL: $BACKEND_REPO"
echo "   Method: ${CLONE_METHOD:-ssh}"

if git clone "$BACKEND_REPO" "$BACKEND_DIR"; then
    echo "✓ Repository cloned"
    
    # Make wrappers executable
    cd "$BACKEND_DIR"
    [ -f gradlew ] && chmod +x gradlew
    [ -f mvnw ] && chmod +x mvnw
else
    echo "✗ Clone failed"
    exit 1
fi

echo ""