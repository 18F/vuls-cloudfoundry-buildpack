#!/usr/bin/env bash

VULS_SERVER="${VULS_SERVER:-127.0.0.1}"
VULS_HTTP_SERVER="${VULS_HTTP_SERVER:-http://localhost:5515/vuls}"
VULS_PATH="${VULS_PATH:-/home/vcap/deps/##INDEX##}"
RESULTS_DIR="${RESULTS_DIR:-/home/vcap/tmp}"
SCAN_BIN="${VULS_BIN:-${VULS_PATH}/vuls}"
SCAN_OPTS="${VULS_SCAN_OPTS:-scan -config=${VULS_PATH}/dist/config.toml -results-dir=${RESULTS_DIR} -libs-only}"
UPLOAD_BIN="${UPLOAD_BIN:-''}"
UPLOAD_OPTS="${UPLOAD_OPTS:-''}"

$SCAN_BIN $SCAN_OPTS

if [[ -z "$UPLOAD_BIN" ]]; then
  echo "Uploading with custom '$UPLOAD_BIN' command"
  $UPLOAD_BIN $UPLOAD_OPTS
else
  echo "Uploading with curl default"
  /usr/bin/curl -X POST \
    -H 'Content-Type: application/json' \
    -d @${RESULTS_DIR}/current/localhost.json \
    ${VULS_HTTP_SERVER}
fi