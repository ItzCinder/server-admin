#!/bin/bash

source "$(dirname "$0")/scripts/colors.sh"

# Ruta de la carpeta donde se ubican los scripts
SCRIPTS_DIR="./scripts"
while true; do
    clear
    print_header "==============================================="
    print_header "      PANEL DE ADMINISTRACION DE SERVIDOR      "
    print_header "==============================================="
    echo
    print_option "1) Gestionar usuarios"
    print_option "2) Gestionar grupos"
    print_option "3) Consultar grupos/usuarios"
    print_option "4) Panel de PROVISIONAMIENTO"
    print_option "0) Salir"
    echo
    print_header "==============================================="
    read -p "Selecciona una opción: " option
    case "$option" in
        1)  # Gestion de usuarios
            bash "$SCRIPTS_DIR/menus/users_menu.sh"
            ;;
        2)  # Gestion de grupos
            bash "$SCRIPTS_DIR/menus/groups_menu.sh"
            ;;
        3)  # Consultar grupos/usuarios
            bash "$SCRIPTS_DIR/menus/query_menu.sh"
            ;;
        4)  # Gestión de provisionamientos
            bash "$SCRIPTS_DIR/menus/provisioning_menu.sh"
            ;;
        0)  # Salir del programa
            print_warning "Saliendo del panel..."
            exit 0
            ;;
        *)  # Validación de entrada no existente
            print_error "Opcion no valida. Intenta de nuevo."
            ;;
    esac

    echo  
    read -p "Presiona [Enter] para continuar..."
done