#!/bin/bash

echo "Setting up environment for Q21..."

# Generate key and CSR for john
openssl genrsa -out /root/john.key 2048 >/dev/null 2>&1
openssl req -new -key /root/john.key -out /root/john.csr -subj "/CN=john/O=developers" >/dev/null 2>&1

# Create an empty kubeconfig file
touch /root/john-kubeconfig

sleep 1
echo ""
echo "✅ Environment ready. Start your timer!"
