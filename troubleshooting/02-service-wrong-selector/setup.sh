#!/usr/bin/env bash
# =============================================================================
# Q02 Setup Script — Service Wrong Label Selector
# Domain: Troubleshooting | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q02: Service Not Routing Traffic..."

# Create namespace
kubectl create namespace backend --dry-run=client -o yaml | kubectl apply -f -

# Deploy a working nginx deployment with label: app=api-server
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server       # ← actual pod label
    spec:
      containers:
      - name: api
        image: nginx:1.27
        ports:
        - containerPort: 80
EOF

# Create a Service with a WRONG selector (app=api instead of app=api-server)
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: api-svc
  namespace: backend
spec:
  selector:
    app: api          # ← FAULT: wrong selector, doesn't match pod label app=api-server
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
EOF

echo ""
echo "⏳ Waiting for pods to be Running..."
kubectl wait --for=condition=ready pod -l app=api-server -n backend --timeout=90s

echo ""
echo "📋 Current state:"
kubectl get pods,svc,endpoints -n backend
echo ""
echo "✅ Environment ready. Start your timer!"
