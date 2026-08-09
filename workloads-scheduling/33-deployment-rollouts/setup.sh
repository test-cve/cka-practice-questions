#!/bin/bash

echo "Setting up environment for Q33..."

# Create namespace
kubectl create namespace rollout-test --dry-run=client -o yaml | kubectl apply -f -

# Create initial deployment
kubectl create deployment webapp-deploy --image=nginx:1.14 --replicas=3 -n rollout-test --dry-run=client -o yaml > /tmp/webapp-deploy.yaml

# Apply the deployment
kubectl apply -f /tmp/webapp-deploy.yaml --record=true >/dev/null 2>&1

echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/webapp-deploy -n rollout-test

sleep 1
echo ""
echo "✅ Environment ready. Start your timer!"
