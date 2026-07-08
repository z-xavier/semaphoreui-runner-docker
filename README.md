# semaphoreui-runner-docker

Semaphore UI runner image with Docker CLI, Docker Compose plugin, and `sops`
added.

This image is intended for runner jobs that need to call the host Docker daemon
through `/var/run/docker.sock`. It does not run Docker-in-Docker.

Recommended image tags should include both upstream versions:

```text
runner-<semaphoreui-runner-version>-docker-cli-<docker-cli-version>
```

Example:

```text
zxavier/semaphoreui-runner-docker:runner-2.14.10-docker-cli-29
ghcr.io/z-xavier/semaphoreui-runner-docker:runner-2.14.10-docker-cli-29
```

`latest` may be published as a moving convenience tag, but versioned tags are
preferred for reproducible deployments.
