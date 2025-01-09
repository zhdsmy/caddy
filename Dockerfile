# 定义 Caddy 的版本
ARG CADDY_VER=2.9.1
ARG ALPINE_VER=3.21

# 使用 Alpine 作为构建阶段的基础镜像
FROM golang:alpine${ALPINE_VER} AS builder

# 安装 Go 和 xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest \
    && xcaddy build ${CADDY_VER} --output /usr/bin/caddy \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/mholt/caddy-l4

ARG ALPINE_VER

# 使用更小的基础镜像来创建最终的运行时镜像
FROM alpine:${ALPINE_VER}

# 复制构建好的 Caddy 二进制文件到运行时镜像
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# 创建 Caddy 的工作目录
RUN mkdir -p /etc/caddy /var/www

# 设置 Caddy 的默认工作目录
WORKDIR /etc/caddy

# 设置 Caddy 的默认命令
ENTRYPOINT ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile"]

# 暴露 Caddy 的默认端口
EXPOSE 80 443
