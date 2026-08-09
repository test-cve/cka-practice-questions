#!/usr/bin/env bash
# =============================================================================
# Q18 Setup Script — Ingress 503
# Domain: Troubleshooting | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q18: Ingress 503..."

# Install Ingress-Nginx Controller
echo "📦 Installing Ingress-Nginx Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml >/dev/null 2>&1

kubectl create namespace ecommerce --dry-run=client -o yaml | kubectl apply -f -

# Deploy the app and service (listening on port 80)
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: storefront
  namespace: ecommerce
spec:
  replicas: 1
  selector:
    matchLabels:
      app: storefront
  template:
    metadata:
      labels:
        app: storefront
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: storefront-svc
  namespace: ecommerce
spec:
  selector:
    app: storefront
  ports:
  - port: 80
    targetPort: 80
EOF

# Create the Ingress pointing to the WRONG port (8080 instead of 80)
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: store-ingress
  namespace: ecommerce
spec:
  rules:
  - host: store.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: storefront-svc
            port:
              number: 8080   # FAULT
EOF

echo "⏳ Waiting for pods to be Ready..."
kubectl wait --for=condition=ready pod -l app=storefront -n ecommerce --timeout=60s

echo "⏳ Waiting for Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s 2>/dev/null || true

echo ""
echo "✅ Environment ready. Start your timer!"
