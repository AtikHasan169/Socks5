#!/bin/sh
set -e

# ===== Public SOCKS user (what you give to people) =====
MY_USER="${MY_USER:-Atik}"
MY_PASS="${MY_PASS:-1234}"

# Railway sets PORT, default 8080
MY_PORT="${PORT:-8080}"

# ===== Upstream provider SOCKS (your bought proxy) =====
UP_USER="${UP_USER:-test}"
UP_PASS="${UP_PASS:-test}"
UP_HOST="${UP_HOST:-103.126.23.222}"
UP_PORT="${UP_PORT:-1088}"

echo "Public SOCKS user : $MY_USER"
echo "Public SOCKS port : $MY_PORT"
echo "Upstream SOCKS    : $UP_USER:$UP_PASS@$UP_HOST:$UP_PORT"

exec gost \
  -L "socks5://$MY_USER:$MY_PASS@:${MY_PORT}" \
  -F "socks5://$UP_USER:$UP_PASS@$UP_HOST:$UP_PORT"