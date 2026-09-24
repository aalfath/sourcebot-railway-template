# Sourcebot v5.1.14 with a first-start admin bootstrap and an optional repo list from the environment.
FROM ghcr.io/sourcebot-dev/sourcebot:v5.1.14@sha256:76fc0fb473af761aab613cf4373b69aa4492d13c083aecbe92f8b62286c5cf9a
COPY railway-bootstrap.mjs /app/railway-bootstrap.mjs
COPY railway-entrypoint.sh /app/railway-entrypoint.sh
ENTRYPOINT ["/sbin/tini", "--", "/app/railway-entrypoint.sh"]
