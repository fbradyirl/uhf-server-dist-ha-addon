#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/swapplications/uhf-server-dist"
WORKDIR="/opt/uhf-server-dist"
RECORDINGS_DIR="/data/recordings"

mkdir -p "${RECORDINGS_DIR}"
export RECORDINGS_DIR

echo "[uhf-addon] Cloning upstream repo into ${WORKDIR}"
rm -rf "${WORKDIR}"
git clone --depth=1 "${REPO_URL}" "${WORKDIR}"

cd "${WORKDIR}"

command_override=""
if [ -f /data/options.json ]; then
  command_override="$(jq -r '.command // empty' /data/options.json || true)"
fi

if [ -n "${command_override}" ]; then
  echo "[uhf-addon] Using configured command: ${command_override}"
  exec bash -lc "${command_override}"
fi

if [ -x "./run.sh" ]; then
  echo "[uhf-addon] Auto-detected executable ./run.sh"
  exec ./run.sh
fi

if [ -x "./start.sh" ]; then
  echo "[uhf-addon] Auto-detected executable ./start.sh"
  exec ./start.sh
fi

if [ -x "./entrypoint.sh" ]; then
  echo "[uhf-addon] Auto-detected executable ./entrypoint.sh"
  exec ./entrypoint.sh
fi

if [ -f "./run.sh" ]; then
  echo "[uhf-addon] Auto-detected ./run.sh"
  exec bash ./run.sh
fi

if [ -f "./start.sh" ]; then
  echo "[uhf-addon] Auto-detected ./start.sh"
  exec bash ./start.sh
fi

if [ -f "./entrypoint.sh" ]; then
  echo "[uhf-addon] Auto-detected ./entrypoint.sh"
  exec bash ./entrypoint.sh
fi

echo "[uhf-addon] No entrypoint found in upstream repo."
echo "[uhf-addon] Set a custom command in the add-on config, e.g.:"
echo "[uhf-addon]   command: \"./run.sh\""
exit 1
