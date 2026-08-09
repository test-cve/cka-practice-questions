# Solution 03: Node NotReady — Diagnose and Fix

## 1. Diagnose the issue

Check the nodes and their status:
```bash
kubectl get nodes
```
*`node01` will show `NotReady`.*

Describe the node to see why it's not ready:
```bash
kubectl describe node node01
```
*Under `Conditions`, look for the `Ready` condition. The message will likely say something about the Kubelet not posting node status.*

Since it's likely a kubelet issue, SSH into the node:
```bash
ssh node01
```

Check the status of the kubelet service:
```bash
systemctl status kubelet
```
*You will see it's `inactive (dead)` or `failed`.*

## 2. Fix the issue

Start and enable the kubelet service:
```bash
sudo systemctl start kubelet
sudo systemctl enable kubelet
```

Check the status again to ensure it's running:
```bash
systemctl status kubelet
```
*It should say `active (running)`.*

Exit the SSH session:
```bash
exit
```

## 3. Verify

Wait a few seconds, then check the nodes again from the control plane:
```bash
kubectl get nodes
```
*`node01` should now be `Ready`.*

Check the pods on `node01` to ensure they are now `Running`:
```bash
kubectl get pods -A -o wide | grep node01
```
