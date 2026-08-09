#!/usr/bin/env bash
# =============================================================================
# Q20 Setup Script — Kustomize overlay and patch
# Domain: Cluster Architecture | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q20: Kustomize..."

# Create the directory structure
sudo mkdir -p /opt/kustomize-app/base
sudo mkdir -p /opt/kustomize-app/overlays/production

# Create base resources
cat << 'EOF' | sudo tee /opt/kustomize-app/base/deployment.yaml > /dev/null
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
EOF

cat << 'EOF' | sudo tee /opt/kustomize-app/base/kustomization.yaml > /dev/null
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- deployment.yaml
EOF

# Ensure user owns the directory
sudo chown -R $USER:$USER /opt/kustomize-app

echo ""
echo "📋 Kustomize project created at /opt/kustomize-app"
echo ""
echo "✅ Environment ready. Start your timer!"
