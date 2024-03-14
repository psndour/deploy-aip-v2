#!/bin/zsh
set -a; source .env; set +a
set -a; source function.sh; set +a
echo "==================CREATION DU DISK NFS=========================="
sudo yum install -y  nfs-utils
mkdir -p /aip
chmod -R 777 /aip
update_line_value "/aip" " *(rw,sync,no_root_squash)" /etc/exports " "
sudo systemctl restart nfs


