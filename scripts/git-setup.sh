#!/usr/bin/env bash
set -euo pipefail

YELLOW="\e[33m"; GREEN="\e[32m"; RED="\e[31m"; RESET="\e[0m"
say()      { echo -e "${YELLOW}▶ $*${RESET}"; }
ok()       { echo -e "${GREEN}✔ $*${RESET}"; }
fail()     { echo -e "${RED}✖ $*${RESET}" >&2; }

# --- Config from env (with sensible defaults) ---
CLONE_METHOD="${CLONE_METHOD:-ssh}"          # ssh | https
# Backend
BACKEND_GIT="${BACKEND_GIT:-}"               # e.g., git@github.com:you/backend.git
BACKEND_DIR="${BACKEND_DIR:-backend}"
BACKEND_BRANCH="${BACKEND_BRANCH:-}"         # optional
# Frontend
FRONTEND_GIT="${FRONTEND_GIT:-}"             # e.g., git@github.com:you/frontend.git
FRONTEND_DIR="${FRONTEND_DIR:-frontend}"
FRONTEND_BRANCH="${FRONTEND_BRANCH:-}"       # optional

# Optional HTTPS auth (if you ever set CLONE_METHOD=https)
GIT_USERNAME="${GIT_USERNAME:-}"             # for https
GIT_TOKEN="${GIT_TOKEN:-}"                   # for https token

# --- Helpers ---
clone_repo () {
  local url="$1" dest="$2" branch="$3"
  [ -z "$url" ] && return 0

  if [ -d "$dest/.git" ]; then
    ok "$dest already exists; skipping clone."
    return 0
  fi

  say "Cloning $url → $dest ${branch:+(branch $branch)}"
  if [ -n "$branch" ]; then
    git clone --depth 1 --branch "$branch" "$url" "$dest"
  else
    git clone --depth 1 "$url" "$dest"
  fi
  ok "Cloned $dest"
}

check_ssh () {
  # Only test when using ssh and GitHub host
  [ "$CLONE_METHOD" = "ssh" ] || return 0
  say "Testing SSH auth to GitHub (this may print a welcome message)…"
  # GitHub sometimes returns non-zero even on success; don't fail hard here
  ssh -T git@github.com || true

  # Ensure known_hosts exists to avoid first-write issues with read-only mounts
  mkdir -p ~/.ssh
  touch ~/.ssh/known_hosts
  ssh-keyscan -H github.com >> ~/.ssh/known_hosts 2>/dev/null || true
}

prepare_https () {
  # Lightweight askpass to feed token to git if using HTTPS
  [ "$CLONE_METHOD" = "https" ] || return 0
  if [ -z "${GIT_USERNAME}${GIT_TOKEN}" ]; then
    fail "CLONE_METHOD=https but GIT_USERNAME/GIT_TOKEN not set; skipping HTTPS clones."
    return 1
  fi
  export GIT_ASKPASS="/tmp/git-askpass.sh"
  cat >/tmp/git-askpass.sh <<'EOF'
#!/usr/bin/env bash
case "$1" in
  *Username*) echo "${GIT_USERNAME}";;
  *Password*) echo "${GIT_TOKEN}";;
  *) echo "";;
esac
EOF
  chmod +x /tmp/git-askpass.sh
}

fix_ownership () {
  # In Dev Containers 'vscode' user is standard
  if command -v sudo >/dev/null 2>&1; then
    sudo chown -R vscode:vscode "$1" || true
  fi
}

main () {
  say "postCreate: starting repo bootstrap…"

  if [ "$CLONE_METHOD" = "ssh" ]; then
    check_ssh
  else
    prepare_https || true
  fi

  clone_repo "$BACKEND_GIT"  "$BACKEND_DIR"  "$BACKEND_BRANCH"
  clone_repo "$FRONTEND_GIT" "$FRONTEND_DIR" "$FRONTEND_BRANCH"

  [ -d "$BACKEND_DIR" ]  && fix_ownership "$BACKEND_DIR"
  [ -d "$FRONTEND_DIR" ] && fix_ownership "$FRONTEND_DIR"

  ok "postCreate complete."
}

main "$@"
