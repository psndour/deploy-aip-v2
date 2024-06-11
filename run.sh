#!/bin/bash
set -a; source .env; set +a
set -a; source function.sh; set +a
echo "===========================START INSTALLATION======================="
#STEP
cd "$DEPLOY_PATH" || exit
bash 1-pre-requis-lite.sh
cd "$DEPLOY_PATH" || exit
bash 07-port.sh
cd "$DEPLOY_PATH" || exit
bash 02-deploy-elastic.sh
cd "$DEPLOY_PATH" || exit
bash  04-download-aip.sh
cd "$DEPLOY_PATH" || exitls

bash 05-generate-cert.sh
cd "$DEPLOY_PATH" || exit
bash 06-nfs.sh
cd "$DEPLOY_PATH" || exit

bash 08-init-env-aip.sh
cd "$DEPLOY_PATH" || exit
bash 09-auto-config.sh
echo "===========================FINISH INSTALLATION======================="
echo "===========================RUNNING AIP======================="
cd "$DEPLOY_PATH" || exit
bash bootstrap.sh
echo "===========================END RUNNING AIP======================="