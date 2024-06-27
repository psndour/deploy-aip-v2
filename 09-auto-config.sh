#!/bin/bash
set -a; source .env; set +a
set -a; source function.sh; set +a
#SET PASSWORD AIP CERT
PATH_CREDENTIAL="$AIP_PATH/credentials.txt"
PATH_ENV_AIP="$AIP_PATH/.env"
update_line_value "MDP_CLIENT_TRUSTSTORE_PARTICIPANT=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-truststore-client")" "$PATH_ENV_AIP" ""
update_line_value "MDP_CLIENT_KEYSTORE_PARTICIPANT=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-keystore-client")" "$PATH_ENV_AIP" ""
#before empty : change to same mot-de-passe-keystore-client
update_line_value "MDP_CLIENT_KEY_PARTICIPANT=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-keystore-client")" "$PATH_ENV_AIP" ""
update_line_value "MDP_SERVEUR_KEYSTORE_PARTICIPANT=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-keystore-serveur")" "$PATH_ENV_AIP" ""
update_line_value "MDP_SERVEUR_TRUSTSTORE_PARTICIPANT=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-truststore-serveur")" "$PATH_ENV_AIP" ""
#SET PASSWORD PI SIGNATURE CERT
PATH_CREDENTIAL="$AIP_PATH/certificats/credentials-signature.txt"
update_line_value "MDP_SIGNATURE_KEYSTORE_PARTICIPANT=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-keystore-SIGNATURE")" "$PATH_ENV_AIP" ""
#SET PASSWORD PI M-TLS CERT
PATH_CREDENTIAL="$AIP_PATH/certificats/credentials-mtls.txt"
update_line_value "MDP_CLIENT_KEYSTORE_PI=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-keystore-MTLS")" "$PATH_ENV_AIP" ""
update_line_value "MDP_CLIENT_KEY_PI=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-keystore-MTLS")" "$PATH_ENV_AIP" ""
update_line_value "MDP_SERVEUR_TRUSTSTORE_PI=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-truststore-MTLS")" "$PATH_ENV_AIP" ""
#ADDED ON TROUBLE SHOOTING
update_line_value "MDP_CLIENT_TRUSTSTORE_PI=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-truststore-MTLS")" "$PATH_ENV_AIP" ""
#PUCLIC
PATH_CREDENTIAL="$AIP_PATH/certificats/credentials-srv-public.txt"
update_line_value "MDP_SERVEUR_KEYSTORE_PI=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-keystore-public-server-aip")" "$PATH_ENV_AIP" ""

#SET FOR ELASTIC SEARCH
PATH_CREDENTIAL="$AIP_PATH/credentials-elastic.txt"
update_line_value "ELASTICSEARCH_TRUSTSTORE_PASSWORD=" "$(function_bash "$PATH_CREDENTIAL" "mot-de-passe-truststore")" "$PATH_ENV_AIP" ""
update_line_value "ELASTICSEARCH_USER_NAME=" "elastic" "$PATH_ENV_AIP" ""
update_line_value "ELASTICSEARCH_USER_PWD=" "$(function_bash "$PATH_CREDENTIAL" "elastic-password")" "$PATH_ENV_AIP" ""