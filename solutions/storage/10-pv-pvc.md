# Solution 10: PersistentVolume, PVC and Pod Mount

## 1. Create the PersistentVolume

PVs cannot be created imperatively. You must write a YAML file.
Create `pv.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: log-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: "/mnt/logs"
```

Apply it:
```bash
kubectl apply -f pv.yaml
```

## 2. Create the PersistentVolumeClaim

Create `pvc.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: log-pvc
  namespace: logger
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
  storageClassName: manual
```

Apply it:
```bash
kubectl apply -f pvc.yaml
```

Verify they are bound:
```bash
kubectl get pv log-pv
kubectl get pvc log-pvc -n logger
```
*Both should show `STATUS: Bound`.*

## 3. Create the Pod

Generate a base YAML:
```bash
kubectl run log-writer --image=busybox:1.36 -n logger --command -- sh -c "while true; do date >> /var/log/output.log; sleep 5; done" --dry-run=client -o yaml > pod.yaml
```

Edit `pod.yaml` to add the volume and volumeMount:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: log-writer
  namespace: logger
spec:
  volumes:
  - name: log-vol
    persistentVolumeClaim:
      claimName: log-pvc
  containers:
  - command:
    - sh
    - -c
    - while true; do date >> /var/log/output.log; sleep 5; done
    image: busybox:1.36
    name: log-writer
    volumeMounts:
    - name: log-vol
      mountPath: /var/log
```

Apply the pod:
```bash
kubectl apply -f pod.yaml
```

## 4. Verify

Check the pod is running:
```bash
kubectl get pod log-writer -n logger
```

Check the files on the host (since we used hostPath):
```bash
cat /mnt/logs/output.log
```
*You should see dates being appended to the file.*
