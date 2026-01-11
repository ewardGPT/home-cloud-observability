# Architecture

## Components
- Grafana: dashboards + explore
- Prometheus: metrics scrape + TSDB
- Loki: log storage/query
- Promtail: log shipping agent
- Uptime Kuma: uptime checks + alerts + status pages

## Service Ports
| Service | Port | Internal URL | Purpose |
|--------|------|--------------|---------|
| Grafana | 3000 | http://grafana:3000 | Dashboards |
| Prometheus | 9090 | http://prometheus:9090 | Metrics |
| Loki | 3100 | http://loki:3100 | Logs |
| Uptime Kuma | 3001 | http://uptime-kuma:3001 | Uptime |

## Network Model
- All services run on a single Docker network via Compose
- Access restricted to LAN (or Tailscale in future)
- No port forwarding required
