#!/usr/bin/env bash
# =============================================================================
# Q03 Setup Script — Node NotReady (kubelet stopped)
# Domain: Troubleshooting | Difficulty: Hard
# Target: Killercoda kubernetes-kubeadm-2nodes  ⚠️ REQUIRES WORKER NODE
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q03: Node NotReady..."

# Verify we have a worker node
WORKER=$(kubectl get nodes --no-headers | grep -v "control-plane\|master" | awk '{print $1}' | head -1)
if [[ -z "$WORKER" ]]; then
  echo "❌ ERROR: No worker node found. Please use the kubernetes-kubeadm-2nodes playground."
  exit 1
fi

echo "📍 Found worker node: $WORKER"

# Deploy a test workload on the worker node
kubectl create namespace workloads --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app
  namespace: workloads
spec:
  replicas: 3
  selector:
    matchLabels:
      app: sample-app
  template:
    metadata:
      labels:
        app: sample-app
    spec:
      containers:
      - name: app
        image: nginx:1.27
        ports:
        - containerPort: 80
EOF

echo "⏳ Waiting for pods to be Running..."
kubectl wait --for=condition=ready pod -l app=sample-app -n workloads --timeout=90s

echo ""
echo "⚡ Injecting fault: stopping kubelet on $WORKER..."
ssh -o StrictHostKeyChecking=no "$WORKER" "sudo systemctl stop kubelet" 2>/dev/null || \
  ssh -o StrictHostKeyChecking=no node01 "sudo systemctl stop kubelet"

echo "⏳ Waiting for node to show NotReady (~40 seconds)..."
sleep 45

echo ""
echo "📋 Current state:"
kubectl get nodes
echo ""
kubectl get pods -n workloads -o wide
echo ""
echo "✅ Environment ready. Start your timer!"
