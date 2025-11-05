#!/usr/bin/env bash
set -euo pipefail

echo "📄 Loading Environment Variables..."

# Use PROJECT_HOME from environment, or default to /car-rental
PROJECT_HOME="${PROJECT_HOME:-/car-rental}"

# Load .env if it exists
if [ -f "${PROJECT_HOME}/.env" ]; then
    set -a
    source ${PROJECT_HOME}/.env
    set +a
    echo "✓ Loaded .env"
else
    echo "⚠ No .env file found (optional)"
fi

# Load .env.local if it exists (overrides .env)
if [ -f "${PROJECT_HOME}/.env.local" ]; then
    set -a
    source ${PROJECT_HOME}/.env.local
    set +a
    echo "✓ Loaded .env.local"
fi

echo ""