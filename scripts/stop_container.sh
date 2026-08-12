#!/bin/bash
# ApplicationStop hook.
# Removes the container left running by the previous deployment, so the new one
# can bind to the same port. This hook does not run on the very first
# deployment, because CodeDeploy takes it from the previously deployed revision
# and no previous revision exists yet.
#
# Note: this script must never fail the deployment when there is simply nothing
# to stop, which is why the removal is guarded and errors are tolerated.

CONTAINER_NAME="super-app-node"

echo "Looking for an existing container named ${CONTAINER_NAME}..."

if [ -n "$(docker ps -aq -f name=^/${CONTAINER_NAME}$ 2>/dev/null)" ]; then
    echo "Found it. Stopping and removing..."
    docker rm -f "${CONTAINER_NAME}" || true
    echo "Old container removed."
else
    echo "No existing container found. Nothing to stop."
fi

exit 0
