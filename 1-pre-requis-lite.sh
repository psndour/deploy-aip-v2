#!/bin/bash
set -a; source .env; set +a
sudo yum update -y

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

