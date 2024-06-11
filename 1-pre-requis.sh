#!/bin/bash
set -a; source .env; set +a
sudo yum update -y
sudo yum install -y vim python net-tools telnet nmap git wget tar unzip curl openssl
sudo wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm
sudo yum -y install ./jdk-17_linux-x64_bin.rpm

sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

sudo yum install -y yum-utils vim git net-tools
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo yum install -y python

#timezone
sudo yum install -y ntp
sudo systemctl start ntpd
sudo systemctl enable ntpd
sudo timedatectl set-timezone Africa/Dakar
sudo systemctl enable systemd-timedated
sudo systemctl start systemd-timedated
date

#FILREWALL
# Install firewalld
sudo yum install -y firewalld
# Start the firewalld service
sudo systemctl start firewalld
# Enable firewalld to start on boot
sudo systemctl enable firewalld

#DOMAIN
#ADD HOST

#sudo echo "10.0.96.2 sandbox-kafka.free.sn" | sudo tee -a /etc/hosts
#sudo echo "10.0.96.2 sandbox-aip-elastic.free.sn" | sudo tee -a /etc/hosts
#sudo echo "10.0.96.2 sandbox-aip.free.sn" | sudo tee -a /etc/hosts
#sudo echo "10.0.96.2 sandbox-backend.free.sn" | sudo tee -a /etc/hosts

if [ "$NODE_HAS_MANAGER" -eq 1 ]; then
    echo "MANAGER"
   # Run the docker swarm init command and capture the token
   SWARM_TOKEN=$(docker swarm init --advertise-addr "$IP_MANAGER" 2>&1)
   SWARM_TOKEN=" TO JOIN RUN COMMAND :  $(echo "$SWARM_TOKEN" | grep -o '.*--token.*')"
   echo "$SWARM_TOKEN" > "$MANAGER_TOKEN_PATH"
   echo "Swarm token saved to $MANAGER_TOKEN_PATH"
else
    echo "WORKER"
fi

sudo yum install -y iptables-services
sudo service docker stop
sudo iptables -t nat -F
sudo service docker start