#!/bin/bash
# ApplicationStart hook.
# Pulls the image that was published to Docker Hub by the GitHub Actions
# workflow in Part B, and starts it as a container on the instance.

set -e

IMAGE="abdalrahmanm02/super-app-node:latest"
CONTAINER_NAME="super-app-node"
HOST_PORT=3000
CONTAINER_PORT=3000

echo "Pulling ${IMAGE} from Docker Hub..."
docker pull "${IMAGE}"

echo "Starting the container..."
docker run -d \
    --name "${CONTAINER_NAME}" \
    --restart unless-stopped \
    -p "${HOST_PORT}:${CONTAINER_PORT}" \
    "${IMAGE}"

echo "Container started:"
docker ps --filter "name=${CONTAINER_NAME}"
