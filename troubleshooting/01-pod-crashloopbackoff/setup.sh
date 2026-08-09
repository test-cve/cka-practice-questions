#!/usr/bin/env bash
# =============================================================================
# Q01 Setup Script — Pod CrashLoopBackOff
# Domain: Troubleshooting | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q01: Pod CrashLoopBackOff..."

# Create namespace
kubectl create namespace production --dry-run=client -o yaml | kubectl apply -f -

# Deploy nginx with a deliberately broken command (entrypoint override)
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: production
  labels:
    app: webapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: nginx:1.27
        command: ["/bin/sh", "-c", "exit 1"]   # ← FAULT: wrong command causes immediate exit
        ports:
        - containerPort: 80
EOF

echo ""
echo "⏳ Waiting for pods to enter CrashLoopBackOff (this takes ~30 seconds)..."
sleep 35

echo ""
echo "📋 Current state:"
kubectl get pods -n production
echo ""
echo "✅ Environment ready. Start your timer!"
