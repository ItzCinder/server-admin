#!/bin/bash

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    echo "==============================================="
    echo "      PANEL DE ADMINISTRACIÓN DE USUARIOS      "
    echo "                 DEL SERVIDOR                  "
    echo "==============================================="
    echo
    echo "1) Crear usuario"
    echo "2) Modificar usuario"
    echo "3) Eliminar usuario"
    echo "0) Volver al menu principal"
    echo
    echo "==============================================="
    read -p "Selecciona una opción: " option
    case "$option" in
        1)  # Crear usuario
            bash "$SCRIPTS_DIR/users/create_user.sh"
            ;;
        2)  # Modificar usuario
            bash "$SCRIPTS_DIR/users/edit_user.sh"
            ;;    
        3)  # Eliminar usuario
            bash "$SCRIPTS_DIR/users/delete_user.sh"
            ;;
        0)  # Salir del menu
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