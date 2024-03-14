#!/bin/bash


echo "start"
 name="$1"
 date="$2"

if [ -z "$date" ]; then
    date=$(date -d '1 minute ago' '+%Y-%m-%dT%H:%M:%S')
fi

docker logs -f $(docker ps --quiet --filter "name=$name") --since="$date"

#docker logs $(docker ps --quiet --filter "name=aip_interface-participant.*") --since="2024-02-12T13:00:00"

#aip_log  aip_interface-participant*
#aip_log  aip_interface-pi*
#aip_log  aip_moteur-traitement*

