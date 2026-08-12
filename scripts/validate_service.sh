#!/bin/bash
# ValidateService hook.
# Confirms that the application is actually answering requests before CodeDeploy
# reports the deployment as successful. Without this hook a deployment would be
# marked "Succeeded" merely because the container was started, even if the
# application inside it were broken.

set -e

URL="http://localhost:3000/super-app"
EXPECTED='{"super":"app"}'
ATTEMPTS=10

echo "Validating that the application responds on ${URL}..."

for i in $(seq 1 ${ATTEMPTS}); do
    RESPONSE=$(curl -s --max-time 5 "${URL}" || true)

    if [ "${RESPONSE}" = "${EXPECTED}" ]; then
        echo "Attempt ${i}: application responded correctly with ${RESPONSE}"
        echo "Validation succeeded."
        exit 0
    fi

    echo "Attempt ${i}/${ATTEMPTS}: not ready yet (got: '${RESPONSE}'). Retrying in 3 seconds..."
    sleep 3
done

echo "Validation failed: the application did not return the expected response."
docker logs "super-app-node" || true
exit 1
