#!/bin/bash

source "$(dirname "$0")/../colors.sh"

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    print_header "==============================================="
    print_header "          PANEL DE ADMINISTRACIÓN DE           "
    print_header "          PROVISIONAMIENTO DEL SERVIDOR        "
    print_header "==============================================="
    echo
    print_option "1) Provisionamiento de usuarios y grupos"
    print_option "0) Volver al menu principal"
    echo
    print_header "==============================================="
    read -p "Selecciona una opción: " option
    case "$option" in
        1)  # Setup usuarios
            bash "$SCRIPTS_DIR/provisioning/setup_users.sh"
            ;; 

        0)  # Salir del menu
            print_warning "Saliendo del panel..."
            exit 0
            ;;
        *)  # Validación de entrada no existente
            print_error "Opcion no valida. Intenta de nuevo."
            ;;
    esac

    echo ""
    read -p "Presiona [Enter] para continuar..."
done