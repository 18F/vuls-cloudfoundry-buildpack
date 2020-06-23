#!/usr/bin/env bash

VULS_SERVER="${VULS_SERVER:-127.0.0.1}"
VULS_HTTP_SERVER="${VULS_HTTP_SERVER:-http://localhost:5515/vuls}"
VULS_PATH="${VULS_PATH:-/home/vcap/deps/##INDEX##}"
CF_APP_NAME="$(echo ${VCAP_APPLICATION} | jq -r '.application_name')"
VULS_HOST_ID="${VULS_HOST_ID:-${CF_APP_NAME}-${CF_INSTANCE_INDEX}-${CF_INSTANCE_GUID}}"
RESULTS_DIR="${RESULTS_DIR:-/home/vcap/tmp}"
SCAN_BIN="${VULS_BIN:-${VULS_PATH}/vuls}"
SCAN_OPTS="${VULS_SCAN_OPTS:-scan -config=${VULS_PATH}/dist/config.toml -results-dir=${RESULTS_DIR}}"
UPLOAD_BIN="${UPLOAD_BIN:-''}"
UPLOAD_OPTS="${UPLOAD_OPTS:-''}"

sed -i "s/servers.placeholder/servers.${VULS_HOST_ID}/" $VULS_DIR/dist/config.toml

$SCAN_BIN $SCAN_OPTS

if [[ -z "$UPLOAD_BIN" ]]; then
  echo "Uploading with custom '$UPLOAD_BIN' command"
  $UPLOAD_BIN $UPLOAD_OPTS
else
  echo "Uploading with curl default"
  /usr/bin/curl -X POST \
    -H 'Content-Type: application/json' \
    -d @${RESULTS_DIR}/current/${VULS_HOST_ID}.json \
    ${VULS_HTTP_SERVER}
fi
