#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; pwd)"
IMAGE_NAME=ghcr.io/navikt/pdfgenrs:0.1.71
CONTAINER_NAME=spre-gosys-pdf-dev

docker pull -q --platform linux/amd64 "${IMAGE_NAME}"

# Stop any leftover container from a previous run
docker rm -f "${CONTAINER_NAME}" > /dev/null 2>&1 || true

docker run \
        -v "${SCRIPT_DIR}"/templates:/app/templates \
        -v "${SCRIPT_DIR}"/fonts:/app/fonts \
        -v "${SCRIPT_DIR}"/data:/app/data \
        -v "${SCRIPT_DIR}"/resources:/app/resources \
        --platform linux/amd64 \
        -p 8080:8080 \
        -e DEV_MODE=true \
        -d \
        --rm \
        --name "${CONTAINER_NAME}" \
        "${IMAGE_NAME}" > /dev/null

# Wait for server to become ready
echo "Waiting for server to start..."
until curl -s --max-time 1 http://localhost:8080/ > /dev/null 2>&1; do
    sleep 0.5
done
echo "Server is ready"

# Generate a PDF for every template that has a matching data file
for template_dir in "${SCRIPT_DIR}"/templates/*/; do
    subfolder=$(basename "${template_dir}")

    for typ_file in "${template_dir}"*.typ; do
        [ -f "${typ_file}" ] || continue
        template_name=$(basename "${typ_file}" .typ)

        data_file="${SCRIPT_DIR}/data/${subfolder}/${template_name}.json"
        [ -f "${data_file}" ] || continue   # skip layout.typ, utils.typ, etc.

        output_file="${template_dir}${template_name}.pdf"

        echo "  Generating ${subfolder}/${template_name}.pdf ..."
        http_status=$(curl -s -o "${output_file}" -w "%{http_code}" \
            -X POST \
            -H "Content-Type: application/json" \
            -d @"${data_file}" \
            "http://localhost:8080/api/v1/genpdf/${subfolder}/${template_name}")

        if [ "${http_status}" -eq 200 ]; then
            echo "    OK -> ${output_file}"
        else
            echo "    FAILED (HTTP ${http_status}) - check docker logs ${CONTAINER_NAME}"
            rm -f "${output_file}"
        fi
    done
done

echo ""
echo "Attaching to container. Ctrl+C to terminate container"
docker attach "${CONTAINER_NAME}"
