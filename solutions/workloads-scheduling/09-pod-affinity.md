# Solution 09: Pod Affinity and Resource Limits

## 1. Create the Pod YAML

Generate a base pod manifest:
```bash
kubectl run frontend-app --image=nginx:1.27 -n app-stack --dry-run=client -o yaml > pod.yaml
```

## 2. Edit the YAML

Edit `pod.yaml` to add `podAffinity` and `resources`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: frontend-app
  namespace: app-stack
spec:
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
  containers:
  - image: nginx:1.27
    name: frontend-app
    resources:
      requests:
        cpu: 100m
        memory: 128Mi
      limits:
        cpu: 200m
        memory: 256Mi
```

Apply the pod:
```bash
kubectl apply -f pod.yaml
```

## 3. Verify

Check that the pod is running:
```bash
kubectl get pod frontend-app -n app-stack
```

Verify it is on the same node as the redis pod:
```bash
kubectl get pods -n app-stack -o wide
```
*The `NODE` column should be identical for both `redis-cache` and `frontend-app`.*

Verify the resources and affinity were applied correctly:
```bash
kubectl describe pod frontend-app -n app-stack
```
*Check the `Limits`, `Requests`, and `Node-Selectors`/`Affinity` sections.*
