#!/bin/bash

source "$(dirname "$0")/../colors.sh"

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    print_header "==============================================="
    print_header "      PANEL DE ADMINISTRACIÓN DE GRUPOS        "
    print_header "                 DEL SERVIDOR                  "
    print_header "==============================================="
    echo
    print_option "1) Crear grupo"
    print_option "2) Modificar grupo"
    print_option "3) Eliminar grupo"
    print_option "4) Asignar grupo a un usuario"
    print_option "0) Volver al menu principal"
    echo
    print_header "==============================================="
    read -p "Selecciona una opción: " option
    case "$option" in
        1)  # Crear grupo
            bash "$SCRIPTS_DIR/groups/create_group.sh"
            ;;
        2)  # Modificar grupo
            bash "$SCRIPTS_DIR/groups/edit_group.sh"
            ;;    
        3)  # Eliminar grupo
            bash "$SCRIPTS_DIR/groups/delete_group.sh"
            ;;
        4)  # Asignar grupo a un usuario
            bash "$SCRIPTS_DIR/groups/assign_group.sh"
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