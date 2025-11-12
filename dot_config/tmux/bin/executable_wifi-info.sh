#!/bin/bash

# 初回のみ、詳細なWi-Fi情報を有効化するために以下を実行
# sudo ipconfig setverbose 1

# SSIDを取得（setverboseが既に設定されている前提）
ssid=$(ipconfig getsummary en0 2>/dev/null | awk -F ' SSID : ' '/ SSID : / {print $2}')

if [[ -n "$ssid" && "$ssid" != "<redacted>" ]]; then
  echo "$ssid"
else
  # フォールバック：保存済みネットワークリストの先頭を使用
  ssid=$(networksetup -listpreferredwirelessnetworks en0 2>/dev/null | sed -n '2p' | xargs)
  if [[ -n "$ssid" ]]; then
    echo "$ssid"
  else
    echo "Offline"
  fi
fi
