#!/bin/bash
set -e

IMAGE_NAME="frontend-app"

echo " Building Docker image: $IMAGE_NAME"
docker build -t $IMAGE_NAME .
echo "Build complete!"
