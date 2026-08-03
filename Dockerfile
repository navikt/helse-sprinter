FROM ghcr.io/navikt/pdfgenrs:1.0.20

COPY templates /app/templates
COPY fonts /app/fonts
COPY resources /app/resources
