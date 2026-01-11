#!/usr/bin/env bash
set -euo pipefail

echo "[*] restore.sh starting..."

# Usage:
#   ./scripts/restore.sh backups/2026-01-11_19-00-00
# OR:
#   ./scripts/restore.sh ./backups/2026-01-11_19-00-00

if [ $# -ne 1 ]; then
  echo "Usage: $0 <backup-folder>"
  exit 1
fi

BACKUP_DIR="$1"
VOLUMES_DIR="./volumes"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "[!] Backup folder not found: $BACKUP_DIR"
  exit 1
fi

mkdir -p "$VOLUMES_DIR"

echo "[!] WARNING: This will overwrite existing data in ./volumes"
echo "    Make sure docker is stopped:"
echo "      docker compose down"
echo ""

read -r -p "Continue restore? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "[*] Restore cancelled."
  exit 0
fi

echo "[*] Restoring archives..."

[ -f "$BACKUP_DIR/grafana-data.tar.gz" ] && tar -xzf "$BACKUP_DIR/grafana-data.tar.gz" -C "$VOLUMES_DIR"
[ -f "$BACKUP_DIR/prometheus-data.tar.gz" ] && tar -xzf "$BACKUP_DIR/prometheus-data.tar.gz" -C "$VOLUMES_DIR"
[ -f "$BACKUP_DIR/loki-data.tar.gz" ] && tar -xzf "$BACKUP_DIR/loki-data.tar.gz" -C "$VOLUMES_DIR"
[ -f "$BACKUP_DIR/promtail-data.tar.gz" ] && tar -xzf "$BACKUP_DIR/promtail-data.tar.gz" -C "$VOLUMES_DIR"
[ -f "$BACKUP_DIR/uptime-kuma-data.tar.gz" ] && tar -xzf "$BACKUP_DIR/uptime-kuma-data.tar.gz" -C "$VOLUMES_DIR"

echo "[+] Restore completed."
echo "[i] Next steps:"
echo "  1) ./scripts/permissions-fix.sh"
echo "  2) docker compose up -d"

