
# Deployment AIP plateform on FREE infrasturture

The AIP is the interfacing platform for BCEAO.
To install it on your infrastructure, want to respect 3 steps:

## 1. Step One download the script from GitHub

```
sudo -s
sudo yum install -y git 
git clone https://github.com/psndour/deploy-aip-v2 /deploy-aip-v2
cd /deploy-aip-v2
cp /certificats/.env /deploy-aip-v2/.env
set -a; source .env; set +a
set -a; source function.sh; set +a 
bash run.sh
```

## 2. Step Two set .env
```angular2html
touch .env
```
### Edit file to adapt on you env
```
NODE_HAS_MANAGER=1
MANAGER_TOKEN_PATH=/token-password.txt
GITHUB_USER_NAME=SNC003
GITHUB_PASSWORD=
AIP_PATH=/deploiement-outils-docker
CERTS_PATH=/gestion-certificats
IP_MANAGER=10.0.96.2
DEPLOY_PATH=/deploy-aip-v2
################ELASTIC VALUE################
ELASTIC_SEARCH_SERVICE_NAME=elasticsearch
ELASTIC_USER=aipbceao
ELASTIC_GROUP=aipbceao
ELASTIC_PATH=/deploiement_elasticsearch
IP_ECOUTEUR=10.0.96.2
KIBANA_PORT=5601
KIBANA_PUBLIC_DOMAIN_NAME=sandbox-kafka.free.sn
HOSTNAME_OU_DNS=sandbox-aip-elastic.free.sn
################ELASTIC VALUE################
PAYS=SN
VILLE=DAKAR
QUARTIER=ALMADIES
NOM_ENTREPRISE="MOBILE CASH SA"
HOSTNAME_OR_DOMAIN_NAME_BACKEND_PARTICIPANT=sandbox-backend.free.sn
HOSTNAME_OR_DOMAIN_NAME_AIP=sandbox-aip.free.sn
TAILLE_CLE_PRIVEE=2048
CODE_MEMBRE=SNC003
MDP_CLE_PRIVEE_SIGNATURE=
MDP_CLE_PRIVEE_MTL=
PATH_CERT_ON_HOST=/certificats
#AIP CONFIG
IP_MASTER=10.0.96.2
NB_REPLICAS=1
VERSION_AIP=
NFS_SERVER_IP=10.0.96.2
ADMIN_USER=
ADMIN_PASSWORD=
DOCKER_HUB_TOKEN=
ADRESSE_SERVEUR_SMTP=
PORT_SERVEUR_SMTP=25
ADRESSE_MAIL_UTILISATEUR=aip-free@free.sn
PWD_MAIL_UTILISATEUR=
MAIL_GROUPE_SUPERVISION=papa-samba.ndour@free-partenaires.sn
TYPE_PARTICIPANT=F
URL_BASE_PARTICIPANT_VALEUR=https://10.0.96.2:8444
URL_BASE_PI_VALEUR=https://sandbox.api.pi-bceao.com
API_KEY_PI_VALEUR=
VERSION_API_RAC_VALEUR=v1
VERSION_API_SPI_VALEUR=v1
```

## 3. Step two copy your certificat and deployment directory
* Configure PI cert on your server for signature
```
source .env
sudo mkdir -p /certificats/signature
#Certificat CA chainé fournit pas PI BCEAO qui a signé la clée publique utilisé d-desous 
vi /certificats/signature/chain.pem
#Certifucat privé generer par free
vi /certificats/signature/$CODE_MEMBRE.key
#Certficat public generer par Free et signé PI CERT
vi /certificats/signature/$CODE_MEMBRE.pem
```

* Configure PI cert on your server for mTLS
```
sudo mkdir -p /certificats/mtls
#Certificat CA chainé fournit pas PI BCEAO qui a signé la clée publique utilisé d-desous 
vi /certificats/mtls/chain.pem
#Certifucat privé generer par free
vi /certificats/mtls/$CODE_MEMBRE.key
#Certficat public generer par Free et signé PI CERT
vi /certificats/mtls/$CODE_MEMBRE.pem
#????
#touch /certificats/mtls/pi.pem
```
* Configure PI cert on your server for public certs
```
sudo mkdir -p /certificats/public-free
#Certificat CA chainé fournit par Digicert pour *.free.sn 
vi /certificats/public-free/chain.pem
#Certifucat privé generer par free
vi /certificats/public-free/$CODE_MEMBRE.key
#Certficat public generer par Free et signé PI CERT
vi /certificats/public-free/$CODE_MEMBRE.pem
#????
#touch /certificats/mtls/pi.pem
```
## 4. Installation script one by one

### 1. Install pre-requis

```angular2html
bash 1-pre-requis.sh 
```

### 2. Deploy elastic 

```angular2html
bash 02-deploy-elastic.sh 
```

### 3. download aip

```angular2html
bash  04-download-aip.sh 
```

### 4. generate cert 

```angular2html
bash 05-generate-cert.sh
```

### 5. Config Nfs server  

```angular2html
bash 06-nfs.sh
```

### 6. Open used port

```angular2html
bash 07-port.sh
```

### 7. Generate env API

```angular2html
bash 08-init-env-aip.sh
```

### 8. Set cert password

```angular2html
bash 09-auto-config.sh
```

### 8. Run aip 

```angular2html
bash  bootstrap.sh
```


## 5. Installation AIP all in one

```angular2html
bash run.sh
```



