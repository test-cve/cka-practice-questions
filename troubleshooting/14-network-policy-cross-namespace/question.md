# Question 14: Network Policy blocking cross-namespace traffic

**Domain:** Troubleshooting  
**Difficulty:** 🔴 Hard  
**Estimated time:** ~12 minutes  
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

There are two namespaces: `frontend-ns` and `backend-ns`.
- In `frontend-ns`, there is a pod `web-ui`.
- In `backend-ns`, there is a pod `api-server` and a NetworkPolicy named `api-allow`.

The `api-allow` NetworkPolicy is supposed to allow traffic from the `frontend-ns` namespace to the `api-server` pod. However, it is currently failing; the `web-ui` pod cannot reach `api-server`.

Your job is to investigate and fix the issue so that:
- The `web-ui` pod can successfully reach the `api-server` pod on port 80.
- Do **not** delete the NetworkPolicy, and do **not** use a default allow-all policy. Fix the existing `api-allow` policy or the namespace labels to make it work.

---

## Acceptance Criteria

- [ ] `kubectl -n frontend-ns exec web-ui -- wget -qO- http://api-server.backend-ns` succeeds and returns HTML output.
- [ ] The `api-allow` NetworkPolicy still strictly selects the `frontend-ns` namespace or specific pods.

---

## Hints

<details>
<summary>💡 Hint 1 — Check the NetworkPolicy</summary>

Inspect the existing policy:
```bash
kubectl describe networkpolicy api-allow -n backend-ns
```
*Look at the `Allowing ingress traffic:` section. It might be selecting namespaces with a specific label.*
</details>

<details>
<summary>💡 Hint 2 — Check namespace labels</summary>

Check if `frontend-ns` has the label that the NetworkPolicy is expecting:
```bash
kubectl get ns --show-labels
```
*If the policy expects `project: my-project` but the namespace doesn't have it, the traffic will be blocked.*
</details>

<details>
<summary>💡 Hint 3 — Two ways to fix</summary>

You can either:
1. Label the `frontend-ns` namespace to match the policy: `kubectl label ns frontend-ns project=my-project`
2. Edit the NetworkPolicy to match the existing labels on `frontend-ns` (e.g., matching on `kubernetes.io/metadata.name: frontend-ns`).
</details>
