#!/usr/bin/env bash
# =============================================================================
# Q05 Setup Script — etcd Backup & Restore
# Domain: Cluster Architecture | Difficulty: Hard
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q05: etcd Backup & Restore..."

# Create the critical namespace and important deployment
kubectl create namespace critical --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: important-app
  namespace: critical
  labels:
    app: important-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: important-app
  template:
    metadata:
      labels:
        app: important-app
    spec:
      containers:
      - name: app
        image: nginx:1.27
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: important-config
  namespace: critical
data:
  DB_HOST: "db.production.svc.cluster.local"
  APP_MODE: "production"
EOF

echo ""
echo "⏳ Waiting for important-app to be Running..."
kubectl wait --for=condition=ready pod -l app=important-app -n critical --timeout=90s

# Ensure the backup directory is prepared
mkdir -p /opt/etcd-backup

echo ""
echo "📋 Critical deployment status:"
kubectl get deployment important-app -n critical
echo ""
echo "ℹ️  etcd cert paths:"
echo "   --cacert=/etc/kubernetes/pki/etcd/ca.crt"
echo "   --cert=/etc/kubernetes/pki/etcd/server.crt"
echo "   --key=/etc/kubernetes/pki/etcd/server.key"
echo "   --endpoints=https://127.0.0.1:2379"
echo ""
echo "ℹ️  Backup destination: /opt/etcd-backup/snapshot.db"
echo ""
echo "✅ Environment ready. Start your timer!"
