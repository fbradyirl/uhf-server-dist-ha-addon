#!/usr/bin/env bash
set -euo pipefail

RECORDINGS_DIR="/data/recordings"
DB_DIR="/data/db"
DEFAULT_PORT="8000"

mkdir -p "${RECORDINGS_DIR}"
mkdir -p "${DB_DIR}"
export RECORDINGS_DIR

command_override=""
port="${DEFAULT_PORT}"
password=""
enable_commercial_detection="true"
if [ -f /data/options.json ]; then
  command_override="$(jq -r '.command // empty' /data/options.json || true)"
  port="$(jq -r '.port // 8000' /data/options.json || true)"
  password="$(jq -r '.password // empty' /data/options.json || true)"
  enable_commercial_detection="$(jq -r '.enable_commercial_detection // true' /data/options.json || true)"
fi

if [ -n "${command_override}" ]; then
  echo "[uhf-addon] Using configured command: ${command_override}"
  exec bash -lc "${command_override}"
fi

if [ ! -x "$(command -v uhf-server)" ]; then
  echo "[uhf-addon] uhf-server binary not found in image."
  exit 1
fi

if [ ! -L /var/lib/uhf-server ]; then
  rm -rf /var/lib/uhf-server
  ln -s "${DB_DIR}" /var/lib/uhf-server
fi

args=(--port "${port}" --recordings-dir "${RECORDINGS_DIR}")
if [ -n "${password}" ]; then
  args+=(--password "${password}")
fi
if [ "${enable_commercial_detection}" = "true" ]; then
  args+=(--enable-commercial-detection)
fi

echo "[uhf-addon] Starting uhf-server on port ${port}"
exec uhf-server "${args[@]}"
