# Solution: Q21 (Kubeconfig contexts and user permissions)

## Step 1: Create the CSR object

First, encode the CSR in base64 (removing newlines):
```bash
cat /root/john.csr | base64 | tr -d "\n"
```

Create a file named `csr.yaml`:
```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john-csr
spec:
  request: <paste-the-base64-string-here>
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
```

Apply the file:
```bash
kubectl apply -f csr.yaml
```

## Step 2: Approve the CSR and extract the certificate

Check the CSR status (it should be Pending):
```bash
kubectl get csr
```

Approve the CSR:
```bash
kubectl certificate approve john-csr
```

Extract the issued certificate and decode it, saving it to `/root/john.crt`:
```bash
kubectl get csr john-csr -o jsonpath='{.status.certificate}' | base64 --decode > /root/john.crt
```

Verify the certificate file:
```bash
cat /root/john.crt
```

## Step 3: Configure the kubeconfig

Use `kubectl config` to set up the cluster, user, and context in `/root/john-kubeconfig`.

Set the cluster:
```bash
kubectl config --kubeconfig=/root/john-kubeconfig set-cluster kubernetes --server=https://127.0.0.1:6443 --insecure-skip-tls-verify=true
```

Set the user credentials (using embed-certs is also an option, but pointing to the files works fine):
```bash
kubectl config --kubeconfig=/root/john-kubeconfig set-credentials john --client-certificate=/root/john.crt --client-key=/root/john.key --embed-certs=true
```

Set the context linking the user and cluster:
```bash
kubectl config --kubeconfig=/root/john-kubeconfig set-context john-context --cluster=kubernetes --user=john
```

Set the current context:
```bash
kubectl config --kubeconfig=/root/john-kubeconfig use-context john-context
```

Verify the configuration:
```bash
kubectl --kubeconfig=/root/john-kubeconfig config view
```
