#!/usr/bin/env bash
# =============================================================================
# Q12 Setup Script — CoreDNS ConfigMap corrupted
# Domain: Troubleshooting | Difficulty: Hard
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q12: CoreDNS ConfigMap corrupted..."

# Break the CoreDNS ConfigMap by changing forward . /etc/resolv.conf to forward . 1.2.3.4
kubectl get configmap coredns -n kube-system -o yaml | \
  sed 's|forward . /etc/resolv.conf|forward . 1.2.3.4|g' | \
  kubectl apply -f -

# Restart CoreDNS to pick up the broken config immediately
kubectl delete pods -l k8s-app=kube-dns -n kube-system

# Deploy a test pod
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test-app
  template:
    metadata:
      labels:
        app: test-app
    spec:
      containers:
      - name: busybox
        image: busybox:1.36
        command: ["sleep", "3600"]
EOF

echo "⏳ Waiting for test-app and coredns pods to be Ready..."
kubectl wait --for=condition=ready pod -l app=test-app -n default --timeout=60s
kubectl wait --for=condition=ready pod -l k8s-app=kube-dns -n kube-system --timeout=60s

echo ""
echo "✅ Environment ready. Start your timer!"
