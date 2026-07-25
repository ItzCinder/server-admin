#!/bin/bash

source "$(dirname "$0")/../colors.sh"

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    print_header "==============================================="
    print_header "      PANEL DE CONSULTA DEL SERVIDOR           "
    print_header "==============================================="
    echo
    print_option "1) Consultar usuarios"
    print_option "2) Consultar usuarios (Incluyendo los del sistema)"
    print_option "3) Consultar grupos"
    print_option "4) Consultar grupos (Incluyendo los del sistema)"
    print_option "0) Volver al menu principal"
    echo
    print_header "==============================================="
    read -p "Selecciona una opción: " option
    case "$option" in
        1)  # Consultar usuarios
            bash "$SCRIPTS_DIR/query/query_users.sh"
            ;;
        2)  # Consultar usuarios (Incluyendo los del sistema)
            bash "$SCRIPTS_DIR/query/query_users_sys.sh"
            ;;    
        3)  # Consultar grupos
            bash "$SCRIPTS_DIR/query/query_groups.sh"
            ;;
        4)  # Consultar grupos (Incluyendo los del sistema)
            bash "$SCRIPTS_DIR/query/query_groups_sys.sh"
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