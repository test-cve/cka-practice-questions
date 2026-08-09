# Question 15: Pod OOMKilled due to extreme memory limit

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

The `heavy-processor` deployment in the `batch-jobs` namespace is crashing. The pods are failing to stay running.

Your job is to investigate and fix the issue so that:
- The pods in the `heavy-processor` deployment can start successfully and stay in the `Running` state.
- Update the deployment to set the memory limit to `128Mi` instead of whatever is causing it to crash.
- Do **not** remove the memory requests/limits entirely; just fix the limit value.

---

## Acceptance Criteria

- [ ] `kubectl get pods -n batch-jobs` shows the pods in `Running` state.
- [ ] `kubectl describe pod -l app=heavy-processor -n batch-jobs` shows the memory limit is `128Mi`.

---

## Hints

<details>
<summary>💡 Hint 1 — Check why it's crashing</summary>

Get the pods and look at the Status column:
```bash
kubectl get pods -n batch-jobs
```
*You will likely see `OOMKilled` (Out Of Memory Killed) or `CrashLoopBackOff`.*

Describe the pod to see the previous termination state:
```bash
kubectl describe pod -l app=heavy-processor -n batch-jobs
```
*Look under `State: Terminated`, the `Reason` will be `OOMKilled`.*
</details>

<details>
<summary>💡 Hint 2 — Look at the resource limits</summary>

Check the resource limits defined in the deployment:
```bash
kubectl get deployment heavy-processor -n batch-jobs -o yaml | grep resources -A 4
```
*You'll notice the memory limit is set impossibly low (e.g., `1Mi`), which causes the container runtime to kill the process immediately when it tries to allocate memory.*
</details>

<details>
<summary>💡 Hint 3 — Fix the deployment</summary>

Edit the deployment and change the memory limit:
```bash
kubectl edit deployment heavy-processor -n batch-jobs
```
Under `resources.limits.memory`, change it to `128Mi`.
</details>
