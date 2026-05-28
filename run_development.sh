#!/bin/bash

CURRENT_PATH="$(cd "$(dirname "$1")" || exit; pwd)/$(basename "$1")"
IMAGE_NAME=ghcr.io/navikt/pdfgenrs:0.1.71

docker pull --platform linux/amd64 ${IMAGE_NAME}
docker run \
        -v "${CURRENT_PATH}"/templates:/app/templates \
        -v "${CURRENT_PATH}"/fonts:/app/fonts \
        -v "${CURRENT_PATH}"/data:/app/data \
        -v "${CURRENT_PATH}"/resources:/app/resources \
        --platform linux/amd64 \
        -p 8080:8080 \
        -e DEV_MODE=true \
        -it \
        --rm \
        ${IMAGE_NAME}
