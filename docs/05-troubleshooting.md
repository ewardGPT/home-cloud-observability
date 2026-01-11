# Troubleshooting

## Grafana permissions error
**Symptoms**
- `GF_PATHS_DATA='/var/lib/grafana' is not writable`

**Fix**
```bash
sudo chown -R 472:472 grafana-data

