# Installation

## VM Specs
Recommended:
- 2 vCPU
- 4GB RAM
- 40GB disk
- static DHCP reservation

## Install Docker
Install Docker using the official Docker repository (recommended).

## Deploy stack
```bash
cp .env.example .env
# edit .env and set secrets
docker compose up -d
