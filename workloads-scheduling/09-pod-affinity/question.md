# Question 09: Pod Affinity and Resource Limits

**Domain:** Workloads & Scheduling  
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

A redis cache pod named `redis-cache` is currently running in the `app-stack` namespace with the label `tier=cache`.

You need to deploy a frontend application that meets the following requirements:
1. Create a pod named `frontend-app` in the `app-stack` namespace using the `nginx:1.27` image.
2. The `frontend-app` pod must be scheduled on the same node as the `redis-cache` pod. Use `podAffinity` (required, not preferred). The topology key should be `kubernetes.io/hostname`.
3. Set the resource requests for the `frontend-app` pod to `100m` CPU and `128Mi` memory.
4. Set the resource limits for the `frontend-app` pod to `200m` CPU and `256Mi` memory.

---

## Acceptance Criteria

- [ ] Pod `frontend-app` is running in the `app-stack` namespace.
- [ ] `frontend-app` has `podAffinity` configured matching the label `tier=cache`.
- [ ] `frontend-app` has the correct CPU and Memory requests and limits.

---

## Hints

<details>
<summary>💡 Hint 1 — Pod Affinity</summary>

You'll need to define this in the Pod spec.
```yaml
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: tier
            operator: In
            values:
            - cache
        topologyKey: kubernetes.io/hostname
```
</details>

<details>
<summary>💡 Hint 2 — Resource requests and limits</summary>

Define these under the container spec.
```yaml
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "256Mi"
        cpu: "200m"
```
</details>
