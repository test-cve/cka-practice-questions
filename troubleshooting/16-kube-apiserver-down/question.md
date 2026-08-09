# Question 16: kube-apiserver down (bad flag in manifest)

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

Wait for: **`✅ Environment ready. Start your timer!`** (Note: the command will actually break your `kubectl` access, this is intentional).

---

## Task

The `kubectl` command on the control plane node has stopped working entirely, throwing connection refused errors.

A junior admin was trying to configure auditing on the kube-apiserver and modified its static pod manifest. Since then, the API server has not come back up.

Your job is to investigate and fix the issue so that:
- The kube-apiserver starts successfully.
- `kubectl get nodes` works again.
- Do **not** restore from a backup. Find the error in the current configuration and fix it.

---

## Acceptance Criteria

- [ ] `kubectl get nodes` returns a valid response.
- [ ] The `kube-apiserver` static pod is running correctly.

---

## Hints

<details>
<summary>💡 Hint 1 — Where is the apiserver manifest?</summary>

In a kubeadm cluster, the API server is deployed as a static pod. Its manifest is located at `/etc/kubernetes/manifests/kube-apiserver.yaml`.
</details>

<details>
<summary>💡 Hint 2 — Finding the error</summary>

Since `kubectl` doesn't work, you need to check container logs using the container runtime directly (containerd/crictl or docker).
```bash
crictl ps -a | grep kube-apiserver
crictl logs <container-id>
```
*You will likely see an error about an unknown flag or a misconfigured option.*
</details>

<details>
<summary>💡 Hint 3 — Fixing the manifest</summary>

Open `/etc/kubernetes/manifests/kube-apiserver.yaml` and look for an invalid flag in the `command:` list, such as `--audit-log-path-wrong`. Correct it to `--audit-log-path` or remove it if unnecessary. The kubelet will automatically restart the pod.
</details>
