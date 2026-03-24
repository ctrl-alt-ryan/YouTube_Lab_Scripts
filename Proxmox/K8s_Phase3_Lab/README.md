🚀 Enterprise-Grade K8s Lab: From Consumer to Core
The "Ctrl Alt Ryan" Infrastructure-as-Code (IaC) Deployment

This repository documents the evolution of my homelab, transitioning from the lightweight K3s distribution to a fully-orchestrated, enterprise-grade Kubernetes (K8s) environment. This project utilizes a complete DevOps toolchain to automate the provisioning, configuration, and deployment of mission-critical lab services.
🏗️ The Tech Stack

    Hypervisor: Proxmox VE (Dell XPS 4-Node Cluster

    Provisioning: Terraform (Infrastructure as Code)

    Configuration: Ansible (Immutable Server Setup)

    Orchestration: Kubernetes (Vanilla K8s)

    Storage: Longhorn (Distributed Software-Defined Storage)

    CI/CD: GitLab

    Observability: Prometheus & Grafana (Dashboard 1860)

🛠️ Deployment Phases
Phase 1: Infrastructure Provisioning (Terraform)

Terraform interacts directly with the Proxmox API to spin up our cluster nodes with precise resource allocations:

    1x Controller Node: 2 vCPU | 4GB RAM | 32GB OS Disk

    2x Worker Nodes: 2 vCPU | 4GB RAM | 20GB OS Disk + 50GB Dedicated VirtIO Disk (Reserved for Longhorn)

Phase 2: System Hardening & Prep (Ansible)

Before Kubernetes is initialized, Ansible performs "Day 0" configuration to ensure the base OS is ready for container orchestration:

    Container Runtime: Installation and optimization of containerd.

    Kernel Tuning: Disabling swap and loading essential modules (overlay, br_netfilter).

    Networking: Applying sysctl configurations for bridged traffic.

    Storage Prep: Installing open-iscsi to support block storage attachment.

Phase 3: Cluster Initialization

Using the kubeadm workflow, we initialize the Control Plane and join the Worker nodes into a cohesive cluster, establishing the internal networking and API communication necessary for a multi-node environment.

Phase 4: Software-Defined Storage (Longhorn)

To achieve high availability, we deploy Longhorn. This allows us to replicate data volumes across multiple worker nodes. If a node fails, Kubernetes automatically reschedules the pod to a healthy node, and Longhorn re-attaches the replicated data instantly—ensuring zero data loss.
📦 Hosted Services

The cluster hosts a suite of tools isolated via Kubernetes Namespaces and managed through Helm:

    Homepage: Our central command center for lab navigation and real-time resource monitoring.

    Grafana: Deep-stack observability using the 1860 Node Exporter Full dashboard for per-core hardware metrics.

    OpenSpeedTest: A localized network benchmarking tool to verify 1Gbps/10Gbps backbone throughput within the lab.

yes
