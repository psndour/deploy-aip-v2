#!/bin/bash

generate_random_string() {
    length=$1
    tr -dc A-Za-z0-9 < /dev/urandom | head -c $length
}
# Assign the generated random string to the variable
random_string=$(generate_random_string 28)
ROOT_PATH_AIP="/gestion-certificats/aip"
curl --cert $ROOT_PATH_AIP/aip-client.pem --key $ROOT_PATH_AIP/aip-client.key  -k 'https://sandbox-aip.free.sn:8081/participants/listes' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data '{
  "msgId": "'"MSNC003$random_string"'",
  "requete": "ALL"
}'
