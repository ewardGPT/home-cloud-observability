# Roadmap

This roadmap outlines planned improvements for the Home Cloud Observability Platform.  
The goal is to evolve the stack from a working monitoring setup into a production-style, cloud-engineer-grade platform with stronger security, automation, alerting, and scalability.

---

## Current State (Baseline Complete)

✅ Docker Compose stack deployed successfully  
✅ Grafana dashboards accessible  
✅ Prometheus metrics working  
✅ Loki logging pipeline working  
✅ Uptime Kuma monitoring working  
✅ Core deployment and troubleshooting documented

---

## Phase 1 — Polish + Portfolio Quality (High Priority)

### 1.1 Improve repository quality
- Add architecture diagram (Draw.io)
- Add screenshots:
  - Grafana dashboards (Node Exporter Full)
  - Prometheus `/targets`
  - Uptime Kuma status page
- Add badges (optional):
  - Docker Compose
  - Ubuntu
  - Grafana / Prometheus / Loki

### 1.2 Standardize configuration
- Move stack configuration into `/configs`
- Add `.env.example` for secret configuration
- Remove hard-coded passwords from configs
- Create a `configs/README.md` explaining each config file

### 1.3 Monitoring/dashboard improvements
- Import and validate dashboards:
  - Node Exporter Full (Grafana ID 1860)
  - Prometheus Stats (Grafana ID 3662)
- Build a custom “Home Cloud Overview” dashboard:
  - service uptime summary
  - CPU/RAM/Disk summary cards
  - alert summary panel

---

## Phase 2 — Alerting + Incident Response (SRE-style)

### 2.1 Uptime alerting
- Enable notifications in Uptime Kuma (Discord/webhook/email)
- Standardize monitors:
  - HTTP checks for web apps
  - TCP checks for ports
  - Ping checks for hosts
- Create maintenance windows for planned downtime

### 2.2 Grafana alerting
- Configure Grafana alert rules for:
  - CPU > 85% for 5m
  - RAM usage > 90% for 5m
  - disk usage > 90%
  - network saturation (optional)
- Setup alert notification routing (Grafana contact points)

### 2.3 Add Alertmanager (optional upgrade)
- Deploy Prometheus Alertmanager container
- Create alert routing:
  - critical vs warning
  - silences and inhibition rules

---

## Phase 3 — Exporters + Better Data Coverage

### 3.1 Add Node Exporter everywhere
- Install node_exporter on:
  - observability VM
  - Proxmox nodes (if supported)
  - key Linux VMs
- Ensure scrape configs are clean and named by job

### 3.2 Container monitoring
- Add cAdvisor for Docker container metrics
- Dashboards:
  - per-container CPU/RAM
  - container restarts
  - container network usage

### 3.3 Proxmox visibility
- Add Proxmox exporter
- Create dashboards for:
  - node CPU/RAM
  - storage utilization
  - VM uptime and resource usage
  - cluster health

---

## Phase 4 — Security Hardening (Zero Trust Upgrade)

### 4.1 Lock down LAN access
- Turn on UFW rules:
  - allow only local subnet
  - deny everything else
- Restrict Docker-published ports to LAN only (if needed)

### 4.2 Tailscale remote access (recommended)
- Install Tailscale on observability VM
- Only allow access via:
  - LAN or Tailscale
- Disable exposure to any other networks

### 4.3 Reverse proxy + TLS (optional)
- Deploy Nginx Proxy Manager or Traefik
- Use TLS internally:
  - local domain
  - internal certificates (self-signed or local CA)

---

## Phase 5 — Automation + Infrastructure-as-Code (Professional Tier)

### 5.1 Backup automation
- Automated backups of volume folders:
  - grafana database
  - prometheus TSDB
  - loki data
  - kuma data
- Store backups:
  - second drive
  - NAS
  - external backup target

### 5.2 Ansible deployment (IaC upgrade)
- Create Ansible playbooks:
  - VM baseline hardening
  - docker installation
  - compose deployment
  - config placement
- “One command rebuild” capability

### 5.3 Terraform (cloud extension)
- Deploy the same stack to a cloud VM:
  - AWS / Azure / Oracle
- Compare:
  - homelab deployment vs cloud deployment
  - same monitoring strategy across both

---

## Phase 6 — Scaling + Multi-Node Monitoring

### 6.1 Central monitoring design
- Use one Prometheus + Loki as central source of truth
- Scrape:
  - multiple VMs
  - multiple Proxmox nodes
  - network devices

### 6.2 Multi-tenant dashboards
- Use variables in Grafana to switch:
  - environment = prod/lab
  - node selection dropdown
  - job selection dropdown

## Guiding Principles

- Security first (LAN-only, no exposed Proxmox)
- Monitoring should be actionable, not spam
- Everything should be rebuildable from documentation
- All configs should be version-controlled with no secrets in GitHub

