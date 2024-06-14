#!/usr/bin/env bash
set -a; source .env; set +a
CHEMIN_REP_NFS_LOCAL=./aip
CHEMIN_REP_NFS_REMOTE=/aip
CHEMIN_REP_CERTIFICATS=./certificats
CHEMIN_REP_CONFIG=./config
CHEMIN_REP_LOGSTASH=./logstash
CHEMIN_REP_MONITORING_LOCAL=./monitoring
CHEMIN_REP_REDIS=./redis
CHEMIN_CONF_USER_REDIS=$CHEMIN_REP_REDIS/conf/users.acl
CHEMIN_REP_BO_CERT=$CHEMIN_REP_NFS_LOCAL/certificats/bo
CHEMIN_REP_KIBANA_CERT=$CHEMIN_REP_NFS_LOCAL/certificats/kibana
CHEMIN_REP_JOURNALISATION=$CHEMIN_REP_NFS_LOCAL/journalisation
CHEMIN_REP_MONITORING_REMOTE=$CHEMIN_REP_NFS_LOCAL/monitoring
CHEMIN_PROMETHEUS_CONF=$CHEMIN_REP_MONITORING_REMOTE/prometheus/prometheus.yml
CHEMIN_PROMETHEUS_DATA=$CHEMIN_REP_NFS_LOCAL/prometheus-data
CHEMIN_ALERT_CONF=$CHEMIN_REP_MONITORING_REMOTE/alertmanager/alertmanager.yml
CHEMIN_ALERTMANAGER_DATA=$CHEMIN_REP_NFS_LOCAL/alertmanager-data
CHEMIN_GRAFANA_DATA=$CHEMIN_REP_NFS_LOCAL/grafana-data
CHEMIN_ZOOKEEPER_DATA=$CHEMIN_REP_NFS_LOCAL/zookeeper-data
CHEMIN_KAFKA_DATA=$CHEMIN_REP_NFS_LOCAL/kafka-data
#todo addted
CHEMIN_KAFKA_SCRIPT=$CHEMIN_REP_NFS_LOCAL/config/scripts
CHEMIN_ZOOKEEPER_LOGS=$CHEMIN_REP_NFS_LOCAL/zookeeper-logs
CHEMIN_MONITORING_CERTIFICATS=$CHEMIN_REP_MONITORING_REMOTE/certificats
CHEMIN_KEYCLOAK_REALM=$CHEMIN_REP_NFS_LOCAL/config/keycloak/realm/realm.json
CHEMIN_KEYCLOAK_CERTIFICATS=$CHEMIN_REP_NFS_LOCAL/config/keycloak/certificats
CHEMIN_KEYCLOAK_DATA=$CHEMIN_REP_NFS_LOCAL/keycloak-data
CHEMIN_PROMETHEUS_DS=$CHEMIN_REP_MONITORING_REMOTE/grafana/provisioning/datasources/prometheus_ds.yml
CHEMIN_REP_BO_BACKEND_CERTIFICATS=$CHEMIN_REP_NFS_LOCAL/certificats/bo-backend
CHEMIN_BO_BACKEND_KEYSTORE=$CHEMIN_REP_BO_BACKEND_CERTIFICATS/bo-backend-keystore.p12
CHEMIN_TRUSTSTORE=$CHEMIN_REP_NFS_LOCAL/certificats/truststore
CHEMIN_BO_BACKEND_TRUSTSTORE=$CHEMIN_TRUSTSTORE/keycloak/keycloak-truststore.p12
CHEMIN_FICHIER_DEPLOIEMENT=deploiement-swarm.yml
CHEMIN_FICHIER_DEPLOIEMENT_TPL=deploiement-swarm-tpl.yml 
CHEMIN_FICHIER_DEPLOIEMENT_KAFKA=kafka.yml
docker login -u bceao -p $DOCKER_HUB_TOKEN

if [ -f $CHEMIN_CONF_USER_REDIS ] 
    then
        rm $CHEMIN_CONF_USER_REDIS
fi

cp $CHEMIN_FICHIER_DEPLOIEMENT_TPL $CHEMIN_FICHIER_DEPLOIEMENT

