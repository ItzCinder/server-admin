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
    awk -F: '{print "Grupo: " $1 " (GID: " $3 ") - Miembros: " $4}' /etc/group || echo "Hubo un error en la ejecución del comando" 
    echo "==============================================="
    exit 0
done