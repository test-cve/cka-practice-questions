# Solution 02: Service Not Routing Traffic to Pods

## 1. Diagnose the issue

Check the endpoints for the service:
```bash
kubectl get endpoints api-svc -n backend
```
*You will see `<none>` under the ENDPOINTS column. This means the Service hasn't matched any pods.*

Describe the service to see its selector:
```bash
kubectl describe svc api-svc -n backend
```
*Under `Selector:`, you will see `app=api`.*

Now, check the actual labels on the pods:
```bash
kubectl get pods -n backend --show-labels
```
*The pods have the label `app=api-server`, which does not match the service's selector (`app=api`).*

## 2. Fix the issue

Edit the service to correct the selector.

```bash
kubectl edit svc api-svc -n backend
```

Update the `selector` section:
```yaml
  selector:
    # CHANGE THIS:
    # app: api
    # TO THIS:
    app: api-server
```

Save and exit (`:wq`).

## 3. Verify

Check the endpoints again:
```bash
kubectl get endpoints api-svc -n backend
```
*You should now see the IP addresses of the two pods listed.*

Test the connection from a temporary pod:
```bash
kubectl run test --rm -it --image=busybox --restart=Never -- wget -qO- http://api-svc.backend
```
*You should see the default nginx welcome page HTML.*
