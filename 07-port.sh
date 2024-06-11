#!/bin/bash


#SWARM
#Port de communication du manager (TCP/2377)
sudo firewall-cmd  --add-port=2377/tcp --permanent
#Port de découverte de travailleurs (TCP/7946)
sudo firewall-cmd --add-port=7946/tcp --permanent
#Port de découverte de travailleurs (UDP/7946)
sudo firewall-cmd  --add-port=7946/udp --permanent
#Ports d'échange de données du cluster (TCP/4789)
sudo firewall-cmd  --add-port=4789/tcp --permanent
sudo firewall-cmd  --add-port=4789/udp --permanent

# keycloak
sudo firewall-cmd --add-port=8443/tcp --permanent

# aip-backoffice
sudo firewall-cmd --add-port=443/tcp --permanent

# aip-bo-backend
sudo firewall-cmd --add-port=8090/tcp --permanent

# kibana
sudo firewall-cmd --add-port=5601/tcp --permanent

# elasticsearch
sudo firewall-cmd --add-port=9200/tcp --permanent

# logstash
sudo firewall-cmd --add-port=5044/tcp --permanent
sudo firewall-cmd --add-port=9600/tcp --permanent

# prometheus
sudo firewall-cmd --add-port=9090/tcp --permanent

# alertmanager
sudo firewall-cmd --add-port=9093/tcp --permanent

# grafana
sudo firewall-cmd --add-port=3000/tcp --permanent

# interface-participant
sudo firewall-cmd --add-port=8081/tcp --permanent

# moteur-traitement
sudo firewall-cmd --add-port=8082/tcp --permanent

# redis-mz
sudo firewall-cmd --add-port=6379/tcp --permanent

# gatewayserver-mz
sudo firewall-cmd --add-port=8172/tcp --permanent

# configserver-mz
sudo firewall-cmd --add-port=8171/tcp --permanent

# eurekaserver-mz
sudo firewall-cmd --add-port=8170/tcp --permanent
#BACKEND FREE
sudo firewall-cmd --add-port=8444/tcp --permanent

#NFS
sudo firewall-cmd --permanent  --add-service=nfs
sudo firewall-cmd --permanent  --add-service=mountd
sudo firewall-cmd --permanent  --add-service=rpc-bind
sudo firewall-cmd --reload

# Reload firewall to apply changes


#New port
#9200-8444-8445-8446-8447
sudo firewall-cmd --add-port=8444/tcp --permanent
sudo firewall-cmd --add-port=8445/tcp --permanent
sudo firewall-cmd --add-port=8446/tcp --permanent
sudo firewall-cmd --add-port=8447/tcp --permanent
#SERVER_PORT
sudo firewall-cmd --reload
##TEST
#sudo firewall-cmd --list-ports
#docker rm my-nginx  -f
#docker run --name my-nginx -p 8444:80 -d nginx
#docker run --name my-nginx -p 8445:80 -d nginx
#docker run --name my-nginx -p 8446:80 -d nginx
#docker run --name my-nginx -p 8447:80 -d nginx
#
#sudo lsof -i :8444 -t | xargs -r kill -SIGTERM
