# Question 17: Scheduler disabled (replica scaled to 0)

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

A new deployment called `worker-app` was just created in the `default` namespace. However, the pods are stuck in the `Pending` state.

Upon further investigation, no events are being generated for these pods regarding scheduling (e.g., no `FailedScheduling` events). It appears the Kubernetes scheduler is not functioning at all.

Your job is to investigate and fix the issue so that:
- The `kube-scheduler` is running again.
- The `worker-app` pods successfully transition to the `Running` state.
- Do **not** manually schedule the pods (e.g., by modifying the pod spec to include a nodeName).

---

## Acceptance Criteria

- [ ] `kubectl get pods -n kube-system -l component=kube-scheduler` shows a running scheduler pod.
- [ ] `kubectl get pods -l app=worker-app -n default` shows the pods in `Running` state.

---

## Hints

<details>
<summary>💡 Hint 1 — Check the scheduler status</summary>

Check if the scheduler pod is actually running in the `kube-system` namespace.
```bash
kubectl get pods -n kube-system
```
*If you don't see a `kube-scheduler` pod, or if you see a deployment scaled to 0, that's the issue.*
</details>

<details>
<summary>💡 Hint 2 — Static pods vs Deployments</summary>

Normally, `kube-scheduler` is a static pod located in `/etc/kubernetes/manifests/kube-scheduler.yaml`. Check if that file exists.
```bash
ls -l /etc/kubernetes/manifests/
```
*If it was moved out of that directory, the kubelet will stop managing it.*
</details>

<details>
<summary>💡 Hint 3 — Fixing the issue</summary>

Move the manifest back into the `/etc/kubernetes/manifests/` directory.
```bash
sudo mv /etc/kubernetes/kube-scheduler.yaml /etc/kubernetes/manifests/
```
Wait a few moments, and the kubelet will start the scheduler, which will then schedule your pending pods.
</details>