touch $CHEMIN_CONF_USER_REDIS
MDP_INTERFACEPARTICIPANT_REDIS=$(head -c 16 /dev/urandom | base64 | tr --delete /)
MDP_MOTEURTRAITEMENT_REDIS=$(head -c 16 /dev/urandom | base64 | tr --delete /)
MDP_INTERFACEPI_REDIS=$(head -c 16 /dev/urandom | base64 | tr --delete /)
MDP_POSTGRES=$(head -c 16 /dev/urandom | base64 | tr --delete /)
echo "user interfaceparticipant on +@all ~* >$MDP_INTERFACEPARTICIPANT_REDIS" >> $CHEMIN_CONF_USER_REDIS
echo "user moteurtraitement on +@all ~* >$MDP_MOTEURTRAITEMENT_REDIS" >> $CHEMIN_CONF_USER_REDIS
echo "user interfacepi on +@all ~* >$MDP_INTERFACEPI_REDIS" >> $CHEMIN_CONF_USER_REDIS
echo "user monitoring on +@all ~* >monitoring" >> $CHEMIN_CONF_USER_REDIS
echo "user default off" >> $CHEMIN_CONF_USER_REDIS

#Génération des paramétres de Kafka
bash install_kafka.sh
source .env
#mkdir $CHEMIN_MONITORING_LOCAL
mkdir $CHEMIN_REP_NFS_LOCAL
sudo mount -t nfs $NFS_SERVER_IP:$CHEMIN_REP_NFS_REMOTE $CHEMIN_REP_NFS_LOCAL

#Copier le répertoire "certificats" dans le répertoire partage du NFS
cp -R $CHEMIN_REP_CERTIFICATS $CHEMIN_REP_NFS_LOCAL
#Copier le répertoire "config" dans le répertoire de partage du NFS
cp -R $CHEMIN_REP_CONFIG $CHEMIN_REP_NFS_LOCAL
#Copier le répertoire "logstash" dans le répertoire de partage du NFS
cp -R $CHEMIN_REP_LOGSTASH $CHEMIN_REP_NFS_LOCAL
#Copier le répertoire "monitoring" dans le répertoire de partage du NFS
cp -R $CHEMIN_REP_MONITORING_LOCAL $CHEMIN_REP_NFS_LOCAL
#Copier le répertoire "monitoring" dans le répertoire de partage du NFS
cp -R $CHEMIN_REP_REDIS $CHEMIN_REP_NFS_LOCAL
sudo chown -R nobody:nobody $CHEMIN_REP_NFS_LOCAL/certificats
mkdir $CHEMIN_REP_KIBANA_CERT $CHEMIN_TRUSTSTORE $CHEMIN_REP_BO_CERT $CHEMIN_REP_BO_BACKEND_CERTIFICATS
mkdir $CHEMIN_TRUSTSTORE/keycloak
cp $BO_SUIVI_CHEMIN_SSL_CERTIFICAT $CHEMIN_REP_KIBANA_CERT/kibana-server.crt
cp $BO_SUIVI_CHEMIN_SSL_CLE $CHEMIN_REP_KIBANA_CERT/kibana-server.key
sudo chown -R nobody:nobody $CHEMIN_REP_NFS_LOCAL/config/keycloak
#Copier les fichier nécessaires à la sécurisation de keycloak
mkdir $CHEMIN_KEYCLOAK_CERTIFICATS
cp $BO_SUIVI_CHEMIN_SSL_CERTIFICAT $CHEMIN_KEYCLOAK_CERTIFICATS/host.cert
cp $BO_SUIVI_CHEMIN_SSL_CLE $CHEMIN_KEYCLOAK_CERTIFICATS/host.key

cp $BO_SUIVI_CHEMIN_SSL_CERTIFICAT $CHEMIN_REP_BO_CERT/localhost.crt
cp $BO_SUIVI_CHEMIN_SSL_CLE $CHEMIN_REP_BO_CERT/localhost.key

