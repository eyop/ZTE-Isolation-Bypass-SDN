#!/bin/bash
# SDN Bridge Setup Script for Proxmox
# This script enables IP forwarding and optimizes for Tailscale Subnet Routing

echo "Enabling IPv4 Forwarding..."
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "Optimizing UDP GRO for Tailscale..."
# Replace 'eth0' with your actual interface name if different
sudo ethtool -K eth0 rx-udp-gro-forwarding on rx-gro-list on

echo "Configuration complete. You can now run: tailscale up --advertise-routes=192.168.1.0/24"
EOF

# Make the script executable
chmod +x scripts/setup-bridge.sh

# Create a placeholder for documentation
cat <<EOF > docs/troubleshooting.md
# Troubleshooting Layer 2 Isolation
- Ensure the Proxmox Firewall isn't blocking Tailscale traffic.
- If pings fail, check 'tailscale status' for a "Direct" connection.
- Verify 'pveversion' is current for kernel compatibility.
EOF