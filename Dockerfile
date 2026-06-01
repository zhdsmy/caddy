# syntax=docker/dockerfile:1

ARG CADDY_VERSION=2.11.3

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

ARG CADDY_VERSION=2.11.3

RUN xcaddy build v${CADDY_VERSION} \
    --output /usr/bin/caddy \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/mholt/caddy-l4 \
    --with github.com/caddyserver/cache-handler \
    --with github.com/fvbommel/caddy-combine-ip-ranges \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/go-jose/go-jose/v3@v3.0.5 \
    --with github.com/go-jose/go-jose/v4@v4.1.4

FROM caddy:${CADDY_VERSION}-alpine

ARG CADDY_VERSION=2.11.3

LABEL org.opencontainers.image.title="caddy" \
      org.opencontainers.image.description="Custom Caddy image with Cloudflare DNS, security, L4, cache, and IP utility plugins" \
      org.opencontainers.image.version="${CADDY_VERSION}" \
      org.opencontainers.image.source="https://github.com/zhdsmy/caddy" \
      org.opencontainers.image.licenses="Apache-2.0"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
