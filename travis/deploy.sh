#!/bin/bash

TAG=$(git describe --tags | awk -F'[-.]' '{if ($4!="" && $5!="") print $1"."$2"."$3+1"-unstable."$4"."$5; else print $1"."$2"."$3;}')

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker tag opendatacube/jupyterhub:_travis opendatacube/jupyterhub:"${TAG}"
docker push opendatacube/jupyterhub:"${TAG}"

if [ "${TRAVIS_BRANCH}" = master ]; then
    docker tag opendatacube/jupyterhub:_travis opendatacube/jupyterhub:latest
    docker push opendatacube/jupyterhub:latest
fi