mkdir $CHEMIN_MONITORING_CERTIFICATS
#Clé privée et certificats utilisés par prometheus pour contacter interface-participant
openssl pkcs12 -in $CHEMIN_REP_CERTIFICATS/server.p12 -out $CHEMIN_MONITORING_CERTIFICATS/cert-prom-participant.key -nodes -password pass:$MDP_SERVEUR_KEYSTORE_PARTICIPANT -nocerts
openssl pkcs12 -in $CHEMIN_REP_CERTIFICATS/server.p12 -out $CHEMIN_MONITORING_CERTIFICATS/cert-prom-participant.crt -password pass:$MDP_SERVEUR_KEYSTORE_PARTICIPANT -nokeys
#Clé privée et certificats utilisés par prometheus pour contacter interface-pi
openssl pkcs12 -in $CHEMIN_REP_CERTIFICATS/client-pi.p12 -out $CHEMIN_MONITORING_CERTIFICATS/cert-prom-pi.key -nodes -password pass:$MDP_CLIENT_KEYSTORE_PI -nocerts
openssl pkcs12 -in $CHEMIN_REP_CERTIFICATS/client-pi.p12 -out $CHEMIN_MONITORING_CERTIFICATS/cert-prom-pi.crt -password pass:$MDP_CLIENT_KEYSTORE_PI -nokeys
cp $BO_SUIVI_CHEMIN_SSL_CERTIFICAT $CHEMIN_MONITORING_CERTIFICATS/server.crt
cp $BO_SUIVI_CHEMIN_SSL_CLE $CHEMIN_MONITORING_CERTIFICATS/server.key
mkdir $CHEMIN_PROMETHEUS_DATA $CHEMIN_ALERTMANAGER_DATA $CHEMIN_GRAFANA_DATA $CHEMIN_KEYCLOAK_DATA $CHEMIN_ZOOKEEPER_DATA
#mkdir $CHEMIN_ZOOKEEPER_LOGS $CHEMIN_KAFKA_DATA $CHEMIN_KAFKA_SCRIPT
#Créer le répertoire "journalisation" et ses sous-répertoires
mkdir $CHEMIN_REP_JOURNALISATION
mkdir $CHEMIN_REP_JOURNALISATION/interface-participant
mkdir $CHEMIN_REP_JOURNALISATION/moteur-traitement
mkdir $CHEMIN_REP_JOURNALISATION/interface-pi

if [ -f $CHEMIN_PROMETHEUS_CONF ]
    then
        rm -f $CHEMIN_PROMETHEUS_CONF
fi
if [ -f $CHEMIN_ALERT_CONF ]
    then
        rm -f $CHEMIN_ALERT_CONF
fi

cp $CHEMIN_REP_MONITORING_REMOTE/prometheus/prometheus.template.yml $CHEMIN_PROMETHEUS_CONF
cp $CHEMIN_REP_MONITORING_REMOTE/alertmanager/alertmanager.template.yml $CHEMIN_ALERT_CONF

sed -i "s|DNS_INTERNE|$DNS_INTERNE|" $CHEMIN_PROMETHEUS_CONF
sed -i "s|ELASTICSEARCH_USER_NAME|$ELASTICSEARCH_USER_NAME|" $CHEMIN_PROMETHEUS_CONF
sed -i "s|ELASTICSEARCH_USER_PWD|$ELASTICSEARCH_USER_PWD|" $CHEMIN_PROMETHEUS_CONF
sed -i "s|PWD_MAIL_UTILISATEUR|$PWD_MAIL_UTILISATEUR|" $CHEMIN_KEYCLOAK_REALM
sed -i "s|DNS_INTERNE|$DNS_INTERNE|" $CHEMIN_KEYCLOAK_REALM
sed -i "s|DNS_INTERNE|$DNS_INTERNE|" $CHEMIN_PROMETHEUS_DS
sed -i "s|ADRESSE_MAIL_UTILISATEUR|$ADRESSE_MAIL_UTILISATEUR|" $CHEMIN_KEYCLOAK_REALM
sed -i "s|ADRESSE_SERVEUR_SMTP|$ADRESSE_SERVEUR_SMTP|" $CHEMIN_KEYCLOAK_REALM
sed -i "s|PORT_SERVEUR_SMTP|$PORT_SERVEUR_SMTP|" $CHEMIN_KEYCLOAK_REALM
sed -i "s|ADRESSE_MAIL_UTILISATEUR|$ADRESSE_MAIL_UTILISATEUR|" $CHEMIN_ALERT_CONF
sed -i "s|ADRESSE_SERVEUR_SMTP|$ADRESSE_SERVEUR_SMTP|" $CHEMIN_ALERT_CONF
sed -i "s|PORT_SERVEUR_SMTP|$PORT_SERVEUR_SMTP|" $CHEMIN_ALERT_CONF
sed -i "s|PWD_MAIL_UTILISATEUR|$PWD_MAIL_UTILISATEUR|" $CHEMIN_ALERT_CONF
sed -i "s|MAIL_GROUPE_SUPERVISION|$MAIL_GROUPE_SUPERVISION|" $CHEMIN_ALERT_CONF
sed -i "s|DNS_INTERNE|$DNS_INTERNE|" $CHEMIN_ALERT_CONF

