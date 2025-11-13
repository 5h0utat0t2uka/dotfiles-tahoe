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

# 新しい値を取得
rssi=$(sudo wdutil info 2>/dev/null | grep "RSSI" | awk '{print $3}')

if [ -z "$rssi" ] || [[ "$rssi" == "<redacted>" ]]; then
  # output="▒▒▒▒"
  # output="████"
  output=" - dBm"
else
  rssi_num=${rssi%dBm}
  rssi_num=${rssi_num// /}
  rssi_display=${rssi_num#-}

  # if [ "$rssi_num" -ge -50 ]; then
  #   output=" ${rssi_display}dBm"
  # elif [ "$rssi_num" -ge -60 ]; then
  #   output=" ${rssi_display}dBm"
  # elif [ "$rssi_num" -ge -70 ]; then
  #   output=" ${rssi_display}dBm"
  # else
  #   output=" ${rssi_display}dBm"
  # fi
  output=" ${rssi_display}dBm"
fi

# キャッシュに保存
echo "$output" > "$CACHE_FILE"
echo "$output"
