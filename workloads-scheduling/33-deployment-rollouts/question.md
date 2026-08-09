# Q33: Deployment rollouts, history, and undo

**Domain:** Workloads & Scheduling  
**Difficulty:** 🟡 Medium  
**Estimated time:** ~8 minutes  
**Playground:** `kubernetes-kubeadm-1node`

---

## Setup

Run this before starting your timer:

```bash
bash setup.sh
```

Wait for: **`✅ Environment ready. Start your timer!`**

---

## Task

A deployment named `webapp-deploy` has been created in the `rollout-test` namespace. It currently runs `nginx:1.14`.

1. Update the deployment to use the image `nginx:1.24` and ensure that this change is recorded in the deployment's rollout history.
2. The operations team reports that `nginx:1.24` has a configuration issue. Undo the rollout back to the previous version (`nginx:1.14`).
3. Scale the deployment to `5` replicas.

---

## Acceptance Criteria

- [ ] `kubectl get deployment webapp-deploy -n rollout-test` shows 5 available replicas.
- [ ] The current image of the pods is `nginx:1.14`.
- [ ] The rollout history shows that a rollback occurred (a new revision should be created returning it to the original state).

---

## Hints

<details>
<summary>💡 Hint 1 — Update the image</summary>

Use the `kubectl set image` command with the `--record` flag (or configure it via edit) to change the image.
```bash
kubectl set image deployment/webapp-deploy nginx=nginx:1.24 -n rollout-test --record
```
</details>

<details>
<summary>💡 Hint 2 — Undo the rollout</summary>

Check the rollout history and then use `kubectl rollout undo`:
```bash
kubectl rollout history deployment webapp-deploy -n rollout-test
kubectl rollout undo deployment webapp-deploy -n rollout-test
```
</details>

<details>
<summary>💡 Hint 3 — Scale</summary>

Scale the deployment to 5 replicas:
```bash
kubectl scale deployment webapp-deploy --replicas=5 -n rollout-test
```
</details>
