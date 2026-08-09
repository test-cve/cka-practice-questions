# Solution 08: Ingress — Path-Based Routing

## 1. Create the Ingress Resource

Generate a base YAML using the imperative command:
```bash
kubectl create ingress main-ingress --rule="example.com/store=store-svc:80" -n web-routing --dry-run=client -o yaml > ingress.yaml
```

Edit the `ingress.yaml` file to add the second path rule:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: main-ingress
  namespace: web-routing
spec:
  rules:
  - host: example.com
    http:
      paths:
      - backend:
          service:
            name: store-svc
            port:
              number: 80
        path: /store
        pathType: Prefix
      - backend:
          service:
            name: blog-svc
            port:
              number: 80
        path: /blog
        pathType: Prefix
```

Apply the file:
```bash
kubectl apply -f ingress.yaml
```

## 2. Verify

Check the ingress:
```bash
kubectl describe ingress main-ingress -n web-routing
```
*You should see the rules clearly mapped to the respective backend services.*

Test routing (Optional, if ingress-nginx is fully ready):
```bash
# Get the IP of the ingress controller
INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.clusterIP}')

# Test /store
curl -H "Host: example.com" http://$INGRESS_IP/store

# Test /blog
curl -H "Host: example.com" http://$INGRESS_IP/blog
```
*(The actual output might be 404s depending on the nginx/httpd default config, but the routing itself is what matters for the exam.)*
