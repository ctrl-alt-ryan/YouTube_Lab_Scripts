🚀 Enterprise-Grade Hybrid Lab: The "Ctrl Alt Ryan" IaC Deployment

This repository documents the evolution of a high-performance homelab, transitioning from basic virtualization to a Hybrid Orchestration environment. By separating the Management Plane (Docker) from the Compute Plane (Kubernetes), this architecture ensures 100% observability uptime even during heavy cluster maintenance.
🏗️ The Tech Stack

    Hypervisor: Proxmox VE Cluster (Dell PowerEdge & XPS Nodes)

    Provisioning: Terraform (Infrastructure as Code)

    Configuration: Ansible (Immutable Server Setup)

    Orchestration: Vanilla Kubernetes (v1.30+)

    Management Plane: Docker & Docker Compose (High-Availability UI)

    Storage: Enterprise iSCSI (LUNs mapped via Proxmox to 50GB VirtIO Disks)

    Observability: Prometheus & Grafana (Dashboard 1860)

🛠️ Deployment Architecture
Phase 1: Infrastructure Provisioning (Terraform)

Terraform interacts with the Proxmox API to provision thin-provisioned nodes backed by a dedicated iSCSI SAN.

    1x Controller Node: 2 vCPU | 4GB RAM | 60GB OS Disk (Expanded via iSCSI)

    2x Worker Nodes: 2 vCPU | 4GB RAM | 60GB OS Disk

Phase 2: Hybrid Management Layer (Ansible + Docker)

To solve the "Disk Pressure" issues common in small-scale K8s labs, this project utilizes a Hybrid Management Approach. Core services run in Docker on the Controller to ensure the "Command Center" stays alive if the K8s workers are under load.

    Branded Dashboard: Custom HTML5/Nginx landing page for 0-latency navigation.

    Persistent Monitoring: Grafana and Prometheus utilize persistent Docker volumes to retain credentials and historical metric data across reboots.

Phase 3: Cluster Hardening (Ansible)

Ansible performs "Day 0" configuration to prep the Ubuntu 24.04 base:

    Container Runtime: Optimized containerd with SystemdCgroup enabled.

    Kernel Tuning: Loading overlay and br_netfilter; sysctl networking optimizations.

    Lock Management: Automated handling of unattended-upgrades to prevent apt database collisions during deployment.

📦 Hosted Services

The lab environment provides a suite of tools for real-time performance and health tracking:

    Branded Landing Page: A custom-coded, dark-themed dashboard at http://<controller-ip> for instant access to lab tools.

    Grafana: Deep-stack observability using the 1860 Node Exporter Full dashboard, scraping real-time metrics from all 3 K8s nodes.

    OpenSpeedTest: Localized network benchmarking to verify backbone throughput.

    Prometheus: Centralized metric collection with custom scrape targets for the Kubernetes worker fleet.

🚀 Quick Start Guide
1. Provision Infrastructure
Bash

cd terraform/
terraform init
terraform apply -auto-approve

2. Configure & Harden Nodes

Ensure ansible/inventory.ini matches your new IPs (e.g., .101, .104, .105).
Bash

cd ansible/
ansible-playbook -i inventory.ini deploy_k8s.yml

3. Deploy Management & Monitoring

This script installs Docker, sets up the Node Exporters, and launches the Branded Dashboard.
Bash

ansible-playbook -i inventory.ini deploy__apps.yml

💡 Senior Engineering Lessons Learned

    Storage Offloading: Transitioning from in-cluster Longhorn to Hypervisor-level iSCSI mapping significantly reduced CPU wait times and solved Kubelet "Disk Pressure" evictions.

    Atomic Deployments: Implementing apt lock-wait loops in Ansible ensures 100% success rates when deploying to freshly provisioned "Cloud-Init" images.

    Decoupled Management: Running monitoring tools in a lightweight Docker stack on the controller prevents "Observability Blackouts" when the Kubernetes API is undergoing maintenance.

🏁 Final Video Verification
Service	Access Link
🚀 Main Dashboard	http://10.3.160.101
📈 Grafana	http://10.3.160.101:32001
⚡ SpeedTest	http://10.3.160.101:30001
