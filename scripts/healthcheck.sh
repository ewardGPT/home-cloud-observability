#!/usr/bin/env bash
set -euo pipefail

echo "[*] healthcheck.sh starting..."

# Expected ports
declare -A SERVICES=(
  ["Grafana"]="3000"
  ["Prometheus"]="9090"
  ["Loki"]="3100"
  ["Uptime Kuma"]="3001"
)

echo ""
echo "== Docker Status =="
docker compose ps || true

echo ""
echo "== Port Check =="

for NAME in "${!SERVICES[@]}"; do
  PORT="${SERVICES[$NAME]}"
  if sudo ss -lntp | grep -q ":$PORT"; then
    echo "[OK] $NAME port $PORT listening"
  else
    echo "[FAIL] $NAME port $PORT NOT listening"
  fi
done

echo ""
echo "== Endpoint Check =="

# Grafana returns 302 usually, Prom/Loki return 200.
curl -s -o /dev/null -w "Grafana: %{http_code}\n" http://127.0.0.1:3000 || true
curl -s -o /dev/null -w "Prometheus: %{http_code}\n" http://127.0.0.1:9090/-/ready || true
curl -s -o /dev/null -w "Loki: %{http_code}\n" http://127.0.0.1:3100/ready || true
curl -s -o /dev/null -w "Kuma: %{http_code}\n" http://127.0.0.1:3001 || true

echo ""
echo "[+] Healthcheck complete."
