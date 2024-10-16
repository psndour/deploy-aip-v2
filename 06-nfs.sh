#!/bin/zsh
set -a; source .env; set +a
set -a; source function.sh; set +a
echo "==================CREATION DU DISK NFS=========================="
sudo yum install -y  nfs-utils
mkdir -p /aip
chmod -R 777 /aip
update_line_value "/aip" " *(rw,sync,no_root_squash)" /etc/exports " "
sudo systemctl restart nfs
sudo exportfs -arv
sudo exportfs -ra
 sudo systemctl enable nfs-server

#docker swarm join --token SWMTKN-1-375500ahmsqqr5kvnobij1r4h69nhhwb9ur4nks3y1opkxfted-dapt0xsd0252z2222zv07dclu 10.0.96.2:2377

#sudo mount -t nfs 10.0.96.2:/aip /test
#sudo mount -t nfs 172.16.26.3:/aip /test
#sudo umount /test
#sudo grep -i nfs /var/log/messages
#sudo grep -i nfs /var/log/secure