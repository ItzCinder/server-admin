#!/bin/bash

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    echo "==============================================="
    echo "      LISTA DE USUARIOS DEL SERVIDOR           "
    echo "      (Incluyendo los del sistema)             "
    echo "==============================================="
    # Mostrar todos los usuarios
    awk -F: '$3 >= 1000 && $3 < 60000 {print "Usuario: " $1 " (UID: " $3 ")"}' /etc/passwd
    echo "==============================================="
    exit 0
done