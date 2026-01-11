# Home Cloud Observability Platform

A production-style observability stack deployed on a Proxmox VM (Ubuntu Server) using Docker Compose.
It provides metrics, logs, uptime monitoring, and alert notifications for my homelab services.

## Stack
- Proxmox VE (virtualization layer)
- Ubuntu Server 24.04 VM (observability host)
- Grafana (dashboards + explore)
- Prometheus (metrics collection)
- Loki + Promtail (centralized logging)
- Uptime Kuma (availability monitoring + status page)

## Key Features
- Metrics dashboards (CPU/RAM/Disk/Network)
- Log search + exploration via Grafana + Loki
- Uptime monitoring (HTTP/TCP/Ping) with notifications
- Secure LAN-only access model (no public exposure)
- Documented deployment + operations runbooks

## Architecture
See `docs/01-architecture.md`

## Screenshots
![Proxmox Node 1 Grafana Dashboard](.screenshots/pve_grafana.png)
![Proxmox Node 2 Grafana Dashboard](.screenshots/pve-lab_grafana.png)
![Uptime Kuma Dashboard](.screenshots/uptime_kuma.png)
![Prometheus Tunnel](.screenshots/prometheus.png)
![Loki Report](.screenshots/loki.png)

- Prometheus targets page
- Uptime Kuma status page

## Deployment
See `docs/02-installation.md`

## Security Notes
See `docs/03-security.md`
