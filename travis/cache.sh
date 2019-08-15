#!/bin/bash

# This is not used currently as it was too slow to do `docker load|save`
# But we might revisit this idea.
#
#  1. Load docker state from cache using `docker load` or pull image from hub
#  2. Build image with `docker build --cache-from`
#  3. Save docker images to cache `docker save`
#
# Env:
#  CACHE_DIR
#  CACHE_FILE
#  IMAGE_BASE
#  IMAGE
#  CACHE_IMAGE

load_cache () {
    if [[ -f ${CACHE_FILE} ]]; then
        docker load -i ${CACHE_FILE}
    else
        echo "no local cache will pull ${IMAGE_BASE}:latest"
        docker pull "${IMAGE_BASE}:latest"
        docker tag "${IMAGE_BASE}:latest" "${CACHE_IMAGE}"
    fi
}

save_cache () {
    # TODO: detect no change and don't update cache then
    mkdir -p ${CACHE_DIR}
    docker tag "${IMAGE}" "${CACHE_IMAGE}"
    docker images
    docker save "${CACHE_IMAGE}" > ${CACHE_FILE}
}


case "$1" in
    load)
        load_cache
        ;;
    save)
        save_cache
        ;;
    *)
        echo "Need load|save argument"
        ;;
esac
