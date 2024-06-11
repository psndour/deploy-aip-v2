#!/bin/bash
sudo docker rm -f $(sudo docker ps -a -q)
sudo docker rmi -f $(sudo docker images -q)
sudo docker volume rm -f $(sudo docker volume ls -q)
sudo docker network rm -f $(sudo docker network ls -q)

sudo yum remove -y docker-engine docker docker.io docker-ce docker-ce-cli containerd runc
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
sudo rm /etc/yum.repos.d/docker*.repo
sudo yum clean all

#docker stack deploy -c deploiement-swarm.yml  --with-registry-auth aip
#docker stack deploy -c kafka.yml  --with-registry-auth aip