# Question 19: Node cordoned and tainted

**Domain:** Troubleshooting  
**Difficulty:** 🟡 Medium  
**Estimated time:** ~8 minutes  
**Playground:** ⚠️ Two-node (`kubernetes-kubeadm-2nodes`) — requires a worker node

---

## Setup

Run this before starting your timer:

```bash
bash setup.sh
```

Wait for: **`✅ Environment ready. Start your timer!`**

---

## Task

The operations team attempted to perform maintenance on the worker node (`node01`). The maintenance was aborted, but they forgot to revert the node state.

A deployment `scaling-app` in the `default` namespace is trying to scale from 1 to 3 replicas, but the new pods are stuck in the `Pending` state.

Your job is to:
1. Make `node01` schedulable again.
2. Ensure the `scaling-app` pods are successfully scheduled and running.

---

## Acceptance Criteria

- [ ] `node01` does not have a `SchedulingDisabled` status.
- [ ] `node01` does not have any `NoSchedule` taints (that aren't standard system taints).
- [ ] `kubectl get pods -l app=scaling-app` shows 3 pods in the `Running` state.

---

## Hints

<details>
<summary>💡 Hint 1 — Check the Node status</summary>

```bash
kubectl get nodes
```
*You will see `node01` has the status `Ready,SchedulingDisabled`.*
</details>

<details>
<summary>💡 Hint 2 — Uncordon the node</summary>

You need to uncordon the node to remove the `SchedulingDisabled` status.
```bash
kubectl uncordon node01
```
</details>

<details>
<summary>💡 Hint 3 — Check for Taints</summary>

If the pods are still Pending after uncordoning, check if the node has a taint left over from maintenance.
```bash
kubectl describe node node01 | grep Taint
```
*You will likely see a custom taint.*

Remove it using the minus (`-`) syntax at the end of the taint key:
```bash
kubectl taint node node01 maintenance-
```
</details>
