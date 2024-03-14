#!/usr/bin/env bash
set -a; source .env; set +a
CHEMIN_REP_NFS_LOCAL=./aip
CHEMIN_REP_NFS_REMOTE=/aip
CHEMIN_FICHIER_DEPLOIEMENT=deploiement-swarm.yml

if [ $TYPE_DEPLOIEMENT = 'SWARM' ]
    then
        echo
        echo "Suppression des fichiers de paramétrage sur le serveur NFS... "
        echo
        mkdir $CHEMIN_REP_NFS_LOCAL
        sudo mount -t nfs $NFS_SERVER_IP:$CHEMIN_REP_NFS_REMOTE $CHEMIN_REP_NFS_LOCAL
        sudo rm -rf $CHEMIN_REP_NFS_LOCAL/*
        sudo umount -f $CHEMIN_REP_NFS_LOCAL
        rm -rf $CHEMIN_REP_NFS_LOCAL
        echo
        echo "Fichiers de paramétrage supprimés avec succés"
        echo
        echo "Suppression des conteneurs ..."
        echo
        docker stack rm aip
        docker stack rm aip_kafka
        rm -rf $CHEMIN_FICHIER_DEPLOIEMENT
    else
        sudo rm -f ./monitoring/prometheus.yml
        sudo rm -f ./monitoring/alertmanager.yml
        echo "Suppression des conteneurs ..."
        echo
        docker-compose -f deploiement-compose.yml down
        docker image rm bceao/moteur-traitement:$VERSION_AIP
        docker image rm bceao/interface-participant:$VERSION_AIP
        docker image rm bceao/aip-bo-backend:$VERSION_AIP
        docker image rm bceao/aip-bo-suivi:$VERSION_AIP
        docker image rm bceao/interface-pisfn:$VERSION_AIP

fi


sed -i '/BO_BACKEND_KEYSTORE_PWD/d' .env
sed -i '/MDP_KEYCLOAK_TRUSTSTORE/d' .env
sed -i '/MDP_INTERFACEPARTICIPANT_REDIS/d' .env
sed -i '/MDP_MOTEURTRAITEMENT_REDIS/d' .env
sed -i '/MDP_INTERFACEPI_REDIS/d' .env
sed -i '/MDP_POSTGRES/d' .env
sed -i '/MDP_KAFKA_TRUSTSTORE/d' .env
sed -i '/MDP_CLIENT_KAFKA/d' .env
sed -i '/MDP_INTERFACEPARTICIPANT_KAFKA/d' .env
sed -i '/MDP_INTERFACEPI_KAFKA/d' .env
sed -i '/MDP_MOTEURTRAITEMENT_KAFKA/d' .env
sed -i '/LOGSTASH_EXPORTER_IMG/d' .env
echo
echo "Conteneurs supprimés avec succés"
echo

rm -rf config/kafka/*