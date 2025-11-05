#!/usr/bin/env bash
set -euo pipefail

echo "📦 Cloning Repositories..."

# Use PROJECT_HOME from environment, or default to /car-rental
PROJECT_HOME="${PROJECT_HOME:-/car-rental}"

BACKEND_REPO="${BACKEND_REPO:-}"
BACKEND_DIR="${PROJECT_HOME}/workspace/backend"
FRONTEND_REPO="${FRONTEND_REPO:-}"
FRONTEND_DIR="${PROJECT_HOME}/workspace/frontend"

# Clone Backend
if [ -z "$BACKEND_REPO" ]; then
    echo "⊘ BACKEND_REPO not set - skipping backend clone"
elif [ -d "$BACKEND_DIR/.git" ]; then
    echo "⊘ Backend repository already exists"
    cd "$BACKEND_DIR"
    echo "   Branch: $(git branch --show-current)"
else
    echo "📦 Cloning Backend..."
    echo "   URL: $BACKEND_REPO"
    echo "   Method: ${CLONE_METHOD:-ssh}"

    if git clone "$BACKEND_REPO" "$BACKEND_DIR"; then
        echo "✓ Backend repository cloned"

        # Make wrappers executable
        cd "$BACKEND_DIR"
        [ -f gradlew ] && chmod +x gradlew
        [ -f mvnw ] && chmod +x mvnw
    else
        echo "✗ Backend clone failed"
        exit 1
    fi
fi

echo ""

# Clone Frontend
if [ -z "$FRONTEND_REPO" ]; then
    echo "⊘ FRONTEND_REPO not set - skipping frontend clone"
elif [ -d "$FRONTEND_DIR/.git" ]; then
    echo "⊘ Frontend repository already exists"
    cd "$FRONTEND_DIR"
    echo "   Branch: $(git branch --show-current)"
else
    echo "📦 Cloning Frontend..."
    echo "   URL: $FRONTEND_REPO"
    echo "   Method: ${CLONE_METHOD:-ssh}"

    if git clone "$FRONTEND_REPO" "$FRONTEND_DIR"; then
        echo "✓ Frontend repository cloned"
    else
        echo "✗ Frontend clone failed"
        exit 1
    fi
fi

echo ""