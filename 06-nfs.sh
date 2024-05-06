#!/bin/zsh
set -a; source .env; set +a
set -a; source function.sh; set +a
echo "==================CREATION DU DISK NFS=========================="
sudo yum install -y  nfs-utils
mkdir -p /aip
chmod -R 777 /aip
update_line_value "/aip" " *(rw,sync,no_root_squash)" /etc/exports " "
sudo systemctl restart nfs
# docker swarm join --token SWMTKN-1-375500ahmsqqr5kvnobij1r4h69nhhwb9ur4nks3y1opkxfted-dapt0xsd0252z2222zv07dclu 10.0.96.2:2377


