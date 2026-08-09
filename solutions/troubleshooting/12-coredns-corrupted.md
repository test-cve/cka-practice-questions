# Solution 12: CoreDNS ConfigMap corrupted

## 1. Diagnose the issue

Test the DNS resolution to see exactly what fails:
```bash
# Internal DNS works:
kubectl run test-dns --rm -i --tty --image=busybox:1.36 -- nslookup kubernetes.default

# External DNS fails:
kubectl run test-dns --rm -i --tty --image=busybox:1.36 -- nslookup google.com
```

Since internal works but external doesn't, the issue is likely how CoreDNS handles forwarding.

Check the CoreDNS ConfigMap:
```bash
kubectl describe configmap coredns -n kube-system
```
*Look at the `Corefile` data block. You will see a line like `forward . 1.2.3.4`. This means all external queries are being sent to `1.2.3.4`, which is a bogus IP.*

## 2. Fix the issue

Edit the ConfigMap to correct the forwarding address:
```bash
kubectl edit configmap coredns -n kube-system
```
Change `forward . 1.2.3.4` back to the default `forward . /etc/resolv.conf`:
```yaml
    .:53 {
        errors
        health {
           lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        prometheus :9153
        # CHANGE THIS LINE:
        forward . /etc/resolv.conf
        cache 30
        loop
        reload
        loadbalance
    }
```
Save and exit.

Although CoreDNS has a `reload` plugin and will eventually notice the ConfigMap changed, it's faster and safer to gracefully restart the CoreDNS pods to pick it up immediately:
```bash
kubectl rollout restart deployment coredns -n kube-system
```

## 3. Verify

Wait a few seconds for the new CoreDNS pods to come up, then test external DNS again:
```bash
kubectl run test-dns --rm -i --tty --image=busybox:1.36 -- nslookup google.com
```
*It should now successfully return IP addresses for google.com.*
