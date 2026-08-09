# Question 12: CoreDNS ConfigMap corrupted

**Domain:** Troubleshooting  
**Difficulty:** 🔴 Hard  
**Estimated time:** ~12 minutes  
**Playground:** Single-node (`kubernetes-kubeadm-1node`)

---

## Setup

Run this before starting your timer:

```bash
bash setup.sh
```

Wait for: **`✅ Environment ready. Start your timer!`**

---

## Task

The `test-app` deployment in the `default` namespace is failing to resolve external domain names (like `google.com`), though cluster-internal DNS works fine.

The cluster administrator suspects someone accidentally modified the CoreDNS configuration.

Your job is to investigate and fix the issue so that:
- CoreDNS can successfully resolve external domains.
- The `test-app` pod can successfully resolve `google.com` (this can be tested using `nslookup`).
- Do **not** recreate the CoreDNS deployment or delete its pods; fix the configuration and let it reload, or restart the pods gracefully.

---

## Acceptance Criteria

- [ ] `kubectl -n kube-system exec -it deployment/coredns -- cat /etc/coredns/Corefile` shows a valid configuration.
- [ ] `kubectl run test-dns --rm -i --tty --image=busybox:1.36 -- nslookup google.com` succeeds.

---

## Hints

<details>
<summary>💡 Hint 1 — Where is the config?</summary>

CoreDNS reads its configuration from a ConfigMap named `coredns` in the `kube-system` namespace.
```bash
kubectl get configmap coredns -n kube-system -o yaml
```
</details>

<details>
<summary>💡 Hint 2 — What is broken?</summary>

Look at the `forward` plugin in the Corefile configuration. It specifies where unresolved DNS queries should be sent. If it's pointing to a non-existent or blocked IP (like `1.2.3.4`), external resolution will fail.
</details>

<details>
<summary>💡 Hint 3 — How to fix it</summary>

Edit the configmap and change the `forward` address back to `/etc/resolv.conf` (which tells CoreDNS to use the host node's DNS resolver).
```bash
kubectl edit configmap coredns -n kube-system
```
Then delete the coredns pods so they restart and pick up the new config immediately.
```bash
kubectl delete pod -l k8s-app=kube-dns -n kube-system
```
</details>
