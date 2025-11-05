#!/usr/bin/env bash
set -euo pipefail

echo "📄 Loading Environment Variables..."

# Load .env if it exists
if [ -f "/workspace/.env" ]; then
    set -a
    source /workspace/.env
    set +a
    echo "✓ Loaded .env"
else
    echo "⚠ No .env file found (optional)"
fi

# Load .env.local if it exists (overrides .env)
if [ -f "/workspace/.env.local" ]; then
    set -a
    source /workspace/.env.local
    set +a
    echo "✓ Loaded .env.local"
fi

echo ""