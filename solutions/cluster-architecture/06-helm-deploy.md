# Solution 06: Helm — Install, Upgrade and Rollback

## 1. Add Repo and Install

Add the Bitnami repository:
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Install the release:
```bash
helm install web-server bitnami/nginx \
  --namespace web \
  --create-namespace \
  --set replicaCount=2
```

Verify:
```bash
helm list -n web
kubectl get deployment -n web
```

## 2. Upgrade

Upgrade the release to have 3 replicas:
```bash
helm upgrade web-server bitnami/nginx -n web --set replicaCount=3
```

Verify:
```bash
kubectl get pods -n web
```
*(You should see 3 pods.)*

## 3. Rollback

Check the release history:
```bash
helm history web-server -n web
```

Rollback to revision 1:
```bash
helm rollback web-server 1 -n web
```

## 4. Verify

Check the deployment again:
```bash
kubectl get deployment -n web
```
*(Replicas should be back to 2.)*

Check history again to see the rollback recorded as a new revision:
```bash
helm history web-server -n web
```
