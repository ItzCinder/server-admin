#!/bin/bash

source "$(dirname "$0")/../colors.sh"

# Validar si se esta ejecutando con sudo
if [ "$EUID" -ne 0 ]; then
    print_error "Se requiere sudo para ejecutar esta accion..."
    exit 1
fi

# Saber si el usuario existe
user_exist() {
    id "$1" > /dev/null 2>&1
}

# Funcion para verificar si un grupo existe en el sistema
group_exist() {
    getent group "$1" > /dev/null 2>&1
}

while true; do
    clear
    print_header "==============================================="
    print_header "          ASIGNAR GRUPO A UN USUARIO           "
    print_header "==============================================="
    read -p "Ingresa el nombre del usuario: " user

    if ! user_exist "$user"; then
        print_error "El usuario '$user' no existe en el sistema."
        read -p "Presiona Enter para intentar de nuevo..."
        continue
    fi

    read -p "Ingresa el nombre del grupo a asignar a '$user'." $group

    if ! group_exist "$group"; then
        print_error "El grupo '$group' no existe en el sistema."
        read -p "Presiona Enter para intentar de nuevo..."
        continue
    fi

    # Comprobar si Usuario esta en el grupo
    if id -nG "$user" | grep -qw "$group"; then
        print_warning "El usuario '$user' ya pertenece al grupo '$group'."
        exit 0
    fi

    echo ""
    print_option "¿Como deseas asignar el grupo '$group' al usuario '$user'?"
    print_option "1) Como grupo secundario (conserva sus otros grupos)"
    print_option "0) Como grupo primario (cambia su grupo principal por defecto)"
    read -p "Selecciona una opcion (1/0): " type_group

    if [ "$type_group" -eq 0] 2>/dev/null; then
        option="-g"
        description="grupo primario"
    else 
        option="-aG"
        description="grupo secundario"
    fi

    echo ""
    print_info "Asignando '$user' a '$group' ($description)..."

    usermod $option "$group" "$user"

    if [ $? -eq 0 ]; then
        print_success "El usuario '$user' ahora pertenece al grupo '$group'."
    else
        print_error "Hubo un fallo al intentar asignar el grupo."
    fi
    exit 0
done
