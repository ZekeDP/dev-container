#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "🚀 Running Setup Scripts"
echo "=========================================="
echo ""

# Array of scripts to run in order
SCRIPTS=(
    "/workspace/scripts/01-load-env.sh"
    "/workspace/scripts/02-configure-git.sh"
    "/workspace/scripts/03-setup-ssh.sh"
    "/workspace/scripts/04-clone-repo.sh"
    "/workspace/scripts/05-finalize.sh"
)

# Run each script
for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        echo "Running: $(basename "$script")"
        if bash "$script"; then
            echo "✓ $(basename "$script") completed"
        else
            echo "✗ $(basename "$script") failed"
            exit 1
        fi
        echo ""
    else
        echo "⚠ Script not found: $script"
        echo ""
    fi
done

echo "=========================================="
echo "✅ All setup scripts completed"
echo "=========================================="