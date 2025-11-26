FROM golang AS builder
WORKDIR /usr/bin
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

ARG CADDY_TAG=fix-7292
RUN xcaddy build ${CADDY_TAG} \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/mholt/caddy-l4 \
    --with github.com/caddyserver/cache-handler \
    --with github.com/fvbommel/caddy-combine-ip-ranges \
    --with github.com/WeidiDeng/caddy-cloudflare-ip

FROM caddy:latest AS dist
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
