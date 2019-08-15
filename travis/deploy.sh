#!/bin/bash

TAG="${1:-latest}"

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker tag opendatacube/jupyterhub:_travis opendatacube/jupyterhub:"${TAG}"
docker push opendatacube/jupyterhub:"${TAG}"
