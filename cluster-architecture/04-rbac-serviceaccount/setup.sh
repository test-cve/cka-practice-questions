#!/usr/bin/env bash
# =============================================================================
# Q04 Setup Script — RBAC ServiceAccount / Role / RoleBinding
# Domain: Cluster Architecture | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q04: RBAC..."

# Create the namespace the candidate will work in
kubectl create namespace apps --dry-run=client -o yaml | kubectl apply -f -

# Pre-create some pods and configmaps in the namespace so testing is meaningful
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: apps
data:
  ENV: production
  LOG_LEVEL: info
---
apiVersion: v1
kind: Pod
metadata:
  name: sample-pod
  namespace: apps
spec:
  containers:
  - name: nginx
    image: nginx:1.27
EOF

echo ""
echo "⏳ Waiting for sample pod to be Running..."
kubectl wait --for=condition=ready pod/sample-pod -n apps --timeout=60s 2>/dev/null || true

echo ""
echo "📋 Current state in namespace 'apps':"
kubectl get all,configmaps -n apps
echo ""
echo "✅ Environment ready. Start your timer!"
