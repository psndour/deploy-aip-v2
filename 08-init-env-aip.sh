#!/bin/bash
set -a; source .env; set +a
set -a; source function.sh; set +a
cat <<EOF > "$AIP_PATH/.env"
#Le type de déploiement Docker.
#Valeurs possibles: COMPOSE ou SWARM
TYPE_DEPLOIEMENT=SWARM
# Le pays dans lequel se trouve le site du participant.
PAYS="$PAYS"
# La ville où se trouve le site du participant.
VILLE=$VILLE
# Le quartier dans lequel se trouve le participant.
QUARTIER=$QUARTIER
#Le nombre de répliques déployées dans le cluster pour chaque composant.
NB_REPLICAS=$NB_REPLICAS
# La version des images Docker des services métiers de l’AIP.
VERSION_AIP=$VERSION_AIP
# Le nom de domaine du serveur qui héberge Elasticsearch.
ELASTICSEARCH_SERVER_HOST=$HOSTNAME_OU_DNS
# L’adresse IP du serveur qui héberge Elasticsearch.
IP_ELASTICSEARCH=$IP_ECOUTEUR
# Le pourcentage de traces récupérées par Zipkin. Par exemple, si le pourcentage est configuré à 10, sur 100 messages traités par l’AIP seules 10 traces sont récupérées.
ZIPKIN_ECHANTILLON=10
# L’adresse IP du serveur NFS mis en place pour le partage de fichier
NFS_SERVER_IP=$NFS_SERVER_IP
# Le nom de domaine en interne du noeud manager ou du serveur de Docker Compose
DNS_INTERNE=$HOSTNAME_OR_DOMAIN_NAME_AIP
# adresse IP en interne du noeud manager ou du serveur de Docker Compose
IP_INTERNE=$IP_MASTER
# Le nom d’utilisateur donné à l’administrateur de GRAFANA.
GRAFANA_ADMIN=$ADMIN_USER
# Le mot de passe de l’administrateur de GRAFANA.
GRAFANA_PASSWORD=$ADMIN_PASSWORD
# Le nom d’utilisateur donné à l’administrateur de KEYCLOAK
KEYCLOACK_ADMIN_USER=$ADMIN_USER
# Le mot de passe de l’administrateur de KEYCLOAK.
KEYCLOACK_ADMIN_PWD=$ADMIN_PASSWORD
# Le mot de passe du truststore (elastic-certificates.p12) généré lors du déploiement d’Elasticsearch.
#G Cette information peut être récupérée depuis le fichier credentials.txt généré dans le dossier de déploiement d’Elasticsearch.
ELASTICSEARCH_TRUSTSTORE_PASSWORD=
#G Nom de l’utilisateur Elasticsearch pour les opérations de l’AIP.
ELASTICSEARCH_USER_NAME=
#G Mot de passe de l’utilisateur Elasticsearch pour les opérations de l’AIP.
ELASTICSEARCH_USER_PWD=
# Le certificat utilisé pour la sécurisation par TLS des interfaces WEB de l’AIP.
# Format: ./certificats/[nom_fichier certificat]
BO_SUIVI_CHEMIN_SSL_CERTIFICAT=./certificats/server-aip.pem
# La clé privée utilisée pour la sécurisation par TLS  des interfaces WEB de l’AIP.
# Format: ./certificats/[nom_fichier cle]
BO_SUIVI_CHEMIN_SSL_CLE=./certificats/server-aip.key
# Chemin vers le certificat de l’autorité de certification qui a délivré les certificat.
# Format: ./certificats/[nom_fichier_certificat_ca]
CHEMIN_CERTIFICAT_CA=./certificats/rootCA.pem
# Le token fourni au participant pour la récupération des images depuis Docker Hub.
DOCKER_HUB_TOKEN=$DOCKER_HUB_TOKEN
# Le serveur SMTP utilisé par l’AIP pour les notifications aux utilisateurs.
ADRESSE_SERVEUR_SMTP=$ADRESSE_SERVEUR_SMTP
# Le port du serveur SMTP utilisé par l’AIP pour les notifications aux utilisateurs.
PORT_SERVEUR_SMTP=$PORT_SERVEUR_SMTP
# Adresse e-mail attribuée à l’AIP pour les notifications aux utilisateurs.
ADRESSE_MAIL_UTILISATEUR=$ADRESSE_MAIL_UTILISATEUR
# Mot de passe de l’adresse mail attribuée à l’AIP pour les notifications aux utilisateurs.
PWD_MAIL_UTILISATEUR=$PWD_MAIL_UTILISATEUR
# L’e-mail de groupe utilisé par le système d’alerte du serveur de monitoring pour envoyer des notifications lorsqu’un composant tombe en panne.
MAIL_GROUPE_SUPERVISION=$MAIL_GROUPE_SUPERVISION
# Le code membre du participant  qui est attribué par la plateforme interopérable.
CODE_MEMBRE_PARTICIPANT="$CODE_MEMBRE"
# Le nom du participant sur la plateforme interopérable. C’est le nom par lequel le participant est connu PI.
#Format "NOM PARTICIPANT"
NOM_PARTICIPANT="$NOM_ENTREPRISE"
# Le type du participant. (B,F,C,D ou E)
TYPE_PARTICIPANT=$TYPE_PARTICIPANT
# URL de base des APIS exposées par le participant.
URL_BASE_PARTICIPANT_VALEUR=$URL_BASE_PARTICIPANT_VALEUR
#G Cette propriété permet de renseigner le mot de passe du truststore dans la communication par mTLS avec le backend du participant..
MDP_CLIENT_TRUSTSTORE_PARTICIPANT=
# Cette propriété permet de renseigner le mot de passe, s'il y'en a,  de la clé privée utilisée dans la communication par mTLS avec le backend du participant.
#La laisser vide si la clé privée n'est pas protégée par un mot de passe.
MDP_CLIENT_KEY_PARTICIPANT=
#G Elle permet de renseigner le mot de passe du Keystore utilisé dans la communication par mTLS avec le backend du participant.
MDP_CLIENT_KEYSTORE_PARTICIPANT=
# Propriété optionnelle utilisée pour renseigner le chemin vers le keystore qui contient la clé devant être utilisée  par l’AIP pour signer les messages XML et JSON.
# valeur: /certificats/[nom_fichier_keystore]
CHEMIN_FICHIER_KEYSTORE_SIGNATURE_PARTICIPANT="/certificats/$CODE_MEMBRE.p12"
# Propriété optionnelle utilisée pour renseigner l’alias de la clé privée de signature.
ALIAS_CLE_SIGNATURE_PARTICIPANT="${CODE_MEMBRE}_KEY"
# Propriété optionnelle utilisée pour renseigner l’alias du certificat lié à la clé privée de signature.
ALIAS_CERTIFICAT_SIGNATURE_PARTICIPANT="${CODE_MEMBRE}_CERT"
#G Propriété optionnelle utilisée pour renseigner le mot de passe du keystore de signature
MDP_SIGNATURE_KEYSTORE_PARTICIPANT=
# Propriété optionnelle utilisée pour renseigner le chemin du fichier de configuration du fournisseur SUNPKCS11.
# Format: /config/[nom_fichier_config]
CHEMIN_FICHIER_CONFIG_HSM_PARTICIPANT=
# Propriété optionnelle utilisée pour renseigner le mot de passe utilisé pour accéder au HSM
USER_PIN_HSM_PARTICIPANT=
# Propriété optionnelle utilisée pour renseigner l’alias de la clé privée de signatue stockée dans le HSM
ALIAS_CLE_PRIVEE_HSM_PARTICIPANT=
# Propriété optionnelle utilisée pour renseigner l’alias du certificat lié à la clé privée de signature dans le HSM
ALIAS_CERTIFICAT_HSM_PARTICIPANT=
#G Propriété utilisée également dans dans le cadre de la sécurisation par TLS des APIS de l’AIP. Elle permet de renseigner le mot de passe du keystore du serveur.
MDP_SERVEUR_KEYSTORE_PARTICIPANT=
#G Propriété optionnelle utilisée dans dans le cadre de la sécurisation par mTLS des APIS de l’AIP. Elle permet de renseigner le mot de passe du truststore.
MDP_SERVEUR_TRUSTSTORE_PARTICIPANT=
# URL de base des APIS de la plateforme interopérable.
URL_BASE_PI_VALEUR=$URL_BASE_PI_VALEUR
#Client TLS
# La clé d’API fournie au participant par PI
API_KEY_PI_VALEUR=$API_KEY_PI_VALEUR
# La version de l'API RAC utilisée
VERSION_API_RAC_VALEUR=$VERSION_API_RAC_VALEUR
# La version de l'API SPI utilisée
VERSION_API_SPI_VALEUR=$VERSION_API_SPI_VALEUR
# Propriété optionnelle qui permet de spécifier  l’adresse IP du proxy utilisé pour appeler PI. Elle n'est pas renseignée lorsqu’un serveur Proxy n’est pas utilisé.
PROXY_HOST_VALEUR=
#Propriété optionnelle qui permet de spécifier le port du proxy utilisé pour appeler PI.
#Elle n'est pas renseignée lorsqu’un serveur Proxy n’est pas utilisé.
PROXY_PORT_VALEUR=
#Propriété optionnelle qui permet de renseigner l’emplacement du fichier keystore utilisé lorsque l’AIP contacte l’API de PI.
# Format: file:/certificats/[nom_fichier_keystore]
CHEMIN_FICHIER_CLIENT_MTLS_PI=file:/certificats/client-pi.p12
# Propriété optionnelle qui permet de renseigner le mot de passe de la clé privée utilisée lorsque l’AIP contacte l’API de PI.
# La laisser vide si la clé privée n'est pas protégée par un mot de passe
MDP_CLIENT_KEY_PI="$MDP_CLE_PRIVEE_MTL"
#G Propriété optionnelle qui  permet de renseigner le mot de passe du fichier keystore utilisé lorsque l’AIP contacte l’API de PI.
MDP_CLIENT_KEYSTORE_PI=
#Propriété optionnelle utilisée pour renseigner le chemin du fichier de configuration du fournisseur SUNPKCS11.
# Format: /config/[nom_fichier_config]
CHEMIN_FICHIER_CONFIG_HSM_PI=
# Propriété optionnelle utilisée pour renseigner le mot de passe utilisé pour accéder au HSM.
USER_PIN_HSM_PI=
# Propriété optionnelle utilisée pour renseigner l’alias de la clé privée stockée dans le HSM
ALIAS_CERTIFICAT_CLIENT_MTLS_HSM_PI=
#G Propriété utilisée également dans dans le cadre de la sécurisation par TLS. Elle permet de renseigner le mot de passe du keystore.
MDP_SERVEUR_KEYSTORE_PI=
#G Propriété optionnelle utilisée dans dans le cadre de la sécurisation par mTLS dans la communication avec PI . Elle permet de renseigner le mot de passe du truststore
MDP_SERVEUR_TRUSTSTORE_PI=
MDP_CLIENT_TRUSTSTORE_PI=
EOF