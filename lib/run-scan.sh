#!/usr/bin/env bash

VULS_SERVER="${VULS_SERVER:-127.0.0.1}"
VULS_HTTP_SERVER="${VULS_HTTP_SERVER:-http://localhost:5515/vuls}"
CF_APP_NAME="$(echo ${VCAP_APPLICATION} | jq -r '.application_name')"
VULS_HOST_ID="${VULS_HOST_ID:-${CF_APP_NAME}-${CF_INSTANCE_INDEX}-${CF_INSTANCE_GUID}}"
RESULTS_DIR="${RESULTS_DIR:-/home/vcap/tmp}"
SCAN_BIN="${SCAN_BIN:-vuls}"
SCAN_OPTS="${SCAN_OPTS:-scan -config=config.toml -libs-only -results-dir=${RESULTS_DIR}}"
UPLOAD_BIN="${UPLOAD_BIN:-''}"
UPLOAD_OPTS="${UPLOAD_OPTS:-'--connect-timeout 0.5 --max-time 10'}"

sed -i "s/servers.placeholder/servers.${VULS_HOST_ID}/" config.toml

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
