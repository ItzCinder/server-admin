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
    cut -d: -f1 /etc/passwd || echo "Hubo un error en la ejecución del comando"
    echo "==============================================="
    exit 0
done