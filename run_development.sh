#!/bin/bash

CURRENT_PATH="$(cd "$(dirname "$1")" || exit; pwd)/$(basename "$1")"
IMAGE_NAME=ghcr.io/navikt/pdfgen:2.0.114

docker pull ${IMAGE_NAME}
docker run \
        -v "${CURRENT_PATH}"/templates:/app/templates \
        -v "${CURRENT_PATH}"/fonts:/app/fonts \
        -v "${CURRENT_PATH}"/data:/app/data \
        -v "${CURRENT_PATH}"/resources:/app/resources \
        -p 8080:8080 \
        -e ENABLE_HTML_ENDPOINT=true \
        -e DISABLE_PDF_GET=false \
        -it \
        --rm \
        ${IMAGE_NAME}
