# Question 05: etcd Snapshot — Backup and Restore

**Domain:** Cluster Architecture, Installation & Configuration  
**Difficulty:** 🔴 Hard  
**Estimated time:** ~15 minutes  
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

You are the cluster administrator. A critical deployment `important-app` exists in the `critical` namespace. You must:

**Part A — Backup:**
1. Take a snapshot of etcd and save it to `/opt/etcd-backup/snapshot.db`

**Part B — Simulate data loss and restore:**
2. Delete the `important-app` deployment (simulating accidental deletion)
3. Restore the etcd snapshot from `/opt/etcd-backup/snapshot.db`
4. Verify that the `important-app` deployment has returned

> 💡 The etcd certificates are located at their default kubeadm paths: `/etc/kubernetes/pki/etcd/`

---

## Acceptance Criteria

**After Part A:**
- [ ] File `/opt/etcd-backup/snapshot.db` exists and is non-empty (`ls -lh /opt/etcd-backup/snapshot.db`)

**After Part B (restore):**
- [ ] `kubectl get deployment important-app -n critical` shows the deployment exists and is `READY`
- [ ] The cluster is fully functional (`kubectl get nodes`, `kubectl get pods -A`)

---

## Hints

<details>
<summary>💡 Hint 1 — etcdctl environment variables</summary>

You need to point `etcdctl` at the right TLS certs. These are always at:
```
--cacert=/etc/kubernetes/pki/etcd/ca.crt
--cert=/etc/kubernetes/pki/etcd/server.crt
--key=/etc/kubernetes/pki/etcd/server.key
--endpoints=https://127.0.0.1:2379
```
</details>

<details>
<summary>💡 Hint 2 — Taking the snapshot</summary>

```bash
mkdir -p /opt/etcd-backup
ETCDCTL_API=3 etcdctl snapshot save /opt/etcd-backup/snapshot.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
```
</details>

<details>
<summary>💡 Hint 3 — Restore process overview</summary>

1. Stop the API server (move the static pod manifest out of `/etc/kubernetes/manifests/`)
2. Run `etcdctl snapshot restore` to a new data directory
3. Update `/etc/kubernetes/manifests/etcd.yaml` to point to the new data directory
4. Move the API server manifest back
5. Wait for the cluster to recover
</details>
