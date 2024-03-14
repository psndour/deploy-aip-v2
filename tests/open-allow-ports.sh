#!/bin/bash

# Liste des ports à ouvrir
ports=(443 8090 9093 9113 9114 3000 8081 8083 9092 9308 8443 5601 5044 9198 9090 6379 9122 9411 2181)

# Fonction pour ouvrir un port avec firewall-cmd
open_port() {
    local port=$1
    echo "Opening port $port..."

    # Utilisation de firewall-cmd pour ouvrir le port
    firewall-cmd --permanent --add-port="$port"/tcp
    firewall-cmd --reload
}

# Boucle pour ouvrir chaque port
for port in "${ports[@]}"; do
    open_port "$port"
done

echo "Ports opened successfully."
