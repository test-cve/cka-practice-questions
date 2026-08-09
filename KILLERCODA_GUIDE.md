# Killercoda Playground Guide

This repository is designed specifically to be used with the **free** Kubernetes environments provided by [Killercoda](https://killercoda.com/playgrounds). 

These cloud-based, ephemeral Kubernetes clusters are the closest you can get to the real CKA exam environment without paying for a cloud provider.

## 🚀 Getting Started

### 1. Choose the right environment
Go to [Killercoda Kubernetes Playgrounds](https://killercoda.com/playgrounds). You will see several options:
- **kubeadm 1 node (Ubuntu)**: Use this for 90% of the questions. It provisions a single control-plane node which is perfectly adequate for standard workloads, RBAC, storage, and networking practice.
- **kubeadm 2 nodes (Ubuntu)**: Use this specifically for questions tagged with **`[2-Node]`** (like node troubleshooting, taints/tolerations, or etcd multi-node configurations).

### 2. Wait for the cluster to be ready
When you launch an environment, you'll see a terminal. The cluster is initialized automatically via kubeadm. 
**Wait until you see the `controlplane $` prompt** and the initialization script finishes.

### 3. Clone this repository
Once the terminal is ready, run:
```bash
git clone https://github.com/<your-username>/cka-practice.git
cd cka-practice
```

---

## ⏱ Session Limits & Time Management

- **Free Tier Time Limit:** Each free session on Killercoda lasts **1 hour** (60 minutes).
- **Exam Strategy:** The real CKA is 2 hours for ~17 questions (average of 7 minutes per question). The 1-hour Killercoda window is more than enough to practice 4 to 5 questions in a single session.
- **Resetting:** If you break the cluster beyond repair during a troubleshooting scenario, simply refresh the webpage or close the tab and launch a new playground!

---

## 🛠 Running the Setup Scripts

Every question in this repo contains a `setup.sh` file. This script does a few things:
1. Pre-creates the specific resources needed for the question (Namespaces, Deployments, ServiceAccounts).
2. For troubleshooting questions, it intentionally **breaks** the cluster or a resource to mimic real exam scenarios.

**Workflow:**
```bash
# Navigate to the question directory
cd troubleshooting/01-pod-crashloopbackoff/

# Run the setup script
bash setup.sh
```

Wait until you see the message: **`✅ Environment ready. Start your timer!`** before you begin investigating!

---

## 💡 Best Practices for Killercoda

1. **Use Aliases:** Get used to typing `k` instead of `kubectl`. Killercoda often has this pre-configured, but if not:
   ```bash
   alias k=kubectl
   ```
2. **Setup Auto-completion:** 
   ```bash
   source <(kubectl completion bash)
   complete -o default -F __start_kubectl k
   ```
3. **Use tmux/screen:** Just like the real exam, Killercoda provides a single terminal. You can use `tmux` or `screen` to split the view if you want to look at logs on one side while editing YAML on the other.
4. **Copy-Pasting:** Since Killercoda is a web-based terminal, you can usually copy/paste using your browser's default shortcuts (e.g., `Ctrl+C` / `Ctrl+V` or `Cmd+C` / `Cmd+V`). Ensure your terminal clipboard integration is enabled.
