#!/usr/bin/env bash

source "$(dirname "$0")/../colors.sh"

# Validar si se esta ejecutando con sudo
if [ "$EUID" -ne 0 ]; then
    print_error "Se requiere sudo para ejecutar esta accion..."
    exit 1
fi

user_exist() {
    getent passwd "$1" > /dev/null 2>&1
}

while true; do
    clear
    print_header "==============================================="
    print_header "      MODIFICAR NOMBRE DE UN USUARIO            "
    print_header "==============================================="
    read -p "Ingresa el nombre ACTUAL del usuario: " old_user

    # Verificar si existe
    if ! user_exist "$old_user"; then
        print_error "El usuario '$old_user' no existe en el sistema."
        read -p "Presona Enter para intentar de nuevo..."
        continue
    fi

    # Comprobar si tiene procesos activos
    if pgrep -u "$old_user" > /dev/null 2>&1; then
        print_error "El usuario '$old_user' tiene procesos activos o la sesión esta abierta."
        print_error "Debes cerrar la sesion de ese usuario antes de modificarlo."
        exit 1
    fi

    read -p "Ingresa el NUEVO nombre de usuario: " new_user

    if user_exist "$new_user"; then
        print_error "Ya existe un usuario llamado '$new_user'."
        read -p "Presona Enter para intentar de nuevo..."
        continue
    fi

    print_option "¿Deseas renombrar tambien la carpeta /home/$old_user a /home/$new_user?"
    print_option "1) Sí"
    print_option "0) No"
    read -p "Selecciona una opcion (1/0): " option

    # Configuracionn de las preferencias si quiere renombrar tambien la carpeta home o no
    if [ "$option" -eq 1 ] 2>/dev/null; then
        options="-l $new_user -d /home/$new_user -m"
        rem_folder=1
    else
        options="-l $new_user"
        rem_folder=0
    fi

    echo ""
    print_info "Cambiando usuario '$old_user' -> '$new_user'..."

    # Se cambia el nombre segun las opciones elegidas
    usermod $options "$old_user"

    if [ $? -eq 0 ]; then
        print_success "El usuario se ha renombrado correctamente."
        if [ "$rem_folder" -eq 1 ]; then
            print_info "Su carpeta personal ahora es: /home/$new_user"
        fi
    else
        print_error "Hubo un fall al intentar modificar el nombre del usuario."
    fi
    exit 0
done


