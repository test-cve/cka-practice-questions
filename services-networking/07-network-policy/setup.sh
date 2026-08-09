#!/usr/bin/env bash
# =============================================================================
# Q07 Setup Script — Network Policies
# Domain: Services & Networking | Difficulty: Hard
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q07: Network Policies..."

kubectl create namespace secure-net --dry-run=client -o yaml | kubectl apply -f -

# Create the frontend deployment
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: secure-net
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
EOF

# Create the backend deployment
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: secure-net
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
EOF

# Create the database deployment (using a fake db port for the exercise)
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: database
  namespace: secure-net
spec:
  replicas: 1
  selector:
    matchLabels:
      app: database
  template:
    metadata:
      labels:
        app: database
    spec:
      containers:
      - name: db
        image: nginx:1.27
        ports:
        - containerPort: 3306
EOF

echo "⏳ Waiting for pods to be Ready..."
kubectl wait --for=condition=ready pod -l app=frontend -n secure-net --timeout=60s
kubectl wait --for=condition=ready pod -l app=backend -n secure-net --timeout=60s
kubectl wait --for=condition=ready pod -l app=database -n secure-net --timeout=60s

echo ""
echo "✅ Environment ready. Start your timer!"
