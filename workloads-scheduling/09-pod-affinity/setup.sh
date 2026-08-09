#!/usr/bin/env bash
# =============================================================================
# Q09 Setup Script — Pod Affinity & Resource Limits
# Domain: Workloads & Scheduling | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q09: Pod Affinity..."

kubectl create namespace app-stack --dry-run=client -o yaml | kubectl apply -f -

# Deploy redis-cache pod
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: redis-cache
  namespace: app-stack
  labels:
    tier: cache
spec:
  containers:
  - name: redis
    image: redis:alpine
EOF

echo "⏳ Waiting for redis-cache pod to be Ready..."
kubectl wait --for=condition=ready pod/redis-cache -n app-stack --timeout=60s

echo ""
echo "✅ Environment ready. Start your timer!"
