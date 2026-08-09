# CKA 2026 Practice Questions

Exam-level CKA practice questions designed for **[Killercoda free Kubernetes playgrounds](https://killercoda.com/playgrounds)**.

Each question mirrors real CKA exam conditions: specific resource names, namespaces, time budgets, and acceptance criteria. Troubleshooting questions include a `setup.sh` that creates resources and intentionally breaks the environment — just like the real thing.

---

## How to Use

### 1. Open a Killercoda Playground
- Go to **https://killercoda.com/playgrounds**
- Select **"Kubernetes"** → **"kubeadm 1 node"** (or "kubeadm 2 nodes" for questions marked `[2-NODE]`)
- Wait for the cluster prompt: `controlplane $`

### 2. Get the questions
```bash
git clone https://github.com/<your-username>/cka-practice.git
cd cka-practice
```
Or copy individual `setup.sh` scripts directly from this repo.

### 3. Run the setup script
```bash
cd <domain>/<question-folder>/
bash setup.sh
```
Wait for: **`✅ Environment ready. Start your timer!`**

### 4. Read the question
```bash
cat question.md
```

### 5. Solve it — then check your work
Once you think you're done, verify against the acceptance criteria in `question.md`.

### 6. Check the solution
```bash
cat solutions/<domain>/<question-name>.md
```

> ⚠️ **Free tier sessions last 1 hour.** Each question is budgeted well within that window.

---

## Question Index

### 🔴 Troubleshooting — 30% of exam

| # | Title | Difficulty | Playground |
|---|---|---|---|
| [Q01](troubleshooting/01-pod-crashloopbackoff/) | Pod stuck in CrashLoopBackOff | Medium | Single-node |
| [Q02](troubleshooting/02-service-wrong-selector/) | Service not routing traffic to pods | Medium | Single-node |
| [Q03](troubleshooting/03-node-notready/) | Node NotReady — diagnose and fix | Hard | **2-Node** |
| [Q11](troubleshooting/11-pod-pending-nodeselector/) | Pod stuck in Pending (NodeSelector mismatch) | Medium | Single-node |
| [Q12](troubleshooting/12-coredns-corrupted/) | CoreDNS ConfigMap corrupted | Hard | Single-node |
| [Q13](troubleshooting/13-rbac-denied/) | ServiceAccount missing permissions (RBAC denied) | Medium | Single-node |
| [Q14](troubleshooting/14-network-policy-cross-namespace/) | Network Policy blocking cross-namespace traffic | Hard | Single-node |
| [Q15](troubleshooting/15-pod-oomkilled/) | Pod OOMKilled due to extreme memory limit | Medium | Single-node |
| [Q16](troubleshooting/16-kube-apiserver-down/) | kube-apiserver down (bad flag in manifest) | Hard | Single-node |
| [Q17](troubleshooting/17-scheduler-disabled/) | Scheduler disabled (replica scaled to 0) | Hard | Single-node |
| [Q18](troubleshooting/18-ingress-503/) | Ingress 503 Service Unavailable (wrong backend port) | Medium | Single-node |
| [Q19](troubleshooting/19-node-cordoned-tainted/) | Node cordoned and tainted | Medium | **2-Node** |

### 🟠 Cluster Architecture, Installation & Configuration — 25% of exam

| # | Title | Difficulty | Playground |
|---|---|---|---|
| [Q04](cluster-architecture/04-rbac-serviceaccount/) | RBAC: ServiceAccount, Role & RoleBinding | Medium | Single-node |
| [Q05](cluster-architecture/05-etcd-backup-restore/) | etcd snapshot: backup and restore | Hard | Single-node |
| [Q06](cluster-architecture/06-helm-deploy/) | Helm: install, upgrade and rollback | Medium | Single-node |
| [Q20](cluster-architecture/20-kustomize-overlay/) | Kustomize overlay and patch deployment | Medium | Single-node |
| [Q21](cluster-architecture/21-kubeconfig-context/) | Kubeconfig contexts and user permissions | Medium | Single-node |
| [Q22](cluster-architecture/22-manage-crds/) | Managing CRDs (Custom Resource Definitions) | Medium | Single-node |
| [Q23](cluster-architecture/23-rbac-cross-namespace/) | RoleBinding and ServiceAccount across namespaces | Hard | Single-node |
| [Q24](cluster-architecture/24-kubeadm-upgrade-controlplane/) | Upgrading a kubeadm cluster (control plane node) | Hard | Single-node |
| [Q25](cluster-architecture/25-kubeadm-upgrade-worker/) | Upgrading a kubeadm cluster (worker node) | Hard | **2-Node** |
| [Q26](cluster-architecture/26-etcd-backup-restore-multinode/) | Etcd backup and restore (multi-node) | Hard | **2-Node** |

### 🟡 Services & Networking — 20% of exam

| # | Title | Difficulty | Playground |
|---|---|---|---|
| [Q07](services-networking/07-network-policy/) | Network Policies: default-deny + selective allow | Hard | Single-node |
| [Q08](services-networking/08-ingress-routing/) | Ingress: path-based routing | Medium | Single-node |
| [Q27](services-networking/27-ingress-tls/) | Ingress: TLS termination | Medium | Single-node |
| [Q28](services-networking/28-network-policy-egress/) | NetworkPolicy: Egress filtering | Medium | Single-node |
| [Q29](services-networking/29-service-troubleshooting/) | Service troubleshooting (NodePort and ClusterIP) | Hard | Single-node |
| [Q30](services-networking/30-coredns-customization/) | CoreDNS customization | Medium | Single-node |
| [Q31](services-networking/31-gateway-api-basic/) | Gateway API basic routing | Medium | Single-node |
| [Q32](services-networking/32-ingress-multihost/) | Ingress: multi-host routing | Medium | Single-node |

### 🟢 Workloads & Scheduling — 15% of exam

| # | Title | Difficulty | Playground |
|---|---|---|---|
| [Q09](workloads-scheduling/09-pod-affinity/) | Pod affinity + resource limits | Medium | Single-node |
| [Q33](workloads-scheduling/33-deployment-rollouts/) | Deployment rollouts, history, and undo | Medium | Single-node |
| [Q34](workloads-scheduling/34-hpa-setup/) | HorizontalPodAutoscaler (HPA) setup | Medium | Single-node |
| [Q35](workloads-scheduling/35-daemonset-tolerations/) | DaemonSet deployment and node tolerations | Medium | Single-node |
| [Q36](workloads-scheduling/36-nodeaffinity-preferred/) | NodeAffinity (preferred vs required) | Medium | Single-node |
| [Q37](workloads-scheduling/37-static-pods/) | Static Pods creation and management | Medium | Single-node |

### 🔵 Storage — 10% of exam

| # | Title | Difficulty | Playground |
|---|---|---|---|
| [Q10](storage/10-pv-pvc/) | PersistentVolume, PVC and Pod mount | Easy | Single-node |
| [Q38](storage/38-storageclass-dynamic/) | StorageClass and dynamic provisioning | Medium | Single-node |
| [Q39](storage/39-pvc-expansion/) | PVC expansion and volume access modes | Medium | Single-node |
| [Q40](storage/40-pod-volume-mounts/) | Pod volume mounts (ConfigMap & Secret as volumes) | Easy | Single-node |

---

## Difficulty Guide

| Label | Description |
|---|---|
| **Easy** | Straightforward task, one or two resources, common pattern |
| **Medium** | Multi-step, requires understanding of how components interact |
| **Hard** | Complex troubleshooting or multi-component task under time pressure |

---

## 2026 CKA Curriculum Coverage

| Domain | Weight | Topics Covered |
|---|---|---|
| Troubleshooting | 30% | CrashLoopBackOff, service connectivity, node health, kubelet, logs |
| Cluster Architecture | 25% | RBAC, etcd backup/restore, Helm, Kustomize, kubeadm, CRDs |
| Services & Networking | 20% | Network Policies, Ingress, Gateway API, DNS, CNI |
| Workloads & Scheduling | 15% | Affinity, resource limits, deployments, rollouts, HPA |
| Storage | 10% | PV, PVC, StorageClass, access modes, volume mounts |

---

## Tips for the Real Exam

- Use `kubectl explain <resource>.<field>` to look up field names without leaving the terminal
- Use `--dry-run=client -o yaml` to generate manifests quickly
- Use `kubectl get events --sort-by=.metadata.creationTimestamp` to understand what went wrong
- Bookmark sections in `kubernetes.io/docs` — you can use the docs during the exam
- Always verify your work with `kubectl get`/`kubectl describe` before moving on

---

*Targeting Kubernetes v1.34–v1.35 | 2026 CKA Curriculum*
