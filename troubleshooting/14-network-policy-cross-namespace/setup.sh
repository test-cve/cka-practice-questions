#!/usr/bin/env bash
# =============================================================================
# Q14 Setup Script — Network Policy blocking cross-namespace traffic
# Domain: Troubleshooting | Difficulty: Hard
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q14: Network Policy (Cross-Namespace)..."

kubectl create namespace frontend-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace backend-ns --dry-run=client -o yaml | kubectl apply -f -

# Deploy the backend
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: backend-ns
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
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
  name: api-server
  namespace: backend-ns
spec:
  selector:
    app: api-server
  ports:
  - port: 80
    targetPort: 80
EOF

# Deploy the frontend
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: web-ui
  namespace: frontend-ns
  labels:
    app: web-ui
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
EOF

# Create the NetworkPolicy in backend-ns
# FAULT: It expects the frontend namespace to have the label 'project: my-project', which it doesn't.
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-allow
  namespace: backend-ns
spec:
  podSelector:
    matchLabels:
      app: api-server
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          project: my-project
EOF

echo "⏳ Waiting for pods to be Ready..."
kubectl wait --for=condition=ready pod -l app=api-server -n backend-ns --timeout=60s
kubectl wait --for=condition=ready pod/web-ui -n frontend-ns --timeout=60s

echo ""
echo "✅ Environment ready. Start your timer!"
