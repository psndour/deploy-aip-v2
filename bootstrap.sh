#!/bin/bash
set -a; source .env; set +a
set -a; source function.sh; set +a

cd "$AIP_PATH" || exit
#installer-swarm.sh
echo "===========================UPDATE SWARM SCRIPT DEPLOY======================="
#last delete fixed by BCEAO
#rm -rf "$AIP_PATH/installer-swarm.sh"
#rm -rf "$AIP_PATH/desinstaller.sh"
#rm -rf "$AIP_PATH/kafka.yml"
#rm -rf "$AIP_PATH/deploiement-swarm-tpl.yml"
##last delete fixed by BCEAO
#cp "$DEPLOY_PATH/update-aip/installer-swarm-v4.sh" "$AIP_PATH/installer-swarm.sh"
#cp "$DEPLOY_PATH/update-aip/installer-swarm.sh" "$AIP_PATH/installer-swarm.sh"
#cp "$DEPLOY_PATH/update-aip/installer-swarm-2.sh" "$AIP_PATH/installer-swarm.sh"
#cp "$DEPLOY_PATH/update-aip/desinstaller.sh" "$AIP_PATH/desinstaller.sh"
#cp "$DEPLOY_PATH/update-aip/kafka.yml" "$AIP_PATH/kafka.yml"
#todo remove on prod
#cp "$DEPLOY_PATH/update-aip/deploiement-swarm-tpl.yml" "$AIP_PATH/deploiement-swarm-tpl.yml"
#cp "$DEPLOY_PATH/update-aip/deploiement-swarm-tpl-local.yml" "$AIP_PATH/deploiement-swarm-tpl.yml"
bash "$AIP_PATH/installer.sh"