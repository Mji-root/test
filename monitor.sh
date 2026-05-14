#!/bin/bash

IDLE_FILE="/tmp/xray_idle_start"
IDLE_LIMIT_SEC=600  # 10 دقیقه

while true; do
    # شمارش اتصالات ESTABLISHED روی پورت 443 (هم IPv4 هم IPv6)
    CONNECTIONS=$(netstat -tn 2>/dev/null | grep ":443" | grep -c "ESTABLISHED")
    
    if [ "$CONNECTIONS" -eq 0 ]; then
        # هیچ اتصالی نیست
        if [ ! -f "$IDLE_FILE" ]; then
            date +%s > "$IDLE_FILE"
        fi
        START_IDLE=$(cat "$IDLE_FILE")
        NOW=$(date +%s)
        IDLE_DURATION=$((NOW - START_IDLE))
        if [ "$IDLE_DURATION" -ge "$IDLE_LIMIT_SEC" ]; then
            echo "No active connection for 10 minutes. Stopping codespace..."
            gh codespace stop -c "$CODESPACE_NAME"
            exit 0
        fi
    else
        # اتصال فعال هست -> ریست تایمر
        if [ -f "$IDLE_FILE" ]; then
            rm -f "$IDLE_FILE"
        fi
    fi
    
    sleep 60
done