#!/bin/sh
# Boot script for the release built by the Dockerfile.
#
#   start   -> run pending migrations, then start the Phoenix server (default)
#   migrate -> run pending migrations and exit
#   anything else is exec'd straight through to the `music_nerdle` release
#   binary, e.g. `remote` for a remote console.
set -eu

cd -P -- "$(dirname -- "$0")/.."

migrate() {
  echo "==> Running database migrations"

  attempt=0
  until ./bin/music_nerdle eval "MusicNerdle.Release.migrate()"; do
    attempt=$((attempt + 1))
    if [ "$attempt" -ge 10 ]; then
      echo "==> Database never became ready, giving up" >&2
      exit 1
    fi
    echo "==> Database not ready yet, retrying in 3s (${attempt}/10)"
    sleep 3
  done
}

case "${1:-start}" in
  start)
    migrate
    echo "==> Starting MusicNerdle"
    exec ./bin/music_nerdle start
    ;;
  migrate)
    migrate
    ;;
  *)
    exec ./bin/music_nerdle "$@"
    ;;
esac
