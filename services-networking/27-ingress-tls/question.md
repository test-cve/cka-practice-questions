# Q27: Ingress TLS termination
**Domain:** Services & Networking
**Difficulty:** 🟡 Medium

---
## Task
1. A TLS secret `tls-secret` exists in the `default` namespace.
2. Create an Ingress named `secure-ingress` that routes traffic for `secure.example.com` to the service `secure-service` on port 80.
3. Configure the Ingress to use `tls-secret` for TLS termination for the host `secure.example.com`.
