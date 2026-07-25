#!/bin/bash

# Ruta de la carpeta donde se ubican los scripts
export SCRIPTS_DIR="./scripts"
while true; do
    clear
    echo "==============================================="
    echo "      PANEL DE ADMINISTRACIÓN DE GRUPOS        "
    echo "                 DEL SERVIDOR                  "
    echo "==============================================="
    echo
    echo "1) Crear grupo"
    echo "2) Editar grupo"
    echo "3) Borrar grupo"
    echo "4) Asignar grupo a un usuario"
    echo "0) Volver al menu principal"
    echo
    echo "==============================================="
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