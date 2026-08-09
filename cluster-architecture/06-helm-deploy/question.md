# Question 06: Helm — Install, Upgrade and Rollback

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

Use Helm to manage a release of the `bitnami/nginx` chart:

1. Add the Bitnami Helm repository with the name `bitnami`  
   URL: `https://charts.bitnami.com/bitnami`

2. Install the chart as a release named `web-server` in the namespace `web` (create the namespace if it doesn't exist)  
   Set the following values:
   - `replicaCount=2`

3. Upgrade the release to set `replicaCount=3`

4. Rollback the release to the previous version (replicaCount=2)

5. Confirm the rollback succeeded

---

## Acceptance Criteria

- [ ] `helm repo list` shows `bitnami` repo
- [ ] `helm list -n web` shows `web-server` release
- [ ] After rollback: `kubectl get deployment -n web` shows the nginx deployment with `2` replicas
- [ ] `helm history web-server -n web` shows at least 3 revisions

---

## Hints

<details>
<summary>💡 Hint 1 — Adding a repo and installing</summary>

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install web-server bitnami/nginx \
  --namespace web \
  --create-namespace \
  --set replicaCount=2
```
</details>

<details>
<summary>💡 Hint 2 — Upgrade and rollback</summary>

```bash
# Upgrade
helm upgrade web-server bitnami/nginx -n web --set replicaCount=3

# Check history
helm history web-server -n web

# Rollback to revision 1
helm rollback web-server 1 -n web
```
</details>
