#!/usr/bin/env bash
# =============================================================================
# Q15 Setup Script — Pod OOMKilled
# Domain: Troubleshooting | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q15: Pod OOMKilled..."

kubectl create namespace batch-jobs --dry-run=client -o yaml | kubectl apply -f -

# Deploy with an impossibly small memory limit to force OOMKilled
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: heavy-processor
  namespace: batch-jobs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: heavy-processor
  template:
    metadata:
      labels:
        app: heavy-processor
    spec:
      containers:
      - name: processor
        image: nginx:1.27
        resources:
          requests:
            memory: "1Mi"
          limits:
            memory: "2Mi"   # FAULT: nginx needs more than 2Mi to start, so it will OOM immediately
EOF

echo "⏳ Waiting 15 seconds to ensure pod crashes..."
sleep 15

echo ""
echo "📋 Current state:"
kubectl get pods -n batch-jobs
echo ""
echo "✅ Environment ready. Start your timer!"
