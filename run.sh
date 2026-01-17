#!/usr/bin/env bash
set -euo pipefail

RECORDINGS_DIR="/data/recordings"
DB_DIR="/data/db"
DEFAULT_PORT="8000"

mkdir -p "${RECORDINGS_DIR}"
mkdir -p "${DB_DIR}"
export RECORDINGS_DIR

command_override=""
host="0.0.0.0"
port="${DEFAULT_PORT}"
password=""
enable_commercial_detection="true"
extra_args=""
ffmpeg_path=""
comskip_path=""
db_path=""
log_level="INFO"
if [ -f /data/options.json ]; then
  command_override="$(jq -r '.command // empty' /data/options.json || true)"
  host="$(jq -r '.host // "0.0.0.0"' /data/options.json || true)"
  port="$(jq -r '.port // 8000' /data/options.json || true)"
  password="$(jq -r '.password // empty' /data/options.json || true)"
  enable_commercial_detection="$(jq -r '.enable_commercial_detection // true' /data/options.json || true)"
  extra_args="$(jq -r '.extra_args // empty' /data/options.json || true)"
  ffmpeg_path="$(jq -r '.ffmpeg_path // empty' /data/options.json || true)"
  comskip_path="$(jq -r '.comskip_path // empty' /data/options.json || true)"
  db_path="$(jq -r '.db_path // empty' /data/options.json || true)"
  log_level="$(jq -r '.log_level // "INFO"' /data/options.json || true)"
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

args=(--host "${host}" --port "${port}" --recordings-dir "${RECORDINGS_DIR}")
if [ -n "${password}" ]; then
  args+=(--password "${password}")
fi
if [ "${enable_commercial_detection}" = "true" ]; then
  args+=(--enable-commercial-detection)
fi
if [ -n "${ffmpeg_path}" ]; then
  args+=(--ffmpeg-path "${ffmpeg_path}")
fi
if [ -n "${comskip_path}" ]; then
  args+=(--comskip-path "${comskip_path}")
fi
if [ -n "${db_path}" ]; then
  args+=(--db-path "${db_path}")
fi
if [ -n "${log_level}" ]; then
  args+=(--log-level "${log_level}")
fi
if [ -n "${extra_args}" ]; then
  read -r -a extra_args_array <<< "${extra_args}"
  args+=("${extra_args_array[@]}")
fi

echo "[uhf-addon] Starting uhf-server on ${host}:${port}"
exec uhf-server "${args[@]}"
