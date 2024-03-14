#!/bin/bash
set -a; source ./keystore.env; set +a
CHEMIN_REP_CERTIF_FROM_PI=./pi
CERTIF_MTLS_PI=$CHEMIN_REP_CERTIF_FROM_PI/mtls
CERTIF_SIGNATURE_PI=$CHEMIN_REP_CERTIF_FROM_PI/signature
CHEMIN_REP_CA=./ca
mkdir $CHEMIN_REP_CERTIF_FROM_PI
GENERATED_PASSWORD_KEYSTORE=$(head -c 16 /dev/urandom | base64)
GENERATED_PASSWORD_TRUSTSTORE=$(head -c 16 /dev/urandom | base64)
mkdir $CHEMIN_REP_CA
awk '/-----END CERTIFICATE-----/ {n++; next} {print > ("./ca/cert" n ".pem")}' "$CHEMIN_CHAIN_CA_PI"
mv $CHEMIN_REP_CA/cert.pem $CHEMIN_REP_CA/sub.pem
echo "-----END CERTIFICATE-----" >> $CHEMIN_REP_CA/sub.pem
mv $CHEMIN_REP_CA/cert1.pem ./ca/root.pem
echo "-----END CERTIFICATE-----" >> $CHEMIN_REP_CA/root.pem

touch $REP_KEYSTORE/credentials.txt
if [ $TYPE_CERTIF = 'MTLS' ]
    then
        REP_KEYSTORE=$CERTIF_MTLS_PI
        mkdir $REP_KEYSTORE
        keytool -import -trustcacerts -alias sub -file $CHEMIN_REP_CA/sub.pem -keystore $REP_KEYSTORE/client-pi.p12 -storepass $GENERATED_PASSWORD_KEYSTORE -noprompt
        keytool -import -trustcacerts -alias sub -file $CHEMIN_REP_CA/sub.pem -keystore $REP_KEYSTORE/server-truststore-pi.p12 -storepass $GENERATED_PASSWORD_TRUSTSTORE -noprompt
        keytool -import -trustcacerts -alias root -file $CHEMIN_REP_CA/root.pem -keystore $REP_KEYSTORE/client-pi.p12 -storepass $GENERATED_PASSWORD_KEYSTORE -noprompt
        keytool -import -trustcacerts -alias root -file $CHEMIN_REP_CA/root.pem -keystore $REP_KEYSTORE/server-truststore-pi.p12 -storepass $GENERATED_PASSWORD_TRUSTSTORE -noprompt

        keytool -import -trustcacerts -alias $CODE_MEMBRE -file $CHEMIN_CERT_FROM_PI -keystore $REP_KEYSTORE/client-pi.p12 -storepass $GENERATED_PASSWORD_KEYSTORE -noprompt
        keytool -import -trustcacerts -alias $CODE_MEMBRE -file $CHEMIN_CERT_CLIENT_MTLS_PI -keystore $REP_KEYSTORE/server-truststore-pi.p12 -storepass $GENERATED_PASSWORD_TRUSTSTORE -noprompt

        echo "mot-de-passe-keystore-$TYPE_CERTIF: $GENERATED_PASSWORD_KEYSTORE" >> $REP_KEYSTORE/credentials.txt
        echo "mot-de-passe-truststore-$TYPE_CERTIF: $GENERATED_PASSWORD_TRUSTSTORE" >> $REP_KEYSTORE/credentials.txt
    else
        REP_KEYSTORE=$CERTIF_SIGNATURE_PI
        mkdir $REP_KEYSTORE
        openssl pkcs12 -export -in $CHEMIN_CERT_FROM_PI -out $REP_KEYSTORE/$CODE_MEMBRE.p12 -name $CODE_MEMBRE -inkey $CHEMIN_CLE_PRIVEE -password pass:$GENERATED_PASSWORD_KEYSTORE
        echo "mot-de-passe-keystore-$TYPE_CERTIF: $GENERATED_PASSWORD_KEYSTORE" >> $REP_KEYSTORE/credentials.txt
fi
