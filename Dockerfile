# syntax=docker/dockerfile:1

ARG ALPINE_VERSION=3.24
ARG CADDY_VERSION=2.11.4
ARG GO_VERSION=1.26
ARG XCADDY_VERSION=v0.4.5

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder

ARG CADDY_VERSION
ARG XCADDY_VERSION

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    set -eux; \
    apk add --no-cache --upgrade \
        ca-certificates \
        git; \
    go install github.com/caddyserver/xcaddy/cmd/xcaddy@${XCADDY_VERSION}

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build v${CADDY_VERSION} \
    --output /usr/bin/caddy \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-l4 \
    --with github.com/caddyserver/cache-handler \
    --with github.com/fvbommel/caddy-combine-ip-ranges \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/go-jose/go-jose/v3@v3.0.5 \
    --with github.com/go-jose/go-jose/v4@v4.1.4 \
    --with github.com/Azure/go-ntlmssp@v0.1.1

FROM alpine:${ALPINE_VERSION}

ARG CADDY_VERSION

LABEL org.opencontainers.image.title="caddy" \
      org.opencontainers.image.description="Custom Caddy image with Cloudflare DNS, L4, cache, and IP utility plugins" \
      org.opencontainers.image.version="${CADDY_VERSION}" \
      org.opencontainers.image.source="https://github.com/zhdsmy/caddy" \
      org.opencontainers.image.licenses="Apache-2.0"

RUN set -eux; \
    apk add --no-cache --upgrade \
        ca-certificates \
        curl \
        libcrypto3 \
        libcap \
        libssl3 \
        mailcap; \
    mkdir -p \
        /config/caddy \
        /data/caddy \
        /etc/caddy \
        /usr/share/caddy \
    ; \
    chmod 1777 /config/caddy /data/caddy; \
    printf ':80 {\n\troot * /usr/share/caddy\n\tfile_server\n}\n' > /etc/caddy/Caddyfile; \
    printf '<!DOCTYPE html><title>Caddy</title><h1>Caddy is running</h1>\n' > /usr/share/caddy/index.html

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN set -eux; \
    setcap cap_net_bind_service=+ep /usr/bin/caddy; \
    chmod +x /usr/bin/caddy; \
    caddy version

ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
