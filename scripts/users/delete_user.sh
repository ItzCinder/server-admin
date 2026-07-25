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

while true; do
    clear
    print_header "==============================================="
    print_header "              ELIMINAR UN USUARIO              "
    print_header "==============================================="
    read -p "Ingresa el nombre del usuario a eliminar: " delete_user

    # El usuario existe ?¿
    if ! user_exist "$delete_user"; then
        print_error "El usuario '$delete_user' no existe en el sistema."
        read -p "Presiona Enter para intentar de nuevo..."
        continue
    fi

    if pgrep -u "$delete_user" > /dev/null 2>&1; then
        print_error "El usuario '$delete_user' tiene procesos activos."
        print_error "Debes cerrar todos sus procesos o cerrar su sesión antes de eliminarlo."
        exit 1
    fi

    echo ""
    print_option "¿Deseas eliminar tambien la carpeta personal /home/$delete_user y sus archivos?"
    print_option "1) Si"
    print_option "2) No"
    read -p "Selecciona una opción (1/0)" option

    if [ "$option" -eq 1 ] 2>/dev/null; then
        options="-r"
        delete_home=1
    else
        options=""
        delete_home=0
    fi

    echo ""
    print_option "¿Estas seguro que quieres eliminar al usuario '$delete_user'?"
    print_option "1) Si"
    print_option "2) No"
    read -p "Selecciona una opción (1/0)" confirm

    if [ "$confirm" -ne 1 ] 2>/dev/null; then
        print_warning "Operacion cancelada."
        exit 0
    fi
    
    echo ""
    print_info "Eliminando usuario '$delete_user'"

    userdel $options "$delete_user"

    if [ $? -eq 0 ]; then
        print_success "El usuario '$delete_user' ha sido eliminado."
        if [ "$delete_home" -eq 1 ]; then
            print_info "Su carpeta /home y archivos personales tambien fueron eliminados."
        else
            print_info "Su carpeta /home se conserva en el sistema."
        fi
    else
        print_error "Hubo un fallo al intentar eliminar el usuario:"
    fi
    exit 0
done