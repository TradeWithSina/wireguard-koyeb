#!/bin/bash
set -e

WG_DIR="/etc/wireguard"
WG_PRIVATE_KEY_FILE="$WG_DIR/server_private.key"
WG_PUBLIC_KEY_FILE="$WG_DIR/server_public.key"
WG_CONFIG_FILE="$WG_DIR/wg0.conf"

# ساخت فولدر و تنظیم دسترسی
mkdir -p "$WG_DIR"
chmod 700 "$WG_DIR"

# ساخت کلیدهای WireGuard در صورت وجود نداشتن
if [ ! -f "$WG_PRIVATE_KEY_FILE" ]; then
  wg genkey | tee "$WG_PRIVATE_KEY_FILE" | wg pubkey > "$WG_PUBLIC_KEY_FILE"
fi

# ساخت فایل کانفیگ wg0.conf اگر وجود نداشته باشد
if [ ! -f "$WG_CONFIG_FILE" ]; then
  cat <<EOF > "$WG_CONFIG_FILE"
[Interface]
PrivateKey = $(cat $WG_PRIVATE_KEY_FILE)
Address = 10.0.0.1/24
ListenPort = 51820

# Peer example:
#[Peer]
#PublicKey = <client-public-key>
#AllowedIPs = 10.0.0.2/32
EOF
fi

# اجرای WireGuard
exec wg-quick up wg0

# اگر بخوای بعدش کانتینر به صورت فعال بمونه، می‌تونی به جای exec این رو بذاری:
# tail -f /dev/null
