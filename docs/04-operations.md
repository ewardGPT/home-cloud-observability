# Operations

## Backups
Back up persistent volumes:
- grafana-data/
- prometheus-data/
- loki-data/
- uptime-kuma-data/

## Updates
```bash
docker compose pull
docker compose up -d
