#!/bin/bash

source "$(dirname "$0")/../colors.sh"

# Validar si se esta ejecutando con sudo
if [ "$EUID" -ne 0 ]; then
    print_error "Se requiere sudo para ejecutar esta accion..."
    exit 1
fi

# Funcion para verificar si un grupo existe en el sistema
group_exist() {
    getent group "$1" > /dev/null 2>&1
}

while true; do
    clear
    print_header "==============================================="
    print_header "               BORRAR UN GRUPO                 "
    print_header "==============================================="
    read -p "Ingresa el nombre del grupo a eliminar: " delete_group

    if ! group_exist "$delete_group"; then
        print_error "El grupo '$delete_group' no existe en el sistema."
        read -p "Presiona Enter para intentar de nuevo..."
        continue
    fi

    gid_group=$(getent group "$delete_group" | cut -d: -f3)
    # si es grupo primario de algun usuario
    primary_users=$(awk -F: -v gid="$gid_group" '$4 == gid {print $1}' /etc/passwd)

    if [ -n "$primary_users" ]; then
        print_error "No sepuede eliminar el grupo '$delete_group'."
        print_error "Es el grupo primario de los siguientes usuarios:"
        print_error "-> $primary_users"
        print_error "Debes cambiar su grupo primario o borrar dichos usuarios antes."
        exit 1
    fi

    secondary_users=$(getent group "$delete_group" | cut -d: -f4)

    if [ -n "$secundary_users" ]; then
        print_warning "Los siguientes usuarios perderan este grupo secundario: "
        print_warning "-> $secondary_users"
        echo ""
    fi

    print_option "¿Estas seguro de eliminar el grupo '$delete_group'?"
    print_option "1) Si"
    print_option "0) No"
    read -p "Selecciona una opcion (1/0): " confirm

    if [ "$confirm" -ne 1 ] 2>/dev/null; then
        print_warning "Operacion cancelada."
        exit 0
    fi

    echo ""
    print_info "Eliminando grupo '$delete_group'..."

    groupdel "$delete_group"

    if [ $? -eq 0 ]; then
        print_success "El grupo '$delete_group' ha sido eliminado del sistema."
    else
        print_error "Hubo un fallo al intentar eliminar el grupo."
    fi
    exit 0
done