FROM golang AS builder
WORKDIR /usr/bin
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

ARG CADDY_TAG=v2.10.0
RUN xcaddy build ${CADDY_TAG} \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/mholt/caddy-l4 \
    --with github.com/caddyserver/cache-handler

FROM caddy:latest AS dist
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
