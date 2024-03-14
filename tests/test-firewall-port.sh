#!/bin/bash

# Liste des ports à tester
ports=(443 8090 9093 9113 9114 3000 8081 8083 9092 9308 8443 5601 5044 9198 9090 6379 9122 9411 2181)

# Adresse IP du serveur
ip="10.0.96.2"

# Fonction pour tester la disponibilité d'un port avec firewall-cmd
test_port() {
    local ip=$1
    local port=$2
    echo -n "Testing $ip:$port..."

    # Utilisation de firewall-cmd pour vérifier si le port est ouvert
    if firewall-cmd --query-port="$port"/tcp --quiet; then
        echo "Open"
    else
        echo "Closed"
    fi
}

# Boucle pour tester chaque port
for port in "${ports[@]}"; do
    test_port "$ip" "$port"
done

sudo firewall-cmd --list-ports
