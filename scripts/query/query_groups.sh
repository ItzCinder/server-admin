#!/bin/bash

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    echo "==============================================="
    echo "      LISTA DE GRUPOS DEL SERVIDOR             "
    echo "==============================================="
    # Mostrar grupos
    awk -F: '$3 >= 1000 && $3 < 60000 { gsub(/,/, " ", $4); print "Grupo: " $1 " (GID: " $3 ") - Miembros: " $4 }' /etc/group || || echo "Hubo un error en la ejecución del comando"
    echo "==============================================="
    exit 0
done