#!/usr/bin/env bash
set -euo pipefail

echo "🎉 Finalizing Setup..."

# Use PROJECT_HOME from environment, or default to /car-rental
PROJECT_HOME="${PROJECT_HOME:-/car-rental}"

# Create workspace directories
mkdir -p ${PROJECT_HOME}/{workspace/backend,workspace/frontend,docs,logs} 2>/dev/null || true

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
echo "  - Project Home: ${PROJECT_HOME}"
echo ""
echo "Next steps:"
echo ""
echo "Backend (Spring Boot):"
echo "  cd ${PROJECT_HOME}/workspace/backend"
echo "  ./gradlew build"
echo "  ./gradlew bootRun"
echo ""
echo "Frontend (if cloned):"
echo "  cd ${PROJECT_HOME}/workspace/frontend"
echo "  npm install"
echo "  npm run dev"
echo ""