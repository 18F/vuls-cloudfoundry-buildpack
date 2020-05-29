#!/usr/bin/env bash

VULS_PATH="${VULS_PATH:-/home/vcap/deps/##INDEX##/depscan/vuls}"
DEPSCAN_DIR="${DEPSCAN_DIR:-/home/vcap/tmp}"

echo "This is a test on $(date)" >> $DEPSCAN_DIR/vulstest.txt