# Question 07: Network Policies — Default Deny and Selective Allow

**Domain:** Services & Networking  
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

There is a namespace called `secure-net` containing three deployments: `frontend`, `backend`, and `database`.

Currently, all pods can talk to each other. You need to secure the `secure-net` namespace using NetworkPolicies.

1. Create a NetworkPolicy named `default-deny` in the `secure-net` namespace that denies **all** ingress traffic to all pods in the namespace.
2. Create a NetworkPolicy named `allow-backend` in the `secure-net` namespace that allows:
   - Ingress traffic to pods labeled `app=backend` **only** from pods labeled `app=frontend`
3. Create a NetworkPolicy named `allow-database` in the `secure-net` namespace that allows:
   - Ingress traffic to pods labeled `app=database` **only** from pods labeled `app=backend` on TCP port 3306

*Note: Egress traffic rules are not required for this question, only Ingress.*

---

## Acceptance Criteria

- [ ] A pod in `secure-net` cannot be pinged from outside the namespace.
- [ ] The `frontend` pod can communicate with the `backend` pod.
- [ ] The `backend` pod can communicate with the `database` pod on port 3306.
- [ ] The `frontend` pod **cannot** communicate directly with the `database` pod.

---

## Hints

<details>
<summary>💡 Hint 1 — Default Deny All Ingress</summary>

A default deny-all ingress policy selects all pods (`{}`) and doesn't define any `ingress` rules.
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: secure-net
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```
</details>

<details>
<summary>💡 Hint 2 — Allowing specific traffic</summary>

Use `podSelector` within the `ingress` `from` block to restrict traffic sources.
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend
  namespace: secure-net
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
```
</details>
