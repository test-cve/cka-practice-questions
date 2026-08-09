# Solution 16: kube-apiserver down (bad flag in manifest)

## 1. Diagnose the issue

When you try to use `kubectl`, you get:
```bash
The connection to the server <ip>:6443 was refused - did you specify the right host or port?
```

Since the API server is a static pod, it is managed directly by the `kubelet`. We need to use `crictl` to see why the container is failing to start.

List the containers (including exited ones) to find the kube-apiserver:
```bash
sudo crictl ps -a | grep kube-apiserver
```
*You will see a container that is in `Exited` or `Fatal` state.*

Get the logs for that specific container ID:
```bash
sudo crictl logs <container-id>
```
*You will see an error message like: `Error: unknown flag: --audit-log-path-wrong`.*

## 2. Fix the issue

The static pod manifests are located in `/etc/kubernetes/manifests/`.

Edit the kube-apiserver manifest:
```bash
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
```

Find the invalid flag in the `command:` array:
```yaml
    - --audit-log-path-wrong=/var/log/audit.log
```
Either delete this line entirely, or correct it to a valid flag (e.g., `--audit-log-path=/var/log/audit.log`). Delete is safest if you don't know the exact flag.

Save and exit.

## 3. Verify

The kubelet watches the `/etc/kubernetes/manifests/` directory. As soon as you save the file, it will attempt to restart the pod.

Wait about 30-60 seconds, then check if `kubectl` works again:
```bash
kubectl get nodes
```
*If it returns the nodes list, you have successfully fixed the issue.*
