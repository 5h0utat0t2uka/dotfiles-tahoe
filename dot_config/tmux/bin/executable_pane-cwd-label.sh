#!/usr/bin/env bash
set -eu

p="${1:-}"
home="${HOME%/}"
p="${p%/}"

if [[ -z "$p" || "$p" == "$home" ]]; then
  printf '󰉋 ~'
else
  printf '%s' "󰉋 ${p##*/}"
fi
