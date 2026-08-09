#!/usr/bin/env bash
# =============================================================================
# Q11 Setup Script — Pod Pending NodeSelector
# Domain: Troubleshooting | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q11: Pod Pending (NodeSelector)..."

kubectl create namespace web --dry-run=client -o yaml | kubectl apply -f -

# Deploy with a node selector that doesn't match any nodes
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-ui
  namespace: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend-ui
  template:
    metadata:
      labels:
        app: frontend-ui
    spec:
      nodeSelector:
        disktype: ssd     # FAULT: No node has this label
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
EOF

echo "⏳ Waiting 15 seconds to ensure pods remain Pending..."
sleep 15

echo ""
echo "📋 Current state:"
kubectl get pods -n web
echo ""
echo "✅ Environment ready. Start your timer!"
