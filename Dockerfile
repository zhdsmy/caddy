ARG CADDY_VER=2.5.1

FROM caddy:${CADDY_VER}-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-auth-portal \
    --with github.com/greenpau/caddy-authorize \
    --with github.com/mholt/caddy-l4 \
    --with github.com/mastercactapus/caddy2-proxyprotocol

ARG CADDY_VER

FROM caddy:${CADDY_VER}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy