FROM golang AS builder
WORKDIR /usr/bin
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

ARG CADDY_TAG=7672b7848f196e1baa859bcc2cf6610546097947
ARG L4_TAG=87e3e5e2c7f986b34c0df373a5799670d7b8ca03
RUN xcaddy build ${CADDY_TAG} \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/mholt/caddy-l4@${L4_TAG}

FROM caddy:latest AS dist
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