GENERATED_PASSWORD_KEYSTORE=$(head -c 16 /dev/urandom | base64 | tr --delete /)
GENERATED_PASSWORD_TRUSTSTORE=$(head -c 16 /dev/urandom | base64 | tr --delete /)
if [ -f $CHEMIN_BO_BACKEND_KEYSTORE ]
    then
        rm -f $CHEMIN_BO_BACKEND_KEYSTORE
fi
openssl pkcs12 -export -in $BO_SUIVI_CHEMIN_SSL_CERTIFICAT -out $CHEMIN_BO_BACKEND_KEYSTORE -name server -inkey $BO_SUIVI_CHEMIN_SSL_CLE -password pass:$GENERATED_PASSWORD_KEYSTORE
echo "" >> .env
echo "BO_BACKEND_KEYSTORE_PWD=$GENERATED_PASSWORD_KEYSTORE" >> .env
if [ -f $CHEMIN_BO_BACKEND_TRUSTSTORE ]
    then
        rm -f $CHEMIN_BO_BACKEND_TRUSTSTORE
fi
keytool -import -trustcacerts -keystore $CHEMIN_BO_BACKEND_TRUSTSTORE -storepass $GENERATED_PASSWORD_TRUSTSTORE -noprompt -file $CHEMIN_CERTIFICAT_CA -alias rootCA
echo "" >> .env
echo "MDP_KEYCLOAK_TRUSTSTORE=$GENERATED_PASSWORD_TRUSTSTORE" >> .env

