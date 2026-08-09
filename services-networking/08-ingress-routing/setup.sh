#!/usr/bin/env bash
# =============================================================================
# Q08 Setup Script — Ingress Path-Based Routing
# Domain: Services & Networking | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q08: Ingress Path-Based Routing..."

# Install Ingress-Nginx Controller (required for testing Ingress resources)
echo "📦 Installing Ingress-Nginx Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml >/dev/null 2>&1

kubectl create namespace web-routing --dry-run=client -o yaml | kubectl apply -f -

# Deploy store-app
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: store-app
  namespace: web-routing
spec:
  replicas: 1
  selector:
    matchLabels:
      app: store
  template:
    metadata:
      labels:
        app: store
    spec:
      containers:
      - name: store
        image: nginx:1.27
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: store-svc
  namespace: web-routing
spec:
  selector:
    app: store
  ports:
  - port: 80
    targetPort: 80
EOF

# Deploy blog-app
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blog-app
  namespace: web-routing
spec:
  replicas: 1
  selector:
    matchLabels:
      app: blog
  template:
    metadata:
      labels:
        app: blog
    spec:
      containers:
      - name: blog
        image: httpd:2.4
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: blog-svc
  namespace: web-routing
spec:
  selector:
    app: blog
  ports:
  - port: 80
    targetPort: 80
EOF

echo "⏳ Waiting for pods to be Ready..."
kubectl wait --for=condition=ready pod -l app=store -n web-routing --timeout=60s
kubectl wait --for=condition=ready pod -l app=blog -n web-routing --timeout=60s

echo "⏳ Waiting for Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s 2>/dev/null || true

echo ""
echo "✅ Environment ready. Start your timer!"
