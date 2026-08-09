# Solution 15: Pod OOMKilled due to extreme memory limit

## 1. Diagnose the issue

Check the pods to see what is happening:
```bash
kubectl get pods -n batch-jobs
```
*The pod will show a status of `OOMKilled` or `CrashLoopBackOff`.*

Describe the pod to confirm why it died:
```bash
kubectl describe pod -l app=heavy-processor -n batch-jobs
```
*Look at the `Containers -> processor -> Last State` section. You will see `Reason: OOMKilled`.*

This means the container tried to use more memory than its limit allowed, so Linux killed the process.

## 2. Fix the issue

Check the current resource limits:
```bash
kubectl get deployment heavy-processor -n batch-jobs -o yaml | grep resources -A 4
```
*You will see the memory limit is set to `2Mi`, which is way too small for Nginx to run.*

Edit the deployment to increase the limit:
```bash
kubectl edit deployment heavy-processor -n batch-jobs
```

Update the `limits` section:
```yaml
        resources:
          limits:
            # CHANGE THIS:
            # memory: 2Mi
            memory: 128Mi
          requests:
            memory: 1Mi
```
Save and exit.

## 3. Verify

Watch the pods to see the old one terminate and the new one start successfully:
```bash
kubectl get pods -n batch-jobs -w
```
*The new pod should transition to `Running` and stay there without crashing.*

Verify the limit was applied correctly:
```bash
kubectl describe pod -l app=heavy-processor -n batch-jobs | grep -i memory
```
