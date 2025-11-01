#!/usr/bin/env bash
set -e

# Ensure script is run with bash (even on Windows)
if [ -z "$BASH_VERSION" ]; then
    echo "This script must be run with bash"
    exec bash "$0" "$@"
fi

# ...existing code...
GREEN="\e[32m"; YELLOW="\e[33m"; RED="\e[31m"; RESET="\e[0m"

echo -e "${YELLOW}▶ Post-create setup starting...${RESET}"

TARGET_DIR="backend"
GIT_URL="${BACKEND_GIT:-}"
CLONE_METHOD="${CLONE_METHOD:-ssh}"

info()    { echo -e "${YELLOW}▶ $*${RESET}"; }
success() { echo -e "${GREEN}✔ $*${RESET}"; }
error()   { echo -e "${RED}✖ $*${RESET}" >&2; }

if [ "$CLONE_METHOD" != "ssh" ]; then
  info "CLONE_METHOD=$CLONE_METHOD — skipping SSH clone."
  exit 0
fi

if [ -z "$GIT_URL" ]; then
  error "BACKEND_GIT not defined — skipping clone."
  exit 0
fi

if [ -d "$TARGET_DIR/.git" ]; then
  success "$TARGET_DIR already exists — skipping clone."
  exit 0
fi

info "Testing SSH to GitHub..."
if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  error "SSH authentication failed. Verify your mounted ~/.ssh and GitHub key."
  exit 1
fi

info "Cloning $GIT_URL into $TARGET_DIR..."
git clone --depth 1 "$GIT_URL" "$TARGET_DIR"

info "Fixing ownership..."
sudo chown -R vscode:vscode "$TARGET_DIR"

success "Backend repository cloned successfully!"
