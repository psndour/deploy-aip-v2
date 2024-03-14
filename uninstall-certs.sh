#!/bin/bash
set -a; source .env; set +a
rm -rf "$CERTS_PATH"
rm -rf "$AIP_PATH/certificats/*"

