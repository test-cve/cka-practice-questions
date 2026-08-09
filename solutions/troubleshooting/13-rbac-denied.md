# Solution 13: ServiceAccount missing permissions (RBAC denied)

## 1. Diagnose the issue

Check the logs of the pod to confirm the error:
```bash
kubectl logs api-reader -n data
```
*You will see an error similar to: `Error from server (Forbidden): secrets is forbidden: User "system:serviceaccount:data:reader-sa" cannot list resource "secrets" in API group "" in the namespace "data".`*

This confirms that the `reader-sa` ServiceAccount does not have the necessary Role and RoleBinding.

Verify if any Roles or RoleBindings exist:
```bash
kubectl get role,rolebinding -n data
```
*They are missing.*

## 2. Fix the issue

We need to create the `Role` and the `RoleBinding`. We can do this quickly using imperative commands.

Create the Role:
```bash
kubectl create role secret-reader-role --verb=get,list --resource=secrets -n data
```

Create the RoleBinding to bind the Role to the `reader-sa` ServiceAccount:
```bash
kubectl create rolebinding secret-reader-binding \
  --role=secret-reader-role \
  --serviceaccount=data:reader-sa \
  -n data
```

## 3. Verify

First, check if the Role and RoleBinding were created correctly:
```bash
kubectl get role secret-reader-role -n data -o yaml
kubectl get rolebinding secret-reader-binding -n data -o yaml
```

You can use the `auth can-i` command to simulate the ServiceAccount's permissions:
```bash
kubectl auth can-i list secrets -n data --as=system:serviceaccount:data:reader-sa
```
*It should return `yes`.*

Finally, check the logs of the pod again to see if it's successfully listing the secrets now:
```bash
kubectl logs api-reader -n data --tail=10
```
*You should see the output of the `kubectl get secrets` command showing `dummy-secret`.*
