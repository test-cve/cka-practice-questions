#!/usr/bin/env bash
# =============================================================================
# Q10 Setup Script — PV, PVC, and Pod
# Domain: Storage | Difficulty: Easy
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q10: Persistent Volumes..."

kubectl create namespace logger --dry-run=client -o yaml | kubectl apply -f -

# Prepare the directory on the host node
sudo mkdir -p /mnt/logs
sudo chmod 777 /mnt/logs

echo ""
echo "✅ Environment ready. Start your timer!"
