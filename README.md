# Caddy

Custom Docker image for [Caddy](https://caddyserver.com/) with a curated set of plugins for DNS automation, authentication, layer 4 proxying, caching, and IP range utilities.

[![Docker Pulls](https://img.shields.io/docker/pulls/domizhang/caddy.svg)](https://hub.docker.com/r/domizhang/caddy)
[![Docker Image Size](https://img.shields.io/docker/image-size/domizhang/caddy/latest)](https://hub.docker.com/r/domizhang/caddy)

## Included version

- Caddy: `2.11.3`
- Base image: `caddy:2.11.3-alpine`

## Included plugins

- [`github.com/caddy-dns/cloudflare`](https://github.com/caddy-dns/cloudflare)
- [`github.com/greenpau/caddy-security`](https://github.com/greenpau/caddy-security)
- [`github.com/mholt/caddy-l4`](https://github.com/mholt/caddy-l4)
- [`github.com/caddyserver/cache-handler`](https://github.com/caddyserver/cache-handler)
- [`github.com/fvbommel/caddy-combine-ip-ranges`](https://github.com/fvbommel/caddy-combine-ip-ranges)
- [`github.com/WeidiDeng/caddy-cloudflare-ip`](https://github.com/WeidiDeng/caddy-cloudflare-ip)

## Supported platforms

- `linux/amd64`
- `linux/arm64`

## Tags

- `latest`: latest build from the default branch
- `2.11.3`: current Caddy version build
- `2.11`: major/minor tag for versioned releases

## Quick start

```bash
docker run --rm domizhang/caddy:latest caddy version
```

Run with a local Caddyfile:

```bash
docker run -d \
  --name caddy \
  -p 80:80 \
  -p 443:443 \
  -p 443:443/udp \
  -v "$PWD/Caddyfile:/etc/caddy/Caddyfile:ro" \
  -v caddy_data:/data \
  -v caddy_config:/config \
  domizhang/caddy:latest
```

## Docker Compose

```yaml
services:
  caddy:
    image: domizhang/caddy:latest
    container_name: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config

volumes:
  caddy_data:
  caddy_config:
```

## Build locally

```bash
docker build \
  --build-arg CADDY_VERSION=2.11.3 \
  -t domizhang/caddy:local .
```

## Update policy

The Caddy version is pinned in `Dockerfile` and `.github/workflows/main.yml`. To update:

1. Check the upstream [Caddy releases](https://github.com/caddyserver/caddy/releases).
2. Update `CADDY_VERSION` / `DEFAULT_VERSION`.
3. Build and test the image.
4. Tag the repository as `vX.Y.Z` to publish versioned tags.

Plugin versions intentionally follow their module defaults during the Caddy build. Pin plugin module versions in the `Dockerfile` if you need stricter reproducibility.

## License

This repository only builds a Docker image. Caddy and included plugins are distributed under their respective upstream licenses.
