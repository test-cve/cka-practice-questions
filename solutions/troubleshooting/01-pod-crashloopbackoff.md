# Solution 01: Pod Stuck in CrashLoopBackOff

## 1. Diagnose the issue

First, check the status of the pods:
```bash
kubectl get pods -n production
```
*You will see the pods in a `CrashLoopBackOff` state.*

Next, describe one of the pods to see what's happening:
```bash
kubectl describe pod webapp-<hash> -n production
```
*Look at the `Containers` -> `webapp` section. You will see the `Command` is set to `["/bin/sh", "-c", "exit 1"]`.*

Check the logs to see if there is any output before it crashes:
```bash
kubectl logs webapp-<hash> -n production
```
*There's likely no output because `exit 1` terminates the shell immediately.*

## 2. Fix the issue

The Deployment has a bad command configured for the container. We need to edit the deployment and remove it so the image's default entrypoint runs.

```bash
kubectl edit deployment webapp -n production
```

Find the `command` array under `spec.template.spec.containers` and delete it entirely:
```yaml
      containers:
      - image: nginx:1.27
        imagePullPolicy: IfNotPresent
        name: webapp
        # DELETE THE FOLLOWING LINE:
        # command:
        # - /bin/sh
        # - -c
        # - exit 1
```

Save and exit (`:wq`).

## 3. Verify

Check that the new pods are coming up and the old ones are terminating:
```bash
kubectl get pods -n production -w
```

Once they are running, verify the deployment is ready:
```bash
kubectl get deployment webapp -n production
```
*You should see `READY: 2/2`.*

Finally, you can check the logs to ensure nginx started correctly:
```bash
kubectl logs deployment/webapp -n production
```
