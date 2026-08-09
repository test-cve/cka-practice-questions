# Question 10: PersistentVolume, PVC and Pod Mount

**Domain:** Storage  
**Difficulty:** 🟢 Easy  
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

Create persistent storage for a logging application in the `logger` namespace.

1. Create a PersistentVolume (PV) named `log-pv`:
   - Capacity: `1Gi`
   - Access Mode: `ReadWriteOnce`
   - StorageClass: `manual` (even if this storage class doesn't exist)
   - HostPath: `/mnt/logs`

2. Create a PersistentVolumeClaim (PVC) named `log-pvc` in the `logger` namespace:
   - Request: `500Mi`
   - Access Mode: `ReadWriteOnce`
   - StorageClass: `manual`

3. Create a Pod named `log-writer` in the `logger` namespace:
   - Image: `busybox:1.36`
   - Command: `["sh", "-c", "while true; do date >> /var/log/output.log; sleep 5; done"]`
   - Mount the `log-pvc` claim to `/var/log` within the container.

---

## Acceptance Criteria

- [ ] `kubectl get pv log-pv` shows it is created and `Bound` to `logger/log-pvc`.
- [ ] `kubectl get pvc log-pvc -n logger` shows it is `Bound`.
- [ ] Pod `log-writer` is `Running` and mounting the PVC correctly.

---

## Hints

<details>
<summary>💡 Hint 1 — PV and PVC YAMLs</summary>

You cannot create a PV imperatively, you must use YAML. Check the documentation for Persistent Volume.
PVCs can be created imperatively, but you'll need to make sure the storage class and access modes match the PV so they bind.
</details>

<details>
<summary>💡 Hint 2 — Mounting in the Pod</summary>

Define a volume in the pod spec referencing the PVC, and a volumeMount in the container spec.
```yaml
  volumes:
  - name: log-vol
    persistentVolumeClaim:
      claimName: log-pvc
  containers:
  - name: ...
    volumeMounts:
    - name: log-vol
      mountPath: /var/log
```
</details>
