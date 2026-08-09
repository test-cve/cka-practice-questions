#!/usr/bin/env bash
# =============================================================================
# Q19 Setup Script — Node cordoned and tainted
# Domain: Troubleshooting | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-2nodes  ⚠️ REQUIRES WORKER NODE
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q19: Node cordoned and tainted..."

# Verify we have a worker node
WORKER=$(kubectl get nodes --no-headers | grep -v "control-plane\|master" | awk '{print $1}' | head -1)
if [[ -z "$WORKER" ]]; then
  echo "❌ ERROR: No worker node found. Please use the kubernetes-kubeadm-2nodes playground."
  exit 1
fi

echo "📍 Found worker node: $WORKER"

# Cordon and taint the node
kubectl cordon "$WORKER"
kubectl taint node "$WORKER" maintenance=true:NoSchedule --overwrite

# Deploy an app (replica 1 might run on master if not tainted, but let's assume it scales up)
# Master nodes in kubeadm often have a NoSchedule taint by default, so pods will ONLY try the worker.
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: scaling-app
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: scaling-app
  template:
    metadata:
      labels:
        app: scaling-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
EOF

echo "⏳ Waiting 10 seconds to let scheduler try..."
sleep 10

echo ""
echo "📋 Current state:"
kubectl get nodes
kubectl get pods -l app=scaling-app
echo ""
echo "✅ Environment ready. Start your timer!"
