#!/bin/sh
# Local dev bootstrap: turns on Postgres, then the Phoenix app itself.
#
# Runs the app natively (`mix phx.server`, so you keep code reloading and
# IEx) against a Postgres started via docker compose. This is NOT the same
# script as bin/docker-entrypoint.sh, which is the Dockerfile's ENTRYPOINT
# and boots a compiled release *inside* a container - unrelated flow, kept
# separate on purpose.
set -eu

cd -P -- "$(dirname -- "$0")"

echo "==> Starting Postgres (docker compose)"
docker compose up -d db

echo "==> Waiting for Postgres to be ready"
attempt=0
until docker compose exec -T db pg_isready -U postgres >/dev/null 2>&1; do
  attempt=$((attempt + 1))
  if [ "$attempt" -ge 30 ]; then
    echo "==> Postgres never became ready, giving up" >&2
    exit 1
  fi
  sleep 1
done

echo "==> Creating/migrating the dev database"
mix ecto.create --quiet
mix ecto.migrate --quiet

echo "==> Starting the app"
exec mix phx.server
