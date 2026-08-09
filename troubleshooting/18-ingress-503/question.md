# Question 18: Ingress 503 Service Unavailable (wrong backend port)

**Domain:** Troubleshooting  
**Difficulty:** 🟡 Medium  
**Estimated time:** ~8 minutes  
**Playground:** Single-node (`kubernetes-kubeadm-1node`)

---

## Setup

Run this before starting your timer:

```bash
bash setup.sh
```

Wait for: **`✅ Environment ready. Start your timer!`**

---

## Task

An application `storefront` is deployed in the `ecommerce` namespace. An Ingress resource named `store-ingress` is configured to route traffic for `store.example.com` to the service `storefront-svc`.

However, users are reporting a `503 Service Temporarily Unavailable` error when accessing the Ingress.

Your job is to investigate and fix the issue so that:
- The Ingress correctly routes traffic to the backend pods.
- You must fix the existing resources without deleting and recreating them.

---

## Acceptance Criteria

- [ ] `kubectl describe ingress store-ingress -n ecommerce` shows the correct backend service port.
- [ ] A curl request to the ingress controller with `Host: store.example.com` returns a valid HTTP response (not 503).

---

## Hints

<details>
<summary>💡 Hint 1 — Check the Ingress backend</summary>

Describe the Ingress resource:
```bash
kubectl describe ingress store-ingress -n ecommerce
```
*Look at the Rules section. It shows that it's forwarding traffic to `storefront-svc` on port `8080`.*
</details>

<details>
<summary>💡 Hint 2 — Check the Service</summary>

Describe the service to see what port it actually listens on:
```bash
kubectl get svc storefront-svc -n ecommerce
```
*You will see the service is exposing port `80`, not `8080`.*
</details>

<details>
<summary>💡 Hint 3 — Fix the Ingress</summary>

Edit the Ingress resource and update the port number to match the service.
```bash
kubectl edit ingress store-ingress -n ecommerce
```
</details>
