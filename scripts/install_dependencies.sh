#!/bin/bash
# AfterInstall hook.
# Makes sure Docker is installed and running on the instance before we try to
# pull and run the image. Written to be idempotent: it is safe to run on every
# deployment, and does nothing if Docker is already present and started.

set -e

echo "Checking whether Docker is installed..."

if ! command -v docker > /dev/null 2>&1; then
    echo "Docker not found. Installing..."
    if command -v dnf > /dev/null 2>&1; then
        # Amazon Linux 2023
        dnf install -y docker
    else
        # Amazon Linux 2
        yum install -y docker
    fi
else
    echo "Docker is already installed."
fi

echo "Making sure the Docker service is enabled and running..."
systemctl enable docker
systemctl start docker

docker --version
echo "Dependencies are ready."
