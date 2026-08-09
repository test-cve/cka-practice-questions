# Solution: Q33 (Deployment rollouts, history, and undo)

## Step 1: Update the deployment image

Change the image of the container (named `nginx`) in the `webapp-deploy` deployment to `nginx:1.24` and record the change in the history.

```bash
kubectl set image deployment/webapp-deploy nginx=nginx:1.24 -n rollout-test --record
```

Wait for the rollout to complete:
```bash
kubectl rollout status deployment/webapp-deploy -n rollout-test
```

## Step 2: Undo the rollout

Check the rollout history to see the revisions:
```bash
kubectl rollout history deployment webapp-deploy -n rollout-test
```

Undo the rollout to go back to the previous revision (`nginx:1.14`):
```bash
kubectl rollout undo deployment webapp-deploy -n rollout-test
```

Verify that it rolled back successfully:
```bash
kubectl rollout status deployment webapp-deploy -n rollout-test
kubectl describe deployment webapp-deploy -n rollout-test | grep Image
```

## Step 3: Scale the deployment

Scale the deployment up to 5 replicas:
```bash
kubectl scale deployment webapp-deploy --replicas=5 -n rollout-test
```

Verify the replicas:
```bash
kubectl get deployment webapp-deploy -n rollout-test
```
