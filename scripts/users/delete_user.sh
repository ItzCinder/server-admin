#!/bin/bash
# Validar si se esta ejecutando con sudo
if [ "$EUID" -ne 0 ]; then
    echo "Se requiere sudo para ejecutar esta accion..."
    exit 1
fi

# Saber si el usuario existe
user_exist() {
    id "$1" > /dev/null 2>&1
}

while true; do
    clear
    echo "==============================================="
    echo "              ELIMINAR UN USUARIO              "
    echo "==============================================="
    read -p "Ingresa el nombre del usuario a eliminar: " delete_user

    # El usuario existe ?¿
    if ! user_exist "$delete_user"; then
        echo "El usuario '$delete_user' no existe en el sistema."
        read -p "Presiona Enter para intentar de nuevo..."
        continue
    fi

    if pgrep -u "$delete_user" > /dev/null 2>&1; then
        echo "El usuario '$delete_user' tiene procesos activos."
        echo "Debes cerrar todos sus procesos o cerrar su sesión antes de eliminarlo."
        exit 1
    fi

    echo ""
    echo "¿Deseas eliminar tambien la carpeta personal /home/$delete_user y sus archivos?"
    echo "1) Si"
    echo "2) No"
    read -p "Selecciona una opción (1/0)" option

    if [ "$option" -eq 1 ] 2>/dev/null; then
        options="-r"
        delete_home=1
    else
        options=""
        delete_home=0
    fi

    echo ""
    echo "¿Estas seguro que quieres eliminar al usuario '$delete_user'?"
    echo "1) Si"
    echo "2) No"
    read -p "Selecciona una opción (1/0)" confirm

    if [ "$confirm" -ne 1 ] 2>/dev/null; then
        echo "Operacion cancelada."
        exit 0
    fi
    
    echo ""
    echo "Eliminando usuario '$delete_user'"

    userdel $options "$delete_user"

    if [ $? -eq 0 ]; then
        echo "El usuario '$delete_user' ha sido eliminado."
        if [ "$delete_home" -eq 1 ]; then
            echo "Su carpeta /home y archivos personales tambien fueron eliminados."
        else
            echo "Su carpeta /home se conserva en el sistema."
        fi
    else
        echo "Hubo un fallo al intentar eliminar el usuario:"
    fi
    exit 0
done