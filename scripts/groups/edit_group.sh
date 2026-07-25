#!/usr/bin/env bash

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
    echo "      MODIFICAR NOMBRE DE UN GRUPO             "
    echo "==============================================="
    read -p "Ingresa el nombre ACTUAL del grupo: " old_group

    # Verificar si existe
    if ! group_exist "$old_group"; then
        echo "El grupo '$old_group' no existe en el sistema."
        read -p "Presiona Enter para intentar de nuevo..."
        continue
    fi

    read -p "Ingresa el NUEVO nombre para el grupo: " new_group

    # Verificar si no esta vacio
    if [ -z "$new_group" ]; then
        echo "El nuevo nombre no puede estar vacio."
    fi

    # Verificar si el nombre nuevo esta ocupado
    if group_exist "$new_group"; then
        echo "Ya existe un grupo llamado '$new_group'."
        read -p "Presiona Enter para intentar de nuevo..."
        continue
    fi

    echo "Cambiando '$old_group' -> '$new_group'..."
    groupmod -n "$new_group" "$old_group"
    
    # Validación si se ejecuto exitosamente el ultimo comando
    if [ $? -eq 0 ]; then
        echo "El grupo fue renombrado exitosamente."
    else
        echo "Hubo un error al intentar cambiar el nombre del grupo."
    fi
    exit 0
done


