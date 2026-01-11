#!/usr/bin/env bash
set -euo pipefail

echo "[*] permissions-fix.sh starting..."

# This script assumes you run it from the repo root.
# Example:
#   cd home-cloud-observability
#   chmod +x scripts/*.sh
#   ./scripts/permissions-fix.sh

VOLUMES_DIR="./volumes"

# If you're using Docker named volumes, you can skip this script.
# This is mainly for bind mounts (recommended for homelabs / easy backups).
if [ ! -d "$VOLUMES_DIR" ]; then
  echo "[!] volumes/ directory not found."
  echo "    If you are using Docker named volumes, this script is not needed."
  echo "    If you want bind-mount volumes for backups, create ./volumes first."
  exit 1
fi

echo "[*] Creating volume folders if missing..."
mkdir -p \
  "$VOLUMES_DIR/grafana-data" \
  "$VOLUMES_DIR/prometheus-data" \
  "$VOLUMES_DIR/loki-data" \
  "$VOLUMES_DIR/promtail-data" \
  "$VOLUMES_DIR/uptime-kuma-data"

echo "[*] Applying ownership..."

# Grafana runs as UID 472 inside container
sudo chown -R 472:472 "$VOLUMES_DIR/grafana-data"

# Loki commonly runs as UID 10001 inside container
sudo chown -R 10001:10001 "$VOLUMES_DIR/loki-data"

# Prometheus often needs nobody permissions
sudo chown -R nobody:nogroup "$VOLUMES_DIR/prometheus-data"

# Promtail + Kuma usually fine as root/current user,
# but we make sure the directory exists and is writable
sudo chmod -R 755 "$VOLUMES_DIR"

echo "[+] Permissions applied successfully."