#Les variables d'environnement des paramétres de connexion à REDIS
echo "MDP_INTERFACEPARTICIPANT_REDIS=$MDP_INTERFACEPARTICIPANT_REDIS" >> .env
echo "MDP_MOTEURTRAITEMENT_REDIS=$MDP_MOTEURTRAITEMENT_REDIS" >> .env
echo "MDP_INTERFACEPI_REDIS=$MDP_INTERFACEPI_REDIS" >> .env
echo "MDP_POSTGRES=$MDP_POSTGRES" >> .env
source .env
sudo chown -R nobody:nobody $CHEMIN_REP_NFS_LOCAL/*
sudo chmod -R 777  $CHEMIN_REP_NFS_LOCAL/*
sudo umount -f $CHEMIN_REP_NFS_LOCAL
rm -rf $CHEMIN_REP_NFS_LOCAL
#DEBUT Remplacement des variables d'environnement dans le fichier de déploiement
sed -i "s|VERSION_AIP|$VERSION_AIP|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|NB_REPLICAS|$NB_REPLICAS|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|NB_REPLICAS|$NB_REPLICAS|" $CHEMIN_FICHIER_DEPLOIEMENT_KAFKA
sed -i "s|MDP_KAFKA_TRUSTSTORE_VALEUR|$MDP_KAFKA_TRUSTSTORE|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ZIPKIN_ECHANTILLON_VALEUR|$ZIPKIN_ECHANTILLON|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|CODE_MEMBRE_PARTICIPANT_VALEUR|$CODE_MEMBRE_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|NOM_PARTICIPANT_VALEUR|$NOM_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|NOM_PARTICIPANT_VALEUR|$NOM_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT_KAFKA
sed -i "s|TYPE_PARTICIPANT_VALEUR|$TYPE_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_MOTEURTRAITEMENT_KAFKA|$MDP_MOTEURTRAITEMENT_KAFKA|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_MOTEURTRAITEMENT_REDIS|$MDP_MOTEURTRAITEMENT_REDIS|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_INTERFACEPARTICIPANT_KAFKA|$MDP_INTERFACEPARTICIPANT_KAFKA|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_INTERFACEPARTICIPANT_REDIS|$MDP_INTERFACEPARTICIPANT_REDIS|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_INTERFACEPI_KAFKA|$MDP_INTERFACEPI_KAFKA|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_INTERFACEPI_REDIS|$MDP_INTERFACEPI_REDIS|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|GRAFANA_ADMIN|$GRAFANA_ADMIN|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|GRAFANA_PASSWORD|$GRAFANA_PASSWORD|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ELASTICSEARCH_SERVER_HOST_VALEUR|$ELASTICSEARCH_SERVER_HOST|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|IP_ELASTICSEARCH_VALEUR|$IP_ELASTICSEARCH|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ELASTICSEARCH_USER_NAME_VALEUR|$ELASTICSEARCH_USER_NAME|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ELASTICSEARCH_USER_PWD_VALEUR|$ELASTICSEARCH_USER_PWD|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ELASTICSEARCH_TRUSTSTORE_PASSWORD_VALEUR|$ELASTICSEARCH_TRUSTSTORE_PASSWORD|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_POSTGRES|$MDP_POSTGRES|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|DNS_INTERNE|$DNS_INTERNE|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|IP_INTERNE|$IP_INTERNE|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|KEYCLOACK_ADMIN_USER_VALEUR|$KEYCLOACK_ADMIN_USER|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|KEYCLOACK_ADMIN_PWD|$KEYCLOACK_ADMIN_PWD|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ADRESSE_SERVEUR_SMTP|$ADRESSE_SERVEUR_SMTP|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ADRESSE_MAIL_UTILISATEUR|$ADRESSE_MAIL_UTILISATEUR|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|PWD_MAIL_UTILISATEUR|$PWD_MAIL_UTILISATEUR|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_KEYCLOAK_TRUSTSTORE|$MDP_KEYCLOAK_TRUSTSTORE|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|BO_BACKEND_KEYSTORE_PWD_VALEUR|$BO_BACKEND_KEYSTORE_PWD|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|PAYS|$PAYS|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|PAYS|$PAYS|" $CHEMIN_FICHIER_DEPLOIEMENT_KAFKA
sed -i "s|VILLE|$VILLE|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|VILLE|$VILLE|" $CHEMIN_FICHIER_DEPLOIEMENT_KAFKA
sed -i "s|QUARTIER|$QUARTIER|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|QUARTIER|$QUARTIER|" $CHEMIN_FICHIER_DEPLOIEMENT_KAFKA
sed -i "s|MDP_CLIENT_KAFKA|$MDP_CLIENT_KAFKA|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|NFS_SERVER_IP|$NFS_SERVER_IP|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|NFS_SERVER_IP|$NFS_SERVER_IP|" $CHEMIN_FICHIER_DEPLOIEMENT_KAFKA
sed -i "s|URL_BASE_PARTICIPANT_VALEUR|$URL_BASE_PARTICIPANT_VALEUR|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_CLIENT_TRUSTSTORE_PARTICIPANT|$MDP_CLIENT_TRUSTSTORE_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_CLIENT_KEY_PARTICIPANT|$MDP_CLIENT_KEY_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_CLIENT_KEYSTORE_PARTICIPANT|$MDP_CLIENT_KEYSTORE_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|CHEMIN_FICHIER_KEYSTORE_SIGNATURE_PARTICIPANT|$CHEMIN_FICHIER_KEYSTORE_SIGNATURE_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ALIAS_CLE_SIGNATURE_PARTICIPANT|$ALIAS_CLE_SIGNATURE_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ALIAS_CERTIFICAT_SIGNATURE_PARTICIPANT|$ALIAS_CERTIFICAT_SIGNATURE_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_SIGNATURE_KEYSTORE_PARTICIPANT|$MDP_SIGNATURE_KEYSTORE_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|CHEMIN_FICHIER_CONFIG_HSM_PARTICIPANT|$CHEMIN_FICHIER_CONFIG_HSM_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|USER_PIN_HSM_PARTICIPANT|$USER_PIN_HSM_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ALIAS_CLE_PRIVEE_HSM_PARTICIPANT|$ALIAS_CLE_PRIVEE_HSM_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ALIAS_CERTIFICAT_HSM_PARTICIPANT|$ALIAS_CERTIFICAT_HSM_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_SERVEUR_KEYSTORE_PARTICIPANT|$MDP_SERVEUR_KEYSTORE_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_SERVEUR_TRUSTSTORE_PARTICIPANT|$MDP_SERVEUR_TRUSTSTORE_PARTICIPANT|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|URL_BASE_PI_VALEUR|$URL_BASE_PI_VALEUR|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|API_KEY_PI_VALEUR|$API_KEY_PI_VALEUR|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|VERSION_API_RAC_VALEUR|$VERSION_API_RAC_VALEUR|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|VERSION_API_SPI_VALEUR|$VERSION_API_SPI_VALEUR|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|PROXY_HOST_VALEUR|$PROXY_HOST_VALEUR|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|PROXY_PORT_VALEUR|$PROXY_PORT_VALEUR|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_CLIENT_TRUSTSTORE_PI|$MDP_CLIENT_TRUSTSTORE_PI|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|CHEMIN_FICHIER_CLIENT_MTLS_PI|$CHEMIN_FICHIER_CLIENT_MTLS_PI|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_CLIENT_KEY_PI|$MDP_CLIENT_KEY_PI|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_CLIENT_KEYSTORE_PI|$MDP_CLIENT_KEYSTORE_PI|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|CHEMIN_FICHIER_CONFIG_HSM_PI|$CHEMIN_FICHIER_CONFIG_HSM_PI|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|USER_PIN_HSM_PI|$USER_PIN_HSM_PI|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|ALIAS_CERTIFICAT_CLIENT_MTLS_HSM_PI|$ALIAS_CERTIFICAT_CLIENT_MTLS_HSM_PI|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_SERVEUR_KEYSTORE_PI|$MDP_SERVEUR_KEYSTORE_PI|" $CHEMIN_FICHIER_DEPLOIEMENT
sed -i "s|MDP_SERVEUR_TRUSTSTORE_PI|$MDP_SERVEUR_TRUSTSTORE_PI|" $CHEMIN_FICHIER_DEPLOIEMENT
#todo delete after
exit 0
echo "#################### DEBUT DEPLOIEMENT DE KAFKA ##########################"
docker stack deploy -c $CHEMIN_FICHIER_DEPLOIEMENT_KAFKA --detach=false --with-registry-auth aip
sleep 5m
echo "#################### FIN DEPLOIEMENT DE KAFKA ############################"
#docker stack deploy -c <(docker compose -f $CHEMIN_FICHIER_DEPLOIEMENT config) aip
echo "#################### DEBUT DEPLOIEMENT DES AUTRES COMPOSANTS ##############"
docker stack deploy -c $CHEMIN_FICHIER_DEPLOIEMENT --detach=false --with-registry-auth aip
echo "#################### FIN DEPLOIEMENT DES AUTRES COMPOSANTS ##############"
echo "En attente de la disponibilité de Kibana ..."
while ! curl -k -s -o /dev/null -w "%{http_code}" https://$DNS_INTERNE:5601/api/saved_objects/_import?overwrite=true -H "kbn-xsrf:true" -u "$ELASTICSEARCH_USER_NAME:$ELASTICSEARCH_USER_PWD"; do
    sleep 10
done
echo
echo "En attente de la disponibilité des différents services de Kibana pour importer les données sauvegardées..."
echo
sleep 3m
curl -k -X POST https://$DNS_INTERNE:5601/api/saved_objects/_import?overwrite=true -H "kbn-xsrf:true" -u "$ELASTICSEARCH_USER_NAME:$ELASTICSEARCH_USER_PWD" -F "file=@config/elasticsearch/back-office-suivi.ndjson"