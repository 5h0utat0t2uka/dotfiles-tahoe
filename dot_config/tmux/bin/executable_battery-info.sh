#!/bin/bash

CACHE_FILE="$(cd "$(dirname "$0")/.." && pwd)/tmp/battery-cache"
CACHE_AGE=60

if [ -f "$CACHE_FILE" ]; then
  age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)))
  if [ $age -lt $CACHE_AGE ]; then
    cat "$CACHE_FILE"
    exit 0
  fi
fi

# バッテリー情報を取得
battery_info=$(pmset -g batt)
percentage=$(echo "$battery_info" | grep -o '[0-9]\+%' | head -1 | tr -d '%')

# バッテリー残量が取得できない場合
if [ -z "$percentage" ]; then
  output=" N/A"
else
  # if [ "$percentage" -ge 85 ]; then
  #   bar="█████"
  # elif [ "$percentage" -ge 60 ]; then
  #   bar="▒████"
  # elif [ "$percentage" -ge 40 ]; then
  #   bar="▒▒███"
  # elif [ "$percentage" -ge 20 ]; then
  #   bar="▒▒▒██"
  # else
  #   bar="▒▒▒▒█"
  # fi
  output=" ${percentage}%"
  # output="${bar} ${percentage}%"
fi

# キャッシュに保存
echo "$output" > "$CACHE_FILE"
echo "$output"
