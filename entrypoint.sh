#!/bin/bash

# ذخیره لینک در فایل vless.txt
WORKSPACE_DIR=$(pwd)
VLESS_FILE="${WORKSPACE_DIR}/vless.txt"

if [ -z "$CODESPACE_NAME" ]; then
    DOMAIN="localhost"
else
    DOMAIN="${CODESPACE_NAME}-443.app.github.dev"
fi

VLESS_LINK="vless://550e8400-e29b-41d4-a716-446655440000@${DOMAIN}:443?encryption=none&security=tls&type=xhttp&mode=packet-up&path=%2F#ghtun"
echo "$VLESS_LINK" > "$VLESS_FILE"
echo "✅ VLESS link saved to: $VLESS_FILE"
cat "$VLESS_FILE"
echo "----------------------------------------------------"

# اجرای مانیتور در پس‌زمینه (هر ۶۰ ثانیه چک می‌کند)
nohup /usr/local/bin/monitor.sh > /dev/null 2>&1 &

# اجرای xray
exec /usr/local/bin/xray -c /etc/config.json