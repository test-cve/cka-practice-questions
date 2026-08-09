#!/usr/bin/env bash
# =============================================================================
# Q17 Setup Script — Scheduler disabled
# Domain: Troubleshooting | Difficulty: Hard
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q17: Scheduler disabled..."

# FAULT: Move the static pod manifest out of the manifests directory
# This causes the kubelet to stop the scheduler pod.
sudo mv /etc/kubernetes/manifests/kube-scheduler.yaml /etc/kubernetes/

echo "⏳ Waiting 30 seconds for the scheduler pod to terminate..."
sleep 30

# Deploy the pending app
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: worker-app
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: worker-app
  template:
    metadata:
      labels:
        app: worker-app
    spec:
      containers:
      - name: busybox
        image: busybox:1.36
        command: ["sleep", "3600"]
EOF

echo "⏳ Waiting 10 seconds to ensure pods remain Pending..."
sleep 10

echo ""
echo "📋 Current state:"
kubectl get pods
echo ""
echo "✅ Environment ready. Start your timer!"
