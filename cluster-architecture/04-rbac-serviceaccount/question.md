# Question 04: RBAC — ServiceAccount, Role & RoleBinding

**Domain:** Cluster Architecture, Installation & Configuration  
**Difficulty:** 🟡 Medium  
**Estimated time:** ~10 minutes  
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

A microservice needs read-only access to pods and configmaps within its own namespace. You need to set up the RBAC configuration for it.

In the namespace `apps`, do the following:

1. Create a `ServiceAccount` named `monitor-sa`
2. Create a `Role` named `pod-reader` that allows:
   - `get`, `list`, `watch` on `pods`
   - `get`, `list` on `configmaps`
3. Create a `RoleBinding` named `monitor-binding` that binds `monitor-sa` to the `pod-reader` role
4. Verify the permissions work by running an auth can-i check

---

## Acceptance Criteria

- [ ] `kubectl get serviceaccount monitor-sa -n apps` exists
- [ ] `kubectl get role pod-reader -n apps` exists with correct verbs
- [ ] `kubectl get rolebinding monitor-binding -n apps` binds `monitor-sa` to `pod-reader`
- [ ] `kubectl auth can-i list pods -n apps --as=system:serviceaccount:apps:monitor-sa` returns `yes`
- [ ] `kubectl auth can-i delete pods -n apps --as=system:serviceaccount:apps:monitor-sa` returns `no`

---

## Hints

<details>
<summary>💡 Hint 1 — Imperative commands save time</summary>

```bash
kubectl create serviceaccount monitor-sa -n apps
kubectl create role pod-reader --verb=get,list,watch --resource=pods --verb=get,list --resource=configmaps -n apps
kubectl create rolebinding monitor-binding --role=pod-reader --serviceaccount=apps:monitor-sa -n apps
```
</details>

<details>
<summary>💡 Hint 2 — Multi-resource roles via YAML</summary>

The imperative `kubectl create role` command doesn't easily support multiple resources with different verbs in one shot. Consider using `--dry-run=client -o yaml` and editing the YAML.
</details>
