# Question 08: Ingress — Path-Based Routing

**Domain:** Services & Networking  
**Difficulty:** 🟡 Medium  
**Estimated time:** ~10 minutes  
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

Two web applications, `store-app` and `blog-app`, have been deployed in the `web-routing` namespace along with their corresponding ClusterIP services, `store-svc` and `blog-svc`.

An Ingress Controller (Nginx) is already installed and running.

Create an Ingress resource named `main-ingress` in the `web-routing` namespace that routes traffic based on the URL path:
- Requests to `http://example.com/store` should route to `store-svc` on port 80.
- Requests to `http://example.com/blog` should route to `blog-svc` on port 80.
- Use `Prefix` path type for both rules.

---

## Acceptance Criteria

- [ ] `kubectl get ingress main-ingress -n web-routing` exists.
- [ ] `kubectl describe ingress main-ingress -n web-routing` shows rules for host `example.com`.
- [ ] Path `/store` points to `store-svc:80`.
- [ ] Path `/blog` points to `blog-svc:80`.

---

## Hints

<details>
<summary>💡 Hint 1 — Basic Ingress YAML Structure</summary>

Use the imperative command to get a starting template, or check the documentation for Ingress.
```bash
kubectl create ingress main-ingress --rule="example.com/store=store-svc:80" -n web-routing --dry-run=client -o yaml > ingress.yaml
```
</details>

<details>
<summary>💡 Hint 2 — Adding multiple paths</summary>

You can manually edit the generated `ingress.yaml` to add the `/blog` path rule under the same host.
```yaml
      paths:
      - path: /store
        pathType: Prefix
        backend:
          service:
            name: store-svc
            port:
              number: 80
      - path: /blog
        pathType: Prefix
        backend:
          ...
```
</details>
