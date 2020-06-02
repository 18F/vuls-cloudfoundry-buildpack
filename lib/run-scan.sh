#!/usr/bin/env bash

VULS_SERVER="${VULS_SERVER:-127.0.0.1}"
VULS_HTTP_SERVER="${VULS_HTTP_SERVER:-http://localhost:5515/vuls}"
VULS_PATH="${VULS_PATH:-/home/vcap/deps/##INDEX##}"
RESULTS_DIR="${RESULTS_DIR:-/home/vcap/tmp}"
VULS_BIN="${VULS_BIN:-${VULS_PATH}/vuls}"
VULS_SCAN_OPTS="${VULS_SCAN_OPTS:-scan -config=${VULS_PATH}/dist/config.toml -results-dir=${RESULTS_DIR}}"
UPLOAD_BIN=${UPLOAD_BIN:-/usr/bin/curl}
UPLOAD_OPTS="${UPLOAD_OPTS:--X POST -H 'Content-Type: application/json' -d @${RESULTS_DIR}/current/localhost.json ${VULS_HTTP_SERVER}}"

$VULS_BIN $VULS_SCAN_OPTS
$UPLOAD_BIN $UPLOAD_OPTS
