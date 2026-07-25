#!/bin/bash
# Validar si se esta ejecutando con sudo
if [ "$EUID" -ne 0 ]; then
    echo "Se requiere sudo para ejecutar esta accion..."
    exit 1
fi

# Funcion para verificar si un grupo existe en el sistema
group_exist() {
    getent group "$1" > /dev/null 2>&1
}

while true; do
    clear
    echo "==============================================="
    echo "               BORRAR UN GRUPO                 "
    echo "==============================================="
    read -p "Ingresa el nombre del grupo a eliminar: " delete_group

    if ! group_exist "$delete_group"; then
        echo "El grupo '$delete_group' no existe en el sistema."
        read -p "Presiona Enter para intentar de nuevo..."
        continue
    fi

    $gid_group=$(getent group "$delete_group" | cut -d: -f3)
    # si es grupo primario de algun usuario
    $primary_users=$(awk -F: -v gid="$gid_group" '$4 == gid {print $1}' /etc/passwd)

    if [ -n "$primary_users" ]; then
        echo "No sepuede eliminar el grupo '$delete_group'."
        echo "Es el grupo primario de los siguientes usuarios:"
        echo "-> $primary_users"
        echo "Debes cambiar su grupo primario o borrar dichos usuarios antes."
        exit 1
    fi

    $secundary_users=$(getent group "$delete_group" | cut -d: -f4)

    if [ -n "$secundary_users" ]; then
        echo "Los siguientes usuarios perderan este grupo secundario: "
        echo "-> $secundary_users"
        echo ""
    fi

    echo "¿Estas seguro de eliminar el grupo '$delete_group'?"
    echo "1) Si"
    echo "0) No"
    read -p "Selecciona una opcion (1/0): " confirm

    if [ "$confirm" -ne 1 ] 2>/dev/null; then
        echo "Operacion cancelada."
        exit 0
    fi

    echo ""
    echo "Eliminando grupo '$delete_group'..."

    groupdel "$delete_group"

    if [ $? -eq 0 ]; then
        echo "El grupo '$delete_group' ha sido eliminado del sistema."
    else
        echo "Hubo un fallo al intentar eliminar el grupo."
    fi
    exit 0
done