#!/usr/bin/env bash
set -euo pipefail

cmd="${1:-health}"
shift || true

base_url="${BROWSEROS_MCP_URL:-http://127.0.0.1:9000/mcp}"
cli=""
if command -v browseros-cli >/dev/null 2>&1; then
  cli="$(command -v browseros-cli)"
elif [[ -x "$HOME/.browseros/bin/browseros-cli" ]]; then
  cli="$HOME/.browseros/bin/browseros-cli"
fi

start_app() {
  if command -v open >/dev/null 2>&1; then
    open -a BrowserOS >/dev/null 2>&1 || true
  fi
}

ensure_ready() {
  if [[ -z "$cli" ]]; then
    return 1
  fi

  if "$cli" health >/dev/null 2>&1; then
    return 0
  fi

  start_app
  sleep 2
  "$cli" init --auto >/dev/null 2>&1 || true
  "$cli" health >/dev/null 2>&1
}

if [[ -n "$cli" ]]; then
  ensure_ready || true

  case "$cmd" in
    health)
      exec "$cli" health
      ;;
    start)
      start_app
      exec "$cli" init --auto
      ;;
    init)
      exec "$cli" init --auto "$@"
      ;;
    *)
      exec "$cli" "$cmd" "$@"
      ;;
  esac
fi

case "$cmd" in
  health)
    curl -fsS "$base_url"
    ;;
  start)
    start_app
    curl -fsS "$base_url" >/dev/null 2>&1 || true
    echo "BrowserOS app start requested; CLI not installed." >&2
    ;;
  *)
    echo "BrowserOS CLI not installed; install browseros-cli or use the BrowserOS app/MCP endpoint at $base_url" >&2
    exit 1
    ;;
esac
