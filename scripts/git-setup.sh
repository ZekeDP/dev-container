#!/usr/bin/env bash
set -euo pipefail

echo " Post-create setup starting..."

TARGET_DIR="dev-container/backend"
GIT_URL="${BACKEND_GIT:-}"
CLONE_METHOD="${CLONE_METHOD:-ssh}"

if [ -z "$GIT_URL" ]; then
  echo "? BACKEND_GIT not set  skipping clone."
  exit 0
fi

if [ -d "$TARGET_DIR/.git" ]; then
  echo " $TARGET_DIR already exists  skipping clone."
  exit 0
fi

if [ "$CLONE_METHOD" = "ssh" ]; then
  # This will print a success message if your key works; it may exit non-zero on success, so ignore error
  ssh -T git@github.com || true
fi

echo " Cloning $GIT_URL into $TARGET_DIR ..."
git clone --depth 1 "$GIT_URL" "$TARGET_DIR"

# Fix ownership for the vscode user inside the container
if command -v sudo >/dev/null 2>&1; then
  sudo chown -R vscode:vscode "$TARGET_DIR" || true
fi

echo " Clone done."