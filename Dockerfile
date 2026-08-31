FROM ghcr.io/navikt/pdfgenrs:1.0.30

COPY templates /app/templates
COPY fonts /app/fonts
COPY resources /app/resources
