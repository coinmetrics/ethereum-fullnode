#!/bin/sh

set -e

echo "Building image..."
docker build -t "${DOCKER_REGISTRY_REPO}" .
echo "Image ready."

if [ -n "${DOCKER_REGISTRY}" ] && [ -n "${DOCKER_REGISTRY_USER}" ] && [ -n "${DOCKER_REGISTRY_PASSWORD}" ]
then
	echo "Logging into ${DOCKER_REGISTRY}..."
	exit 0
	docker login -u="${DOCKER_REGISTRY_USER}" -p="${DOCKER_REGISTRY_PASSWORD}" "${DOCKER_REGISTRY}"
	echo "Pushing image to ${DOCKER_REGISTRY_REPO}..."
	docker push ${DOCKER_REGISTRY_REPO}:latest
fi
