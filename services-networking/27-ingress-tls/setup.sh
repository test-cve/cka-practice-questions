#!/bin/bash
kubectl create secret tls tls-secret --cert=/etc/kubernetes/pki/apiserver.crt --key=/etc/kubernetes/pki/apiserver.key --dry-run=client -o yaml | kubectl apply -f -
kubectl create deploy secure-app --image=nginx --dry-run=client -o yaml | kubectl apply -f -
kubectl expose deploy secure-app --name=secure-service --port=80 --dry-run=client -o yaml | kubectl apply -f -
echo "✅ Environment ready. Start your timer!"
