#!/bin/bash

# Liste des ports à tester
ports=(443 8090 9093 9113 9114 3000 8081 8083 9092 9308 8443 5601 5044 9198 6379 9122 9411 2181)

# Adresse IP à tester
ip="10.0.96.2"

# Fonction pour effectuer le test de connectivité
test_connectivity() {
    local ip=$1
    local port=$2
    echo -n "Testing $ip:$port..."
    if nmap -p "$port" "$ip" | grep -q open; then
        echo "Success"
    else
        echo "Failed"
    fi
    return 0
}

# Boucle pour tester la connectivité sur chaque port
for port in "${ports[@]}"; do
    test_connectivity "$ip" "$port"
done
