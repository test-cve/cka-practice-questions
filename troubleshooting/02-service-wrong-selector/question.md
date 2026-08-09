# Question 02: Service Not Routing Traffic to Pods

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

A deployment `api-server` and a Service `api-svc` exist in the namespace `backend`. The development team reports that requests to the service are not reaching any pods — the service appears to have no endpoints.

Your job is to investigate and fix the connectivity issue so that:
- The Service `api-svc` in namespace `backend` correctly routes traffic to the `api-server` deployment pods
- Do **not** delete or recreate the Deployment or Service — fix in place
- Do **not** change the service type or port

---

## Acceptance Criteria

- [ ] `kubectl get endpoints api-svc -n backend` shows at least one endpoint IP (not `<none>`)
- [ ] `kubectl run test --rm -it --image=busybox --restart=Never -- wget -qO- http://api-svc.backend` returns a response
- [ ] The Deployment pods are `Running` and untouched

---

## Hints

<details>
<summary>💡 Hint 1 — How services find pods</summary>

A Service routes traffic based on **label selectors**. If the selector doesn't match any pod labels, the service will have no endpoints.

```bash
kubectl describe svc api-svc -n backend
kubectl get pods -n backend --show-labels
```
</details>

<details>
<summary>💡 Hint 2 — Comparing labels</summary>

Compare the `Selector` field in `describe svc` with the actual labels on the pods. One of them will be wrong or mismatched.
</details>

<details>
<summary>💡 Hint 3 — Fixing the service</summary>

```bash
kubectl edit svc api-svc -n backend
```
Update the `selector` field to match the actual pod labels.
</details>
