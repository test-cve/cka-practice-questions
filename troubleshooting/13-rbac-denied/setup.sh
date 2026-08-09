#!/usr/bin/env bash
# =============================================================================
# Q13 Setup Script — ServiceAccount missing permissions (RBAC denied)
# Domain: Troubleshooting | Difficulty: Medium
# Target: Killercoda kubernetes-kubeadm-1node
# =============================================================================
set -euo pipefail

echo "🔧 Setting up Q13: RBAC Denied..."

kubectl create namespace data --dry-run=client -o yaml | kubectl apply -f -

# Create the ServiceAccount
kubectl create serviceaccount reader-sa -n data --dry-run=client -o yaml | kubectl apply -f -

# Create a dummy secret to read
kubectl create secret generic dummy-secret --from-literal=password=supersecret -n data --dry-run=client -o yaml | kubectl apply -f -

# Deploy the pod that tries to read secrets
# We use bitnami/kubectl as it comes with kubectl built-in
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: api-reader
  namespace: data
spec:
  serviceAccountName: reader-sa
  containers:
  - name: kubectl
    image: bitnami/kubectl:1.27
    command: ["/bin/sh", "-c", "while true; do kubectl get secrets; sleep 10; done"]
EOF

echo "⏳ Waiting for pod to start..."
kubectl wait --for=condition=ready pod/api-reader -n data --timeout=60s

echo ""
echo "📋 Current pod logs (showing the error):"
sleep 2 # let it attempt the first API call
kubectl logs api-reader -n data || true

echo ""
echo "✅ Environment ready. Start your timer!"
