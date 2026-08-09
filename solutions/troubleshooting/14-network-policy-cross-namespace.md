# Solution 14: Network Policy blocking cross-namespace traffic

## 1. Diagnose the issue

Test the connection from the frontend to the backend to confirm it fails:
```bash
kubectl -n frontend-ns exec web-ui -- wget --timeout=3 -qO- http://api-server.backend-ns
```
*It will time out.*

Inspect the NetworkPolicy in the `backend-ns`:
```bash
kubectl describe networkpolicy api-allow -n backend-ns
```
Look at the output:
```text
Allowing ingress traffic:
    To Port: <any> (traffic allowed to all ports)
    From:
        NamespaceSelector: project=my-project
```

The policy expects traffic to come from a namespace with the label `project=my-project`.

Now check the labels on the namespaces:
```bash
kubectl get ns --show-labels
```
*You will see that `frontend-ns` does NOT have the label `project=my-project`. (It usually has `kubernetes.io/metadata.name=frontend-ns`).*

## 2. Fix the issue

There are two ways to solve this. Both are perfectly valid for the exam.

**Method A: Label the namespace (Easier)**
Simply add the label the policy expects to the `frontend-ns` namespace.
```bash
kubectl label namespace frontend-ns project=my-project
```

**Method B: Modify the NetworkPolicy**
Edit the NetworkPolicy to select the built-in label that Kubernetes automatically applies to all namespaces (`kubernetes.io/metadata.name`).
```bash
kubectl edit networkpolicy api-allow -n backend-ns
```
Change the `namespaceSelector`:
```yaml
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          # CHANGE THIS:
          kubernetes.io/metadata.name: frontend-ns
```

## 3. Verify

Run the test command again from the frontend pod:
```bash
kubectl -n frontend-ns exec web-ui -- wget -qO- http://api-server.backend-ns
```
*You should now see the Nginx welcome HTML output, proving the connection succeeded.*
