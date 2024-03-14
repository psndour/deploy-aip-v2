#!/bin/bash
set -a; source .env; set +a
set -a; source function.sh; set +a


if systemctl status "$ELASTIC_SEARCH_SERVICE_NAME.service" >/dev/null 2>&1; then
    echo "$SERVICE is already installed"
    echo "uninstall before to install again"
    exit 0
else
    echo "$SERVICE does not exist"
fi

#Change config for elastic search
update_line_value "vm.max_map_count=" 262144 /etc/sysctl.conf " "
sudo sysctl -p
update_line_value "* soft nofile" 65536 /etc/security/limits.conf " "
update_line_value "* hard nofile" 65536 /etc/security/limits.conf " "
update_line_value "* soft nproc" 4096 /etc/security/limits.conf " "
update_line_value "* hard nproc" 4096 /etc/security/limits.conf " "



sudo rm -rf "$ELASTIC_PATH"
git clone "https://$GITHUB_USER_NAME:$GITHUB_PASSWORD@github.com/bceaopi/deploiement-elasticsearch.git" "$ELASTIC_PATH"
cd "$ELASTIC_PATH" || exit
cat <<EOF > elastic.env
HOSTNAME_OU_DNS="$HOSTNAME_OU_DNS"
IP_ECOUTEUR="$IP_ECOUTEUR"
ARCH_TYPE="linux"
PORT_KIBANA=$KIBANA_PORT
KIBANA_PUBLIC_DOMAIN_NAME="$KIBANA_PUBLIC_DOMAIN_NAME"
EOF
sudo adduser "$ELASTIC_USER"
chown "$ELASTIC_USER":"$ELASTIC_GROUP" -R "$ELASTIC_PATH"
sudo -u "$ELASTIC_USER" bash install_elasticsearch


#ADD SERVICE ELASTIC
# Répertoire d'Elasticsearch
DIR_ELASTICSEARCH="$ELASTIC_PATH/elasticsearch"

# Chemin vers le binaire d'Elasticsearch
ELASTIC_BIN="$DIR_ELASTICSEARCH/bin/elasticsearch"

# Nom du service Elasticsearch
ELASTIC_SEARCH_SERVICE_NAME="elasticsearch"

# Créer le fichier de service pour systemd
sudo tee /etc/systemd/system/$ELASTIC_SEARCH_SERVICE_NAME.service <<EOF
[Unit]
Description=Elasticsearch Service
Documentation=https://www.elastic.co
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=$ELASTIC_BIN
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
User=$ELASTIC_USER
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

# Recharger les services systemd
sudo systemctl daemon-reload
# Activer le service Elasticsearch au démarrage
sudo systemctl enable $ELASTIC_SEARCH_SERVICE_NAME
# Démarrer le service Elasticsearch
sudo systemctl start $ELASTIC_SEARCH_SERVICE_NAME
sudo systemctl status $ELASTIC_SEARCH_SERVICE_NAME

while ! curl -k -s -o /dev/null -w "\nELASTIC WAITING STARTING ...." "https://$IP_ECOUTEUR:9200" -H "kbn-xsrf:true" -u "$ELASTICSEARCH_USER_NAME:$ELASTICSEARCH_USER_PWD"; do
    sleep 5
done

# shellcheck disable=SC2028
echo -e "\nFINISH TO DEPLOY ELASTIC"
echo "=========================ELASTIC SEARCH COMMAND================================="
echo "To start :  sudo systemctl start $ELASTIC_SEARCH_SERVICE_NAME"
echo "To check status :  sudo systemctl status $ELASTIC_SEARCH_SERVICE_NAME"
echo "To stop  :  sudo systemctl stop $ELASTIC_SEARCH_SERVICE_NAME"
echo "=========================ELASTIC SEARCH COMMAND================================="
