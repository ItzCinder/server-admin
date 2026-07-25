#!/bin/bash

source "$(dirname "$0")/../colors.sh"

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    print_header "==============================================="
    print_header "      LISTA DE GRUPOS DEL SERVIDOR             "
    print_header "      (Incluyendo los del sistema)             "
    print_header "==============================================="
    # Mostrar grupos
    awk -F: '{print "Grupo: " $1 " (GID: " $3 ") - Miembros: " $4}' /etc/group || print_error "Hubo un error en la ejecución del comando" 
    print_header "==============================================="
    exit 0
done