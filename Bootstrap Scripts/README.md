# 🚀 Ctrl Alt Ryan: Fedora 43 Bootstrap & Cloud Engineering Lab

![Platform: Fedora 43](https://img.shields.io/badge/Platform-Fedora%2043%20KDE-blue)

Welcome to the official workstation bootstrap for the **Ctrl Alt Ryan** brand. This automation is designed to take a fresh installation of **Fedora 43 (KDE Plasma)** and transform it into a professional Infrastructure-as-Code (IaC) and Cloud Engineering powerhouse with a sleek, macOS-inspired "WhiteSur" aesthetic.

## 🛠️ What’s Inside?

### 🏗️ The Cloud Stack
- **IaC & Automation:** Ansible, Terraform, Vagrant.
- **Containers & K8s:** Docker CE, kubectl (via k9s), Helm.
- **CLI Tools:** AWS CLI, Azure CLI, GitHub CLI (gh).
- **Virtualization:** Virt-Manager (KVM/QEMU) for local labbing in your RV or home office.

### 🎨 The "WhiteSur" Aesthetic
- **Theme:** WhiteSur-Dark Global Theme.
- **Icons & Cursors:** Apple-style iconography and high-definition cursors.
- **Engine:** Kvantum integration for frosted-glass transparency and blur effects.

### ⚡ Productivity Suite
- **Browsers:** Brave, Vivaldi, & Microsoft Edge.
- **Editors:** Visual Studio Code & Neovim.
- **Utilities:** Tailscale, Remmina (RDP), Obsidian, and Discord.

---

## 🚀 Quick Start

This command creates a `~/Scripts` directory, downloads the automation, and executes it while logging the entire process for troubleshooting.

### 1. One-Liner Execution
Copy and paste the following into your terminal:

```bash
mkdir -p ~/Scripts && \
curl -o ~/Scripts/fedora_bootstrap.sh https://raw.githubusercontent.com/ryan/ctrl-alt-ryan/main/fedora_bootstrap.sh && \
chmod +x ~/Scripts/fedora_bootstrap.sh && \
~/Scripts/fedora_bootstrap.sh 2>&1 | tee ~/Scripts/install_log.txt
