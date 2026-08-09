#!/usr/bin/env bash
# =============================================================================
# Q16 Setup Script — kube-apiserver down
# Domain: Troubleshooting | Difficulty: Hard
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q16: kube-apiserver down..."

# Inject a bad flag into the kube-apiserver manifest
sudo sed -i 's|- kube-apiserver|- kube-apiserver\n    - --audit-log-path-wrong=/var/log/audit.log|' /etc/kubernetes/manifests/kube-apiserver.yaml

echo "⏳ Waiting 30 seconds for the kubelet to restart the apiserver (and fail)..."
sleep 30

echo ""
echo "📋 Testing kubectl (should fail):"
kubectl get nodes || true

echo ""
echo "✅ Environment ready. Start your timer!"
