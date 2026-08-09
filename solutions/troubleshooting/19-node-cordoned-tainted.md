# Solution 19: Node cordoned and tainted

## 1. Diagnose the issue

Check the status of the pods:
```bash
kubectl get pods
```
*They are in the `Pending` state.*

Check the nodes:
```bash
kubectl get nodes
```
*You will see `node01` is marked as `Ready,SchedulingDisabled`.*

This means the node was cordoned (likely for maintenance).

## 2. Fix the issue - Part 1

Uncordon the node to allow scheduling again:
```bash
kubectl uncordon node01
```

Check the nodes again:
```bash
kubectl get nodes
```
*The status is now just `Ready`.*

Check the pods:
```bash
kubectl get pods
```
*They might still be `Pending`! Why? Let's investigate the node further.*

## 3. Diagnose the issue - Part 2

If pods are still pending, the node might have a taint that the pods cannot tolerate.

Describe the node and look for taints:
```bash
kubectl describe node node01 | grep Taint
```
*You will see something like `Taints: maintenance=true:NoSchedule`.*

## 4. Fix the issue - Part 2

Remove the taint from the node. To remove a taint, use the same key but append a `-` (minus sign) to the end.

```bash
kubectl taint node node01 maintenance-
```
*Output: `node/node01 untainted`*

## 5. Verify

Watch the pods:
```bash
kubectl get pods -w
```
*They should now successfully transition to `ContainerCreating` and then `Running`.*
