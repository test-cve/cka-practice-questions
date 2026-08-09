# Solution 04: RBAC — ServiceAccount, Role & RoleBinding

## 1. Create the ServiceAccount

You can do this imperatively:
```bash
kubectl create serviceaccount monitor-sa -n apps
```

## 2. Create the Role

Because the Role requires different verbs for different resources, creating it purely imperatively is tricky. It's easier to create a base YAML and edit it, or write it directly.

**Option A (Imperative with dry-run):**
```bash
kubectl create role pod-reader --verb=get,list,watch --resource=pods -n apps --dry-run=client -o yaml > role.yaml
```
Then edit `role.yaml` to add the configmaps rule:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: apps
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - get
  - list
```
Apply it:
```bash
kubectl apply -f role.yaml
```

**Option B (Purely imperative, less readable but works):**
```bash
kubectl create role pod-reader --verb=get,list,watch --resource=pods --verb=get,list --resource=configmaps -n apps
```
*(This works in modern `kubectl` versions, but double check with `kubectl describe role pod-reader -n apps` to ensure both rules are there.)*

## 3. Create the RoleBinding

Bind the `ServiceAccount` to the `Role`:
```bash
kubectl create rolebinding monitor-binding --role=pod-reader --serviceaccount=apps:monitor-sa -n apps
```

## 4. Verify

Use `auth can-i` to test permissions masquerading as the ServiceAccount:

```bash
# Should return "yes"
kubectl auth can-i list pods -n apps --as=system:serviceaccount:apps:monitor-sa

# Should return "yes"
kubectl auth can-i get configmaps -n apps --as=system:serviceaccount:apps:monitor-sa

# Should return "no"
kubectl auth can-i delete pods -n apps --as=system:serviceaccount:apps:monitor-sa
```
