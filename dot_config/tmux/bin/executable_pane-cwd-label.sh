#!/usr/bin/env bash
set -eu

p="${1:-}"
home="${HOME%/}"
p="${p%/}"

if [[ -z "$p" || "$p" == "$home" ]]; then
  # printf '󰉋 ~'
  printf '~'
else
  # printf '%s' "󰉋 ${p##*/}"
  printf '%s' "${p##*/}"
fi
