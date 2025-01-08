ARG CADDY_VER=2.9.0

FROM caddy:${CADDY_VER}-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/mholt/caddy-l4

ARG CADDY_VER

FROM caddy:${CADDY_VER}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
