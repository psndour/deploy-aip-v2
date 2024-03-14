#!/bin/bash
ROOT_PATH="/deploiement-outils-docker"
DOCKER_FILE="deploiement-swarm.yml"
NAME="aip"
set -a; source "$ROOT_PATH/.env"; set +a
case "$1" in
  start)
    docker stack deploy --with-registry-auth -c "$ROOT_PATH/$DOCKER_FILE" $NAME
    ;;
  restart)
    sleep 5
    docker stack deploy --with-registry-auth -c "$ROOT_PATH/$DOCKER_FILE" $NAME
    ;;
  status)
    docker stack services $NAME
    #docker stack ps $NAME
    ;;
  log)
    docker  service logs -f --tail=1 $2
    ;;
  delete)
    docker stack rm $NAME
    ;;
  *)
    echo "Usage: $0 {start|restart|stop|delete}"
    exit 1
    ;;
esac

exit 0

