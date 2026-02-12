# ZTE Router Isolation Bypass via Tailscale SDN 🚀

[![Proxmox](https://img.shields.io/badge/Hypervisor-Proxmox_VE-orange?logo=proxmox)](https://www.proxmox.com)
[![Tailscale](https://img.shields.io/badge/Networking-Tailscale_SDN-blue?logo=tailscale)](https://tailscale.com)
[![WireGuard](https://img.shields.io/badge/Protocol-WireGuard-881717?logo=wireguard)](https://www.wireguard.com)

## 📖 Project Overview

This repository documents a network engineering solution to bypass **Layer 2 Client Isolation** enforced by ISP-locked hardware (specifically the **ZTE F660** gateway). 

### The Problem
The ISP gateway enforces a strict "Isolation" policy where Wireless (WLAN) clients cannot communicate with Wired (LAN) clients. This renders internal services like **AdGuard Home**, **Media Servers (Jellyfin/Plex)**, and **Proxmox Management** inaccessible to mobile devices and laptops, even when connected to the same local router.

### The Solution
Instead of replacing the hardware, I implemented a **Software-Defined Network (SDN)** overlay. By deploying a **Tailscale Subnet Router** on a Proxmox node, I established a virtual Layer 3 bridge that bypasses the router's physical isolation.

---

## 🏗️ Architecture & Topology

The solution utilizes a **Hub-and-Spoke** virtual topology over the existing physical infrastructure:

- **The Subnet Router:** A dedicated Linux container/VM on Proxmox.
- **The Overlay:** Tailscale (WireGuard-based) mesh network.
- **The Bridge:** Encapsulated traffic flows through the virtual `tailscale0` interface, bypassing the ZTE router's filtering logic.

> **Visual Representation:**
> [Insert your High-Quality Diagram here - `./images/network-diagram.png`]
> [Insert your High-Quality Diagram here - `./images/network-diagram1.png`]


---

## 🛠️ Implementation Details

### 1. Kernel Optimization
To allow the Proxmox node to act as a gateway for the rest of the network, IP forwarding was enabled:

```bash
# Enable IPv4/IPv6 forwarding
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

```

### 2. Tailscale Subnet Routing

The node was configured to "advertise" the local LAN range to the mesh network:

```bash
sudo tailscale up --advertise-routes=192.168.1.0/24 --accept-dns=false

```

### 3. DNS Integration (AdGuard Home)

To maintain a Zero-Trust posture with ad-blocking, **AdGuard Home** was integrated into the Tailscale DNS settings (Global Nameservers), ensuring all mesh clients receive filtered DNS resolution.

---

## ✅ Results & Performance

* **Connectivity:** Successfully bypassed AP Isolation; mobile devices achieve 100% reachability to the `192.168.1.0/24` subnet.
* **Management:** Remote management of the Proxmox cluster via **Termux** (on Android) and SSH is now possible from any network.
* **Security:** Traffic is end-to-end encrypted via WireGuard, removing the need for risky Port Forwarding or DMZ configurations on the ISP router.

## 📱 Mobile Management

I use **Termux** to manage this infrastructure on the go. By connecting to the Tailscale mesh, I can run `pveversion`, monitor resources via `btop`, and manage containers directly from my smartphone.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

---

**Author:** eyop

**Field:** Network Engineering / Home Lab Enthusiast

**Tools:** Proxmox, Tailscale, Debian, AdGuard Home


