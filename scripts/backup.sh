#!/usr/bin/env bash
set -euo pipefail

echo "[*] backup.sh starting..."

# Run from repo root:
#   ./scripts/backup.sh

DATE="$(date +%Y-%m-%d_%H-%M-%S)"
BACKUP_DIR="./backups/$DATE"
VOLUMES_DIR="./volumes"

mkdir -p "$BACKUP_DIR"

if [ ! -d "$VOLUMES_DIR" ]; then
  echo "[!] volumes/ directory not found. Nothing to back up."
  echo "    If you're using Docker named volumes, consider exporting them separately."
  exit 1
fi

echo "[*] Backing up volumes -> $BACKUP_DIR"

tar -czf "$BACKUP_DIR/grafana-data.tar.gz" -C "$VOLUMES_DIR" grafana-data || true
tar -czf "$BACKUP_DIR/prometheus-data.tar.gz" -C "$VOLUMES_DIR" prometheus-data || true
tar -czf "$BACKUP_DIR/loki-data.tar.gz" -C "$VOLUMES_DIR" loki-data || true
tar -czf "$BACKUP_DIR/promtail-data.tar.gz" -C "$VOLUMES_DIR" promtail-data || true
tar -czf "$BACKUP_DIR/uptime-kuma-data.tar.gz" -C "$VOLUMES_DIR" uptime-kuma-data || true

echo "[+] Backup completed."
echo "[i] Backup path: $BACKUP_DIR"

