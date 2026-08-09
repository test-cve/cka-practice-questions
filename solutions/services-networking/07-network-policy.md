# Solution 07: Network Policies — Default Deny and Selective Allow

## 1. Create Default Deny Policy

This policy applies to all pods in the namespace and denies all ingress traffic.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: secure-net
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```
Save to `deny.yaml` and apply:
```bash
kubectl apply -f deny.yaml
```

## 2. Create Allow Backend Policy

This policy allows traffic to the `backend` pod only if it originates from the `frontend` pod.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend
  namespace: secure-net
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
```
Save to `allow-backend.yaml` and apply:
```bash
kubectl apply -f allow-backend.yaml
```

## 3. Create Allow Database Policy

This policy allows traffic to the `database` pod only from the `backend` pod, and only on port `3306`.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-database
  namespace: secure-net
spec:
  podSelector:
    matchLabels:
      app: database
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend
    ports:
    - protocol: TCP
      port: 3306
```
Save to `allow-database.yaml` and apply:
```bash
kubectl apply -f allow-database.yaml
```

## 4. Verify

Check the policies:
```bash
kubectl get networkpolicies -n secure-net
```

Test the connections (Optional, but good practice):
```bash
# Get pod IPs
kubectl get pods -n secure-net -o wide

# Test frontend -> backend (Should succeed)
kubectl exec -it <frontend-pod-name> -n secure-net -- nc -vz <backend-pod-ip> 80

# Test frontend -> database (Should fail/timeout)
kubectl exec -it <frontend-pod-name> -n secure-net -- nc -vz <database-pod-ip> 3306

# Test backend -> database (Should succeed)
kubectl exec -it <backend-pod-name> -n secure-net -- nc -vz <database-pod-ip> 3306
```
