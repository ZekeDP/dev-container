#!/usr/bin/env bash
set -euo pipefail

echo "🎉 Finalizing Setup..."

# Create workspace directories
mkdir -p /workspace/{backend,frontend,docs,logs} 2>/dev/null || true

# Display summary
echo ""
echo "=================================="
echo "✓ Setup Complete!"
echo "=================================="
echo ""
echo "Environment:"
echo "  - Java: $(java -version 2>&1 | head -1 | cut -d'"' -f2)"
echo "  - Git: $(git --version | awk '{print $3}')"
echo "  - User: $(whoami)"
echo ""
echo "Next steps:"
echo "  cd /workspace/backend"
echo "  ./gradlew build"
echo "  ./gradlew bootRun"
echo ""