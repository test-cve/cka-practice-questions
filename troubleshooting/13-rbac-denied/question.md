# Question 13: ServiceAccount missing permissions (RBAC denied)

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

A pod named `api-reader` runs in the `data` namespace. It uses a ServiceAccount named `reader-sa`.
The pod's purpose is to list secrets in the `data` namespace. However, it is failing to do so because of an RBAC permissions issue.

Your job is to investigate and fix the issue so that:
- The `reader-sa` ServiceAccount has the necessary permissions to `list` and `get` secrets in the `data` namespace.
- You must create the missing Role and RoleBinding. Name the Role `secret-reader-role` and the RoleBinding `secret-reader-binding`.
- Do **not** recreate or modify the pod or the ServiceAccount itself.

---

## Acceptance Criteria

- [ ] `kubectl get role secret-reader-role -n data` exists and has `get` and `list` verbs for the `secrets` resource.
- [ ] `kubectl get rolebinding secret-reader-binding -n data` exists and binds `reader-sa` to `secret-reader-role`.
- [ ] The `api-reader` pod can successfully list secrets (you can check its logs or run a can-i check).

---

## Hints

<details>
<summary>💡 Hint 1 — Check the pod's logs</summary>

```bash
kubectl logs api-reader -n data
```
*You will see a "Forbidden" error, indicating it lacks permissions to list secrets.*
</details>

<details>
<summary>💡 Hint 2 — Verify the ServiceAccount</summary>

Check if a Role or RoleBinding exists for the ServiceAccount:
```bash
kubectl get role,rolebinding -n data
```
*You will likely find that they are missing entirely.*
</details>

<details>
<summary>💡 Hint 3 — Creating the RBAC resources</summary>

Create the role and binding imperatively:
```bash
kubectl create role secret-reader-role --verb=get,list --resource=secrets -n data
kubectl create rolebinding secret-reader-binding --role=secret-reader-role --serviceaccount=data:reader-sa -n data
```
</details>
