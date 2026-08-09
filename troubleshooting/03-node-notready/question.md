# Question 03: Node NotReady — Diagnose and Fix

**Domain:** Troubleshooting  
**Difficulty:** 🔴 Hard  
**Estimated time:** ~12 minutes  
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

The cluster has a control plane node and a worker node (`node01`). The operations team has reported that `node01` is showing as `NotReady` and all pods scheduled to it are stuck in `Pending` or `Unknown` state.

Your job is to:
1. Investigate why `node01` is `NotReady`
2. Fix the underlying issue on `node01`
3. Ensure `node01` returns to `Ready` state without rebooting or replacing the node

**You have SSH access to `node01` from the control plane:** `ssh node01`

---

## Acceptance Criteria

- [ ] `kubectl get nodes` shows `node01` in `Ready` state
- [ ] `kubectl get pods -A -o wide | grep node01` shows pods running on `node01`
- [ ] No nodes are cordoned or tainted (unless they were before the exercise)

---

## Hints

<details>
<summary>💡 Hint 1 — Check the node status</summary>

```bash
kubectl describe node node01
kubectl get events --sort-by=.metadata.creationTimestamp
```
Look at the `Conditions` section in the describe output. A `NotReady` node often has a message about the container runtime or kubelet.
</details>

<details>
<summary>💡 Hint 2 — Check the kubelet</summary>

SSH to the affected node and check the kubelet service:
```bash
ssh node01
systemctl status kubelet
journalctl -u kubelet -n 50 --no-pager
```
</details>

<details>
<summary>💡 Hint 3 — Fixing the kubelet</summary>

```bash
ssh node01
systemctl start kubelet
systemctl enable kubelet
exit
# Back on controlplane — wait ~30 seconds then check:
kubectl get nodes
```
</details>
