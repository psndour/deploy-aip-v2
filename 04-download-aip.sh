#!/bin/bash

set -a; source .env; set +a
set -a; source function.sh; set +a
git clone "https://$GITHUB_USER_NAME:$GITHUB_PASSWORD@github.com/bceaopi/deploiement-outils-docker.git" "$AIP_PATH"
cd "$AIP_PATH" || exit

