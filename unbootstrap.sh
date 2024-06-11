#!/bin/bash
set -a; source .env; set +a
set -a; source function.sh; set +a
cd "$AIP_PATH"  || exit
bash "$AIP_PATH/desinstaller.sh"
cd "$DEPLOY_PATH" || exit
sudo bash uninstall-certs.sh
#sudo bash 03-uninstall-elastic.sh
sudo rm -rf "$AIP_PATH"
sudo rm -rf "$ELASTIC_PATH"
sudo rm -rf "$CERTS_PATH"
cd / || exit
sudo rm -rf "/token-password.txt"
sudo rm -rf "$DEPLOY_PATH"
sudo docker swarm leave -f
sudo docker container prune -f
sudo docker image prune -f
sudo systemctl restart docker