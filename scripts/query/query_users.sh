#!/bin/bash

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    echo "==============================================="
    echo "      LISTA DE USUARIOS DEL SERVIDOR           "
    echo "==============================================="
    # Mostrar usuarios sin incluir los del sistema
    awk -F: '$3 >= 1000 && $3 < 60000 {print $1}' /etc/passwd || echo "Hubo un error en la ejecución del comando"
    echo "==============================================="
    exit 0
done