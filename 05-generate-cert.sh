#!/bin/bash

set -a; source .env; set +a
set -a; source function.sh; set +a


echo "==================COPY CERT ELASTIC SEARCH=========================="

cp "$ELASTIC_PATH/config/elastic-certificates.p12" "$AIP_PATH/config/elasticsearch/elastic-certificates.p12"
cp "$ELASTIC_PATH/config/elasticsearch-ca.pem" "$AIP_PATH/config/elasticsearch/elasticsearch-ca.pem"
cp "$ELASTIC_PATH/config/kibana.yml" "$AIP_PATH/config/elasticsearch/kibana.yml"
cp "$ELASTIC_PATH/config/logstash.yml" "$AIP_PATH/logstash/config/logstash.yml"
cp "$ELASTIC_PATH/credentials.txt" "$AIP_PATH/credentials-elastic.txt"

echo "==================GENERATE CERTIFICATS AIP=========================="

git clone "https://$GITHUB_USER_NAME:$GITHUB_PASSWORD@github.com/bceaopi/gestion-certificats.git" $CERTS_PATH
cd "$CERTS_PATH" || exit
echo "===============================UPDATE KEYSTORE GENERATE SCRIP============================="
cat <<EOF > autogen.env
TAILLE_CLE_PRIVEE=$TAILLE_CLE_PRIVEE
PAYS="$PAYS"
VILLE="$VILLE"
QUARTIER="$QUARTIER"
NOM_ENTREPRISE="$NOM_ENTREPRISE"
HOSTNAME_OR_DOMAIN_NAME_BACKEND_PARTICIPANT="$HOSTNAME_OR_DOMAIN_NAME_BACKEND_PARTICIPANT"
HOSTNAME_OR_DOMAIN_NAME_AIP="$HOSTNAME_OR_DOMAIN_NAME_AIP"
EOF
echo "==================COPY CERTIFICATS TO AIP=========================="
bash "$CERTS_PATH/generer-certificats-auto.sh"
cp "$CERTS_PATH/aip/server-aip.key" "$AIP_PATH/certificats/server-aip.key"
cp "$CERTS_PATH/aip/server-aip.pem" "$AIP_PATH/certificats/server-aip.pem"
cp "$CERTS_PATH/aip/server.p12" "$AIP_PATH/certificats/server.p12"
cp "$CERTS_PATH/aip/server-truststore.p12" "$AIP_PATH/certificats/server-truststore.p12"
cp "$CERTS_PATH/aip/client.p12" "$AIP_PATH/certificats/client.p12"
cp "$CERTS_PATH/aip/client-truststore.p12" "$AIP_PATH/certificats/client-truststore.p12"
cp "$CERTS_PATH/ca/rootCA.pem" "$AIP_PATH/certificats/rootCA.pem"
cp "$CERTS_PATH/aip/credentials.txt" "$AIP_PATH/credentials.txt"

echo "==================GENERATE CERTIFICAT SIGNATURE=========================="
#cat "$PATH_CERT_ON_HOST/signature/$CODE_MEMBRE.pem"  > "$PATH_CERT_ON_HOST/signature/pi.pem"
#cat "$PATH_CERT_ON_HOST/signature/chain.pem" >> "$PATH_CERT_ON_HOST/signature/pi.pem"
cat <<EOF > keystore.env
TYPE_CERTIF=SIGNATURE
CHEMIN_CHAIN_CA_PI="$PATH_CERT_ON_HOST/signature/chain.pem"
CODE_MEMBRE="$CODE_MEMBRE"
CHEMIN_CLE_PRIVEE="$PATH_CERT_ON_HOST/signature/$CODE_MEMBRE.key"
MDP_CLE_PRIVEE=$MDP_CLE_PRIVEE_SIGNATURE
CHEMIN_CERT_FROM_PI=$PATH_CERT_ON_HOST/signature/$CODE_MEMBRE.pem
CHEMIN_CERT_PI="$PATH_CERT_ON_HOST/signature/pi.pem"
EOF
#generate
bash "$CERTS_PATH/generer-keystore.sh"
echo "==================COPY CERTIFICAT SIGNATURES=========================="
cp "$CERTS_PATH/pi/signature/$CODE_MEMBRE.p12" "$AIP_PATH/certificats/$CODE_MEMBRE.p12"
cp "$CERTS_PATH/pi/signature/credentials.txt" "$AIP_PATH/certificats/credentials-signature.txt"

echo "==================GENERATE CERTIFICAT mTLS=========================="
#cat "$PATH_CERT_ON_HOST/mtls/$CODE_MEMBRE.pem"  > "$PATH_CERT_ON_HOST/mtls/pi.pem"
#cat  "$PATH_CERT_ON_HOST/mtls/chain.pem" >> "$PATH_CERT_ON_HOST/mtls/pi.pem"
cat <<EOF > keystore.env
TYPE_CERTIF=MTLS
CHEMIN_CHAIN_CA_PI="$PATH_CERT_ON_HOST/mtls/chain.pem"
CODE_MEMBRE="$CODE_MEMBRE"
CHEMIN_CLE_PRIVEE="$PATH_CERT_ON_HOST/mtls/$CODE_MEMBRE.key"
MDP_CLE_PRIVEE="$MDP_CLE_PRIVEE_MTL"
CHEMIN_CERT_FROM_PI="$PATH_CERT_ON_HOST/mtls/$CODE_MEMBRE.pem"
CHEMIN_CERT_PI="$PATH_CERT_ON_HOST/mtls/pi.pem"
EOF
#generate
bash "$CERTS_PATH/generer-keystore.sh"
echo "==================COPY CERTIFICAT MTLS=========================="
cp "$CERTS_PATH/pi/mtls/client-pi.p12" "$AIP_PATH/certificats/client-pi.p12"
cp "$CERTS_PATH/pi/mtls/server-truststore-pi.p12" "$AIP_PATH/certificats/server-truststore-pi.p12"
cp "$CERTS_PATH/pi/mtls/credentials.txt" "$AIP_PATH/certificats/credentials-mtls.txt"

echo "==================GENERATE CERTIFICAT PUBLIC CERTS=========================="

cat <<EOF > keystore-srv-public.env
# C'est le chemin vers le fichier de certification de l'autorité publique qui a délivré le certificat
# utilisé pour protéger les endpoints de l'AIP dans sa communication par mTLS avec PI (sens: PI -> AIP)
CHEMIN_CERT_CA_PUBLIC="$PATH_CERT_ON_HOST/public-free/chain.pem"
# C'est le chemin vers le fichier de clé privée utilisée pour protéger les endpoints de l'AIP dans sa communication par mTLS avec PI (sens: PI -> AIP)
CHEMIN_CLE_PRIVEE_SRV_AIP="$PATH_CERT_ON_HOST/public-free/$CODE_MEMBRE.key"
# C'est le chemin vers le fichier certificat utilisé pour protéger les endpoints de l'AIP dans sa communication par mTLS avec PI (sens: PI -> AIP)
CHEMIN_CERT_SRV_AIP="$PATH_CERT_ON_HOST/public-free/$CODE_MEMBRE.pem"
EOF
bash "$CERTS_PATH/generer-keystore-public-server.sh"
#fiexed changed name
cp "$CERTS_PATH/srv-aip/credentials.txt" "$AIP_PATH/certificats/credentials-srv-public.txt"
cp "$CERTS_PATH/srv-aip/server-pi.p12" "$AIP_PATH/certificats/server-pi.p12"