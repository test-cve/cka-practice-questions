# Solution 20: Kustomize overlay and patch deployment

## 1. Create the Production Kustomization file

You need to create a `kustomization.yaml` in the production overlay directory that references the base and modifies the replica count.

Create the file:
```bash
cat <<EOF > /opt/kustomize-app/overlays/production/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- ../../base

replicas:
- name: webapp
  count: 3
EOF
```

*(Alternatively, you could create a `patch.yaml` file with a partial deployment spec and include it in `patchesStrategicMerge:`, but the `replicas:` block is much faster for the exam).*

## 2. Preview the changes (Optional)

Before applying, it's good practice to ensure Kustomize builds the manifest correctly:
```bash
kubectl kustomize /opt/kustomize-app/overlays/production/
```
*Look at the output and verify that `replicas: 3` is present in the Deployment spec.*

## 3. Apply the Kustomization

Apply the overlay directly using `kubectl apply -k`:
```bash
kubectl apply -k /opt/kustomize-app/overlays/production/
```

## 4. Verify

Check the deployment in the cluster:
```bash
kubectl get deployment webapp -n default
```
*You should see `READY: 3/3`.*
