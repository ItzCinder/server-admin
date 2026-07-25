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
    echo "              CREAR UN USUARIO                 "
    echo "==============================================="
    read -p "Ingresa el nombre del nuevo usuario: " new_user

    # Verificar si el usuario existe
    if user_exist "$new_user"; then
        echo "El usuario '$new_user' ya existe en el sistema."
        read -p "Presona Enter para intentar de nuevo..."
        continue
    fi

    echo ""
    while true; do
        read -sp "Ingresa la contraseña para $new_user: " password
        echo ""
        read -sp "Confirma la contraseña: " password_confirm
        echo ""

        # Si las ccontraseña no coincide
        if [ "$password" != "$password_confirm" ]; then
            echo "Las contraseñas no coinciden."
            read -p "Presiona Enter para intentar de nuevo..."
            continue
        fi
        break
    done

    create_command="useradd -m -s /bin/bash '$new_user'"

    eval $create_command
    echo "$new_user:$password" | chpasswd

    if [ $? -eq 0 ]; then
        echo "El usuario '$new_user' fue creado correctamente."

    else
        echo "Hubo un fallo al intentar crear el usuario."
    fi
    exit 0
done

