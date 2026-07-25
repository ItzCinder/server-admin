#!/bin/bash

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    echo "==============================================="
    echo "      LISTA DE GRUPOS DEL SERVIDOR             "
    echo "      (Incluyendo los del sistema)             "
    echo "==============================================="
    # Mostrar grupos
    cut -d: -f1 /etc/group
    echo "==============================================="
    exit 0
done