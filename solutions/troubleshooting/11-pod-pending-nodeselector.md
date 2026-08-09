# Solution 11: Pod stuck in Pending (NodeSelector mismatch)

## 1. Diagnose the issue

Check the status of the pods:
```bash
kubectl get pods -n web
```
*The pods will be in the `Pending` state.*

Describe one of the pending pods:
```bash
kubectl describe pod -l app=frontend-ui -n web
```
*At the very bottom, in the `Events` section, you will see a `FailedScheduling` warning with a message like `0/1 nodes are available: 1 node(s) didn't match Pod's node affinity/selector.`*

Check what the Pod expects by looking at the Deployment:
```bash
kubectl get deployment frontend-ui -n web -o yaml | grep nodeSelector -A 2
```
*You will see it requires the node to have the label `disktype: ssd`.*

Check the labels on your node(s):
```bash
kubectl get nodes --show-labels
```
*Notice that no node has the `disktype: ssd` label.*

## 2. Fix the issue

The instructions say **not** to remove the node selector from the deployment, but rather to satisfy the requirement by fixing the cluster state.

Label the available node (usually `controlplane` on single-node setups, or a worker node if you're on a multi-node setup) with the required label:

```bash
kubectl label node controlplane disktype=ssd
```

## 3. Verify

Check the pods again:
```bash
kubectl get pods -n web -w
```
*They should transition from `Pending` to `ContainerCreating` to `Running`.*
