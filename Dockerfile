ARG SEMAPHORE_VERSION=2.18.25

FROM alpine:3.21 AS semaphore-release

RUN apk add --no-cache curl tar

ARG SEMAPHORE_VERSION
ARG TARGETARCH

RUN set -eux; \
    package="semaphore_${SEMAPHORE_VERSION}_linux_${TARGETARCH}.tar.gz"; \
    release_url="https://github.com/semaphoreui/semaphore/releases/download/v${SEMAPHORE_VERSION}"; \
    curl -fsSLo "/tmp/${package}" "${release_url}/${package}"; \
    curl -fsSLo /tmp/checksums.txt "${release_url}/semaphore_${SEMAPHORE_VERSION}_checksums.txt"; \
    grep "  ${package}$" /tmp/checksums.txt > /tmp/checksum; \
    (cd /tmp && sha256sum -c /tmp/checksum); \
    tar -xzf "/tmp/${package}" -C /tmp semaphore; \
    chmod +x /tmp/semaphore

FROM docker:29-cli AS docker-cli

FROM semaphoreui/runner:v2.18.24

ARG SEMAPHORE_VERSION

LABEL org.opencontainers.image.version="v${SEMAPHORE_VERSION}"

USER root

COPY --from=semaphore-release /tmp/semaphore /usr/local/bin/semaphore
COPY --from=docker-cli /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker-cli /usr/local/libexec/docker/cli-plugins/docker-compose /usr/local/libexec/docker/cli-plugins/docker-compose

RUN chown semaphore:0 /usr/local/bin/semaphore \
    && chmod +x /usr/local/bin/semaphore \
    && apk add --no-cache sops

ENV DOCKER_HOST=unix:///var/run/docker.sock
