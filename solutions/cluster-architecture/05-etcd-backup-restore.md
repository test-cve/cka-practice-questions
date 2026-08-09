# Solution 05: etcd Snapshot — Backup and Restore

## 1. Take the Snapshot (Backup)

You need to use `etcdctl` with the correct certificates.

```bash
ETCDCTL_API=3 etcdctl snapshot save /opt/etcd-backup/snapshot.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
```
Verify the backup file was created:
```bash
ls -lh /opt/etcd-backup/snapshot.db
```

## 2. Simulate Data Loss

Delete the deployment:
```bash
kubectl delete deployment important-app -n critical
```

## 3. Restore the Snapshot

First, restore the snapshot to a new data directory:
```bash
ETCDCTL_API=3 etcdctl snapshot restore /opt/etcd-backup/snapshot.db \
  --data-dir=/var/lib/etcd-restore
```

Next, update the etcd static pod manifest to point to the new data directory.

```bash
sudo vi /etc/kubernetes/manifests/etcd.yaml
```

Find the `hostPath` for `etcd-data` (usually near the bottom):
```yaml
  volumes:
  - hostPath:
      path: /var/lib/etcd-restore # <-- CHANGE THIS from /var/lib/etcd
      type: DirectoryOrCreate
    name: etcd-data
```
Save and exit.

The kubelet will automatically restart the etcd pod because the manifest changed.
Wait a minute or two for the API server and etcd to come back up.

## 4. Verify

Check if the API server is responding:
```bash
kubectl get nodes
```
*(If it times out, wait a bit longer for the static pods to restart).*

Check if the deployment was restored:
```bash
kubectl get deployment important-app -n critical
```
