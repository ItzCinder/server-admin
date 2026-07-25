#!/bin/bash

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    echo "==============================================="
    echo "      LISTA DE USUARIOS DEL SERVIDOR           "
    echo "==============================================="
    # Mostrar usuarios sin incluir los del sistema
    awk -F: '{print "Usuario: " $1 " (UID: " $3 ")"}' /etc/passwd || echo "Hubo un error en la ejecución del comando"
    echo "==============================================="
    exit 0
done