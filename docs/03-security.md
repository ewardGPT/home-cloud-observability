# Security

## Principles
- LAN-only access (default)
- strong passwords stored in Bitwarden
- avoid exposing internal services publicly
- restrict firewall access to trusted subnets/devices

## Hardening
- UFW enabled and restricted
- no UPnP on router
- no port forwarding for Proxmox, Prometheus, Loki, Grafana
