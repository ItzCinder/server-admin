#!/bin/bash

source "$(dirname "$0")/../colors.sh"

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    print_header "==============================================="
    print_header "      LISTA DE USUARIOS DEL SERVIDOR           "
    print_header "==============================================="
    # Mostrar usuarios sin incluir los del sistema
    awk -F: '$3 >= 1000 && $3 < 60000 {print "Usuario: " $1 " (UID: " $3 ")"}' /etc/passwd
    print_header "==============================================="
    exit 0
done