#!/bin/bash

CACHE_FILE="$(cd "$(dirname "$0")/.." && pwd)/tmp/wifi-rssi-cache"
CACHE_AGE=30

# キャッシュファイルが存在し、30秒以内なら使用
if [ -f "$CACHE_FILE" ]; then
  age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)))
  if [ $age -lt $CACHE_AGE ]; then
    cat "$CACHE_FILE"
    exit 0
  fi
fi

# 新しい値を取得（負の数値のみを抽出、スペースのみ削除）
rssi=$(sudo wdutil info 2>/dev/null | grep "RSSI" | grep -oE '\-[1-9][0-9]* dBm' | head -n1 | tr -d ' ' | tr -d '-')

if [ -z "$rssi" ]; then
  output="-dBm"
else
  output="$rssi"
fi

# キャッシュに保存
echo "$output" > "$CACHE_FILE"
echo "$output"
