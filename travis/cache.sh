#!/bin/bash


load_cache () {
    if [[ -f ${CACHE_FILE} ]]; then
        docker load -i ${CACHE_FILE}
    else
        echo "no local cache will pull ${IMAGE_BASE}:latest";
        docker pull "${IMAGE_BASE}:latest"
        docker tag "${IMAGE_BASE}:latest" "${CACHE_IMAGE}"
    fi
}

save_cache () {
    # TODO: detect no change and don't update cache then
    mkdir -p ${CACHE_DIR}
    docker tag "${IMAGE}" "${CACHE_IMAGE}"
    docker images
    docker save "${CACHE_IMAGE}" | gzip -2 > ${CACHE_FILE}
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
