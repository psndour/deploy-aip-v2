#!/bin/bash
set -a; source .env; set +a
set -a; source function.sh; set +a
sudo systemctl disable "$ELASTIC_SEARCH_SERVICE_NAME"
sudo systemctl stop "$ELASTIC_SEARCH_SERVICE_NAME"
rm -rf /etc/systemd/system/"$ELASTIC_SEARCH_SERVICE_NAME".service
sudo rm -rf "$ELASTIC_PATH"
sudo systemctl daemon-reload

