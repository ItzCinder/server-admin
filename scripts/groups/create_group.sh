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
    echo "               CREAR UN GRUPO                  "
    echo "==============================================="
    read -p "Ingresa el nombre del grupo a crear: " new_group

    if group_exist "$new_group"; then
        echo "El grupo '$new_group' ya existe en el sistema."
        read -p "Presiona Enter para intentar de nuevo..."
        continue
    fi

    echo ""
    echo "¿Deseas asignar un identificador de grupo (GID) personalizado?"
    echo "1) Si"
    echo "0) No (el sistema da uno automaticamente)"
    read -p "Selecciona una opcion (1/0): " use_gid

    create_options=""

    if [ "$use_gid" -eq 1 ] 2>/dev/null; then
        echo ""
        read -p "Ingresa el GID numerico deseado: " gid_custom

        # Valida que sea un numero
        if [[ "$gid_custom" =~ ^[0-9]+$ ]]; then
            create_options="-g $gid_custom"
        else
            echo "El GID debe ser un valor numerico."
            read -p "Presiona Enter para intentar de nuevo..."
            continue
        fi
    fi

    echo ""
    echo "Creando el grupo '$new_group'"

    groupdadd $create_options "$new_group"

    if [ $? -eq 0 ]; then
        echo "El grupo '$new_group' se ha creado exitosamente."

        info_group=$(getent group "$new_group")
        echo "Detalles: $info_group"
    else
        echo "Hubo un error al crear el grupo."
    fi
    exit 0
done

