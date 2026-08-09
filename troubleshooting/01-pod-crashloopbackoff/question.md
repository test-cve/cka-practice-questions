# Question 01: Pod Stuck in CrashLoopBackOff

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

A deployment called `webapp` has been deployed in the namespace `production` by another team member. Users are reporting that the application is completely unavailable.

Your job is to investigate and fix the issue so that:
- The deployment `webapp` in namespace `production` has all pods in `Running` state
- The fix must be applied to the existing deployment (do not delete and recreate it)
- The container should run `nginx` and serve traffic on port `80`

**Do not change the deployment name, namespace, or the number of replicas.**

---

## Acceptance Criteria

- [ ] `kubectl get pods -n production` shows all pods in `Running` state (no CrashLoopBackOff)
- [ ] `kubectl get deployment webapp -n production` shows `READY` as `2/2`
- [ ] The container image is `nginx:1.27`
- [ ] Pod logs show nginx startup output (no errors)

---

## Hints

<details>
<summary>💡 Hint 1 — Where to look first</summary>

Check what's happening with the pods:
```bash
kubectl get pods -n production
kubectl describe pod <pod-name> -n production
kubectl logs <pod-name> -n production
```
</details>

<details>
<summary>💡 Hint 2 — What to look for</summary>

In a CrashLoopBackOff, the container starts and immediately exits. Look at the `Command` field in `describe` output and compare it to what the image actually expects to run.
</details>

<details>
<summary>💡 Hint 3 — How to fix it</summary>

```bash
kubectl edit deployment webapp -n production
```
Remove or correct the `command` field in the container spec.
</details>
