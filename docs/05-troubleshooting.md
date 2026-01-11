# Troubleshooting (Runbook)

This document records the issues encountered during deployment of the Home Cloud Observability Platform (Grafana + Prometheus + Loki/Promtail + Uptime Kuma) and the exact fixes applied.
It is intended as a future rebuild guide and quick incident response reference.

---

## 1) Quick Diagnosis Checklist

### 1.1 Verify containers are running

```bash
docker compose ps
```

Expected: all services show **Up** (no restarting/exited containers).

### 1.2 Check logs for the failing service

```bash
docker logs --tail=200 grafana (or first 3 digits of the docker pin EX: 2b3)
docker logs --tail=200 prometheus (or first 3 digits of the docker pin EX: 2b3)
docker logs --tail=200 loki (or first 3 digits of the docker pin EX: 2b3)
docker logs --tail=200 promtail (or first 3 digits of the docker pin EX: 2b3)
docker logs --tail=200 uptime-kuma (or first 3 digits of the docker pin EX: 2b3)
```

### 1.3 Confirm ports are listening

```bash
sudo ss -lntp | egrep '(:3000|:9090|:3100|:3001)'
```

Expected:

* `3000` Grafana
* `9090` Prometheus
* `3100` Loki
* `3001` Uptime Kuma

---

## 2) Most Common Deployment Issue: Volume Permissions

### Symptom patterns

During initial deployment, multiple services failed due to bind-mounted volume permission issues. These errors occur when the container cannot write to its data directory.

Common messages:

* `Permission denied`
* `... is not writable`
* `mkdir ... permission denied`
* service crash loop / restarting container

### Root Cause

Docker bind-mounts use host filesystem permissions. Even if Docker is running correctly, a container may fail if the host directory mapped into the container is not writable by the user running the application inside the container.

### Permanent Fix Applied

Stop stack:

```bash
docker compose down
```

Fix ownership on host directories:

```bash
# Grafana runs as UID 472
sudo chown -R 472:472 ./grafana-data

# Loki commonly runs as UID 10001
sudo chown -R 10001:10001 ./loki-data

# Prometheus required write access to /prometheus
sudo chown -R nobody:nogroup ./prometheus-data

# Baseline permissions
sudo chmod -R 755 ./grafana-data ./loki-data ./prometheus-data
```

Restart stack:

```bash
docker compose up -d
docker compose ps
```

---

## 3) Grafana Issues

### 3.1 Grafana volume not writable

**Symptom**

* `GF_PATHS_DATA='/var/lib/grafana' is not writable`
* `mkdir: can't create directory '/var/lib/grafana/plugins': Permission denied`

**Fix**

```bash
sudo chown -R 472:472 ./grafana-data
```

### 3.2 Grafana admin login failed

Grafana may reject login if the admin password has changed or Grafana has already initialized using an older password.

**Fix (reset admin password)**

```bash
docker exec -it grafana grafana-cli admin reset-admin-password "TempPassword123!"
```

Login with:

* username: `admin`
* password: `TempPassword123!`

---

## 4) Prometheus Issues

### 4.1 Prometheus crashes / 9090 not reachable

**Symptom**

* `open /prometheus/queries.active: permission denied`
* `panic: Unable to create mmap-ed active query log`

**Fix**

```bash
sudo chown -R nobody:nogroup ./prometheus-data
```

**Verification**

```bash
curl http://127.0.0.1:9090/-/ready
```

Expected: ready response (HTTP success).

---

## 5) Loki Issues

### 5.1 Loki permission crash

**Symptom**

* `mkdir /loki/rules: permission denied`
* `error initialising module: ruler-storage`

**Fix**

```bash
sudo chown -R 10001:10001 ./loki-data
```

### 5.2 Loki returns “404 page not found”

**Explanation**
This is expected if visiting the root endpoint:

* `http://<ip>:3100/`

Loki does not provide a UI homepage at `/`.

**Correct endpoints**

* Ready check: `http://<ip>:3100/ready`
* Metrics: `http://<ip>:3100/metrics`
* Build info: `http://<ip>:3100/loki/api/v1/status/buildinfo`

**Verification**

```bash
curl http://127.0.0.1:3100/ready
```

Expected response:

* `ready`

---

## 6) Promtail Issues

### 6.1 Logs not visible in Grafana

If Loki is healthy but no logs appear in Grafana Explore, Promtail is the most likely cause.

**Check promtail logs**

```bash
docker logs --tail=200 promtail
```

Confirm:

* promtail is running
* promtail can reach loki over docker network
* promtail config points to `http://loki:3100`

---

## 7) Uptime Kuma Issues

### 7.1 Kuma UI not reachable

**Checks**

```bash
docker logs --tail=200 uptime-kuma
sudo ss -lntp | grep 3001
```

**Verification**

```bash
curl -I http://127.0.0.1:3001
```

Expected: HTTP 200 or 302.

---

## 8) Known Good Health Endpoints (Fast Tests)

Run from inside the observability VM:

```bash
# Grafana (normally returns 302 redirect)
curl -I http://127.0.0.1:3000

# Prometheus
curl http://127.0.0.1:9090/-/ready

# Loki
curl http://127.0.0.1:3100/ready

# Kuma
curl -I http://127.0.0.1:3001
```

---

## 9) Safe Full Restart Procedure

```bash
docker compose down
docker compose pull
docker compose up -d
docker compose ps
```
