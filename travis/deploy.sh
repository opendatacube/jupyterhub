#!/bin/bash

TAG=$(git describe --tags | awk -F'[-.]' '{if ($4!="" && $5!="") print $1"."$2"."$3+1"-unstable."$4"."$5; else print $1"."$2"."$3;}')
BASE="${IMAGE_BASE:-opendatacube/jupyterhub}"

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker tag ${BASE}:_travis ${BASE}:"${TAG}"
docker push ${BASE}:"${TAG}"

if [ "${TRAVIS_BRANCH}" = master ]; then
    docker tag ${BASE}:_travis ${BASE}:latest
    docker push ${BASE}:latest
fi

