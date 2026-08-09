# Solution 17: Scheduler disabled (replica scaled to 0)

## 1. Diagnose the issue

Check the pending pods:
```bash
kubectl get pods
```
*They are `Pending`.*

Describe one of them:
```bash
kubectl describe pod -l app=worker-app
```
*Notice that there are NO events at the bottom. Usually, if it can't schedule due to resources or labels, you see a `FailedScheduling` event. No events means the scheduler isn't even trying.*

Check if the scheduler is running in the `kube-system` namespace:
```bash
kubectl get pods -n kube-system | grep scheduler
```
*It will return empty. The scheduler is not running.*

## 2. Fix the issue

In kubeadm clusters, the scheduler is deployed as a static pod. The manifests must be in `/etc/kubernetes/manifests/`.

Check the directory:
```bash
ls -l /etc/kubernetes/manifests/
```
*You will see `etcd.yaml`, `kube-apiserver.yaml`, and `kube-controller-manager.yaml`, but `kube-scheduler.yaml` is missing.*

Look for it in the parent directory (a common place an admin might temporarily move it):
```bash
ls -l /etc/kubernetes/
```
*You will find `kube-scheduler.yaml` here.*

Move it back:
```bash
sudo mv /etc/kubernetes/kube-scheduler.yaml /etc/kubernetes/manifests/
```

## 3. Verify

Wait a few seconds for the kubelet to detect the file and start the pod.

Check if the scheduler is running:
```bash
kubectl get pods -n kube-system | grep scheduler
```

Check if your pending pods have been scheduled:
```bash
kubectl get pods -w
```
*They should transition to `Running`.*
