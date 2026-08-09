# Solution 18: Ingress 503 Service Unavailable (wrong backend port)

## 1. Diagnose the issue

First, verify the 503 error (optional but good practice). Get the ingress controller's IP and curl it:
```bash
INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.clusterIP}')
curl -H "Host: store.example.com" http://$INGRESS_IP/
```
*You will see `503 Service Temporarily Unavailable`.*

Describe the Ingress resource:
```bash
kubectl describe ingress store-ingress -n ecommerce
```
Look at the `Rules` section:
```text
Host                 Path  Backends
----                 ----  --------
store.example.com    
                     /   storefront-svc:8080 (<error: endpoints missing>)
```
*The ingress controller is telling you there are no endpoints for this service on port `8080`.*

Check the service to see what port it's actually using:
```bash
kubectl get svc storefront-svc -n ecommerce
```
*You will see `PORT(S): 80/TCP`.*

The Ingress is pointing to port `8080`, but the Service is running on port `80`.

## 2. Fix the issue

Edit the Ingress resource to point to the correct port:
```bash
kubectl edit ingress store-ingress -n ecommerce
```

Find the `backend.service.port.number` and change it:
```yaml
        backend:
          service:
            name: storefront-svc
            port:
              # CHANGE THIS:
              # number: 8080
              number: 80
```
Save and exit.

## 3. Verify

Check the Ingress description again:
```bash
kubectl describe ingress store-ingress -n ecommerce
```
*The Backends section should now list actual IP addresses instead of `<error: endpoints missing>`.*

Test the connection again:
```bash
curl -H "Host: store.example.com" http://$INGRESS_IP/
```
*You should now receive the Nginx welcome page.*
