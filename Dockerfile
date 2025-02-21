ARG CADDY_VER=2.9.1

FROM caddy:${CADDY_VER}-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/mholt/caddy-l4

FROM caddy:${CADDY_VER}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
