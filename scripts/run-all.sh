#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "🚀 Running Setup Scripts"
echo "=========================================="
echo ""

# Array of scripts to run in order
SCRIPTS=(
    "/car-rental/scripts/01-load-env.sh"
    "/car-rental/scripts/02-configure-git.sh"
    "/car-rental/scripts/03-setup-ssh.sh"
    "/car-rental/scripts/04-clone-repo.sh"
    "/car-rental/scripts/05-finalize.sh"
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