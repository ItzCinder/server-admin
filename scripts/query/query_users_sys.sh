#!/bin/bash

source "$(dirname "$0")/../colors.sh"

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    print_header "==============================================="
    print_header "      LISTA DE USUARIOS DEL SERVIDOR           "
    print_header "      (Incluyendo los del sistema)             "
    print_header "==============================================="
    # Mostrar todos los usuarios
    awk -F: '{print "Usuario: " $1 " (UID: " $3 ")"}' /etc/passwd || print_error "Hubo un error en la ejecución del comando"
    print_header "==============================================="
    exit 0
done