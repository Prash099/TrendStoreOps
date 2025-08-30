#!/bin/bash
set -e

IMAGE_NAME="trend-app"
TARGET_REPO="prash099/prash-trend-store-app"

echo " Tagging image for $TARGET_REPO"
docker tag $IMAGE_NAME:latest $TARGET_REPO:latest

echo " Stopping existing container..."
docker compose down || true

echo " Starting new container..."
docker compose up -d --build

echo " Logging in to Docker Hub..."
echo "$DOCKERHUB_CREDENTIALS" | docker login -u "prash099" --password-stdin

echo " Pushing image to $TARGET_REPO"
docker push $TARGET_REPO:latest

echo " Deployment complete! App running on port 80"
