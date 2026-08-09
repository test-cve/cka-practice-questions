# Question 11: Pod stuck in Pending (NodeSelector mismatch)

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

A deployment called `frontend-ui` has been deployed in the `web` namespace. The operations team has noticed that the pods are stuck in the `Pending` state and are not being scheduled onto any node.

Your job is to investigate and fix the issue so that:
- All pods in the `frontend-ui` deployment in the `web` namespace successfully transition to the `Running` state.
- Do **not** remove the node selector requirements from the deployment. Instead, fix the cluster state to satisfy the deployment's requirements.

---

## Acceptance Criteria

- [ ] `kubectl get pods -n web` shows all pods in `Running` state.
- [ ] The `frontend-ui` deployment maintains its node affinity/selector constraints.

---

## Hints

<details>
<summary>💡 Hint 1 — Check why it's Pending</summary>

Describe the pending pod to see the scheduler events:
```bash
kubectl describe pod -l app=frontend-ui -n web
```
*Look at the bottom under Events. You will see a `FailedScheduling` event indicating that no nodes match the node selector.*
</details>

<details>
<summary>💡 Hint 2 — Identify the required labels</summary>

Look at the Pod spec inside the deployment to see what label the node selector requires:
```bash
kubectl get deployment frontend-ui -n web -o yaml | grep nodeSelector -A 2
```
*It expects a label `disktype: ssd`.*
</details>

<details>
<summary>💡 Hint 3 — Fix the node</summary>

Label your node to satisfy the requirement:
```bash
kubectl get nodes
kubectl label node controlplane disktype=ssd
```
</details>
