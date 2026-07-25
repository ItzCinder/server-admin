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
    echo "3) Eliminar grupo"
    echo "4) Asignar grupo a un usuario"
    echo "0) Volver al menu principal"
    echo
    echo "==============================================="
    read -p "Selecciona una opción: " option
    case "$option" in
        1)  # Crear grupo
            bash "$SCRIPTS_DIR/groups/create_group.sh"
            ;;
        2)  # Editar grupo
            bash "$SCRIPTS_DIR/groups/edit_group.sh"
            ;;    
        3)  # Borrar grupo
            bash "$SCRIPTS_DIR/groups/delete_group.sh"
            ;;
        4)  # Asignar grupo a un usuario
            bash "$SCRIPTS_DIR/groups/assign_group.sh"
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