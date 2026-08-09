# Q21: Kubeconfig contexts and user permissions

**Domain:** Cluster Architecture, Installation & Configuration  
**Difficulty:** 🟡 Medium  
**Estimated time:** ~12 minutes  
**Playground:** `kubernetes-kubeadm-1node`

---

## Setup

Run this before starting your timer:

```bash
bash setup.sh
```

Wait for: **`✅ Environment ready. Start your timer!`**

---

## Task

A new developer, **john**, needs access to the cluster. A private key (`/root/john.key`) and a Certificate Signing Request (`/root/john.csr`) have already been created for him.

1. Create a `CertificateSigningRequest` (CSR) object in the cluster named `john-csr` using the existing `/root/john.csr` file.
2. Approve the CSR.
3. Extract the signed certificate and save it to `/root/john.crt`.
4. A blank kubeconfig file exists at `/root/john-kubeconfig`. Update this file to:
   - Add the cluster `kubernetes` (pointing to `https://127.0.0.1:6443` with `insecure-skip-tls-verify=true`).
   - Add the user `john` using the client key (`/root/john.key`) and the newly generated client certificate (`/root/john.crt`).
   - Add a context named `john-context` that links the `kubernetes` cluster and the `john` user.
   - Set the current context to `john-context`.

---

## Acceptance Criteria

- [ ] A CSR named `john-csr` is approved and issued.
- [ ] The file `/root/john.crt` contains the valid signed certificate.
- [ ] The kubeconfig at `/root/john-kubeconfig` has the correct cluster, user, and context configured.
- [ ] Running `kubectl --kubeconfig=/root/john-kubeconfig config current-context` outputs `john-context`.

---

## Hints

<details>
<summary>💡 Hint 1 — Create the CSR</summary>

You need to encode the CSR file in base64 and create the YAML manifest.
```bash
cat /root/john.csr | base64 | tr -d "\n"
```
Create `csr.yaml`:
```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john-csr
spec:
  request: <BASE64_ENCODED_CSR>
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
```
</details>

<details>
<summary>💡 Hint 2 — Approve and extract</summary>

Approve it:
```bash
kubectl certificate approve john-csr
```
Extract the certificate:
```bash
kubectl get csr john-csr -o jsonpath='{.status.certificate}' | base64 --decode > /root/john.crt
```
</details>

<details>
<summary>💡 Hint 3 — Update Kubeconfig</summary>

Use the `kubectl config` command:
```bash
kubectl config --kubeconfig=/root/john-kubeconfig set-cluster kubernetes --server=https://127.0.0.1:6443 --insecure-skip-tls-verify=true
kubectl config --kubeconfig=/root/john-kubeconfig set-credentials john --client-certificate=/root/john.crt --client-key=/root/john.key
kubectl config --kubeconfig=/root/john-kubeconfig set-context john-context --cluster=kubernetes --user=john
kubectl config --kubeconfig=/root/john-kubeconfig use-context john-context
```
</details>
