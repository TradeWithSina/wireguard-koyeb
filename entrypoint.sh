#!/bin/bash
set -e

# Generate server keys
wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key
PRIVATE_KEY=$(cat /etc/wireguard/server_private.key)
PUBLIC_KEY=$(cat /etc/wireguard/server_public.key)

# Get public IP
PUBLIC_IP=$(curl -s ifconfig.me)

# Create WireGuard config
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $PRIVATE_KEY
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = PLACEHOLDER
AllowedIPs = 10.0.0.2/32
EOF

# Start WireGuard
wg-quick up wg0

# Keep container running
tail -f /dev/null
