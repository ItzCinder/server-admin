#!/bin/bash

# Ruta de la carpeta donde se ubican los scripts
SCRIPTS_DIR="./scripts"
while true; do
    clear
    echo "==============================================="
    echo "      PANEL DE ADMINISTRACION DE SERVIDOR      "
    echo "==============================================="
    echo
    echo "1) Gestionar usuarios"
    echo "2) Gestionar grupos"
    echo "3) Consultar grupos/usuarios"
    echo "0) Salir"
    echo
    echo "==============================================="
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
        0)  # Salir del programa
            echo "Saliendo del panel..."
            exit 0
            ;;
        *)  # Validación de entrada no existente
            echo "Opcion no valida. Intenta de nuevo."
            ;;
    esac

    echo ""
    read -p "Presiona [Enter] para continuar..."
done