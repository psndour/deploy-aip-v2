#!/bin/bash
set -a; source .env; set +a
set -a; source function.sh; set +a
echo "===========================START BACKEND CERTS======================="
sudo mkdir -p  /free_backend_disk/
sudo mkdir -p  /free_backend_disk/app-certs
sudo mkdir -p  /free_backend_disk/app-env
sudo mkdir -p  /free_backend_disk/app-log
sudo mkdir -p  /free_backend_disk/mssql-data
sudo mkdir -p  /free_backend_disk/redis
sudo  chmod -R 777 /free_backend_disk/*

sudo cp "$CERTS_PATH/aip/client.p12"  /free_backend_disk/app-certs/aip-client.p12
sudo cp "$CERTS_PATH/aip/aip-client.pem"  /free_backend_disk/app-certs/sandbox-aip.free.sn.crt
sudo cp "$CERTS_PATH/aip/client-truststore.p12"  /free_backend_disk/app-certs/aip-client-truststore.p12
sudo cp "$CERTS_PATH/backend-participant/server-backend-keystore.p12"   /free_backend_disk/app-certs/server-backend-keystore.p12
sudo cp "$CERTS_PATH/backend-participant/server-backend-truststore.p12"   /free_backend_disk/app-certs/server-backend-truststore.p12

PATH_ENV_BACKEND_FREE=/conf/script/free-backend.env

#set credential
PATH_CREDENTIAL="$CERTS_PATH/backend-participant/credentials.txt"
#mot-de-passe-keystore-serveur:
#mot-de-passe-truststore-serveur:
update_line_value "KEYSTORE_PASSWORD=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-keystore-serveur")" "$PATH_ENV_BACKEND_FREE" ""
update_line_value "TRUSTSTORE_PASSWORD=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-truststore-serveur")" "$PATH_ENV_BACKEND_FREE" ""


#set credential
#mot-de-passe-keystore-client:
PATH_CREDENTIAL="$CERTS_PATH/aip/credentials.txt"
update_line_value "AIP_KEYSTORE_PASSWORD=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-keystore-client")" "$PATH_ENV_BACKEND_FREE" ""
update_line_value "AIP_TRUSTSTORE_PASSWORD=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-truststore-client")" "$PATH_ENV_BACKEND_FREE" ""
