#!/bin/sh
set -eu
cd /app

# SOURCEBOT_REPOS="org/repo,org/other" writes a declarative config that indexes those GitHub repos
# (public ones work without a token; set GITHUB_TOKEN for private repos). An explicit CONFIG_PATH wins.
if [ -z "${CONFIG_PATH:-}" ] && [ -n "${SOURCEBOT_REPOS:-}" ]; then
  node -e '
    const repos = process.env.SOURCEBOT_REPOS.split(",").map((r) => r.trim()).filter(Boolean);
    const connection = { type: "github", repos };
    if (process.env.GITHUB_TOKEN) connection.token = { env: "GITHUB_TOKEN" };
    const config = { $schema: "https://raw.githubusercontent.com/sourcebot-dev/sourcebot/main/schemas/v3/index.json", connections: { github: connection } };
    require("fs").writeFileSync("/app/railway-config.json", JSON.stringify(config, null, 2));
  '
  export CONFIG_PATH=/app/railway-config.json
fi

./entrypoint.sh &
pid=$!
trap 'kill -TERM "$pid" 2>/dev/null' TERM INT

# The first account to sign in becomes the owner, so claim it with the configured admin.
node /app/railway-bootstrap.mjs || echo "sourcebot: admin bootstrap failed" >&2

status=0
wait "$pid" || status=$?
while kill -0 "$pid" 2>/dev/null; do
  wait "$pid" || status=$?
done
exit "$status"
