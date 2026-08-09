# Question 20: Kustomize overlay and patch deployment

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

You have a Kustomize project in the directory `/opt/kustomize-app`. It has a `base` directory and an `overlays/production` directory.

The production deployment needs more replicas than the base definition.

1. Create a `kustomization.yaml` file in `/opt/kustomize-app/overlays/production/`.
2. Configure it to use the `base` directory as a resource.
3. Configure it to apply a patch that scales the `webapp` deployment to `3` replicas. You can do this using either a `patchesStrategicMerge` file or the `replicas` field directly in `kustomization.yaml`.
4. Apply the production overlay to the cluster in the `default` namespace.

---

## Acceptance Criteria

- [ ] `kubectl get deployment webapp -n default` shows `3/3` replicas.
- [ ] A valid `kustomization.yaml` exists in `/opt/kustomize-app/overlays/production/`.

---

## Hints

<details>
<summary>💡 Hint 1 — Basic kustomization.yaml structure</summary>

Your `/opt/kustomize-app/overlays/production/kustomization.yaml` needs to point to the base directory:
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- ../../base
```
</details>

<details>
<summary>💡 Hint 2 — Scaling replicas</summary>

Kustomize has a built-in `replicas` field to easily scale deployments without writing a full patch file:
```yaml
replicas:
- name: webapp
  count: 3
```
</details>

<details>
<summary>💡 Hint 3 — Applying the kustomization</summary>

To apply a kustomize directory, use `kubectl apply -k`:
```bash
kubectl apply -k /opt/kustomize-app/overlays/production/
```
</details>
