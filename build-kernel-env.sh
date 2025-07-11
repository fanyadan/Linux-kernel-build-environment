#!/bin/bash

# Script to build the Linux kernel build environment Docker image

set -e

# Get current user ID and group ID to avoid permission issues
USER_ID=$(id -u)
GROUP_ID=$(id -g)
USERNAME=$(whoami)

echo "Building kernel build environment Docker image..."
echo "User ID: $USER_ID"
echo "Group ID: $GROUP_ID"
echo "Username: $USERNAME"

# Build the Docker image
docker build \
    --build-arg USER_ID=$USER_ID \
    --build-arg GROUP_ID=$GROUP_ID \
    --build-arg USERNAME=$USERNAME \
    -f Dockerfile.kernel-build \
    -t kernel-build-env \
    .

echo "Docker image 'kernel-build-env' built successfully!"
echo "You can now use the 'kmake' command to compile the kernel."
