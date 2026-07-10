FROM docker:29-cli AS docker-cli

FROM semaphoreui/runner:v2.18.24

USER root

COPY --from=docker-cli /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker-cli /usr/local/libexec/docker/cli-plugins/docker-compose /usr/local/libexec/docker/cli-plugins/docker-compose

RUN apk add --no-cache sops

ENV DOCKER_HOST=unix:///var/run/docker.sock
