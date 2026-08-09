#!/usr/bin/env bash
# =============================================================================
# Q06 Setup Script — Helm Deploy, Upgrade, Rollback
# Domain: Cluster Architecture | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q06: Helm..."

# Verify helm is available (it is on Killercoda kubeadm playgrounds)
if ! command -v helm &>/dev/null; then
  echo "📦 Installing Helm..."
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

echo "✅ Helm version: $(helm version --short)"

# Ensure internet access is available (Killercoda has it)
echo ""
echo "📋 Helm is ready. The 'web' namespace does NOT pre-exist — you will create it."
echo ""
echo "✅ Environment ready. Start your timer!"
