#!/bin/bash

source "$(dirname "$0")/../colors.sh"

# Validar si se esta ejecutando con sudo
if [ "$EUID" -ne 0 ]; then
    print_error "Se requiere sudo para ejecutar esta accion..."
    exit 1
fi

# Si un comando falla -> el script deja de ejecutarse
set -euo pipefail

# Definiciones -> usuario:grupo:descripcion:shell
USERS=(
  "admin:sysadmin:Administrador del sistema:/bin/bash"
  "webadmin:webadmin:Administrador web:/bin/bash"
  "dbadmin:dbadmin:Administrador de base de datos:/bin/bash"
  "backupop:backup:Operador de respaldos:/bin/bash"
  "auditor:audit:Auditor:/usr/bin/rbash"
  "user:users:Usuario estándar:/bin/bash"
  "scriptdev:scriptdev:Desarrollador de Scripts:/bin/bash"
)

# Definiciones -> grupo:sudo
GROUPS=(
    "sysadmin:true"
    "webadmin:false"
    "dbadmin:false"
    "backup:false"
    "audit:false"
    "users:false"
    "scriptdev:false"

)

while true; do
    clear
    print_warning "¿Deseas ejecutar el provisionamiento de usuarios y grupos?"
    echo ""
    print_option "1) Sí, ejecutar"
    print_option "2) No, cancelar"
    echo ""
    read -p "Selecciona una opción: " confirm
    
    case "$confirm" in
        1)
            break
            ;;
        2)
            print_warning "Operación cancelada."
            exit 0
            ;;
        *)
            print_error "Opcion no valida. Intenta de nuevo."
            ;;
    esac

    # Iterar GROUPS -> crear grupos
    for entry in "${GROUPS[@]}"; do
        IFS=":" read -r group req_sudo <<< "$entry"

        # Si el grupo no existe
        if ! getent group "$group" >/dev/null; then
            groupadd "$group"
            print_success "Grupo creado: $group"
        fi

        if [[ "$req_sudo" == "true" ]]; then

            print_info "Configurando sudo para el grupo '$group'..."

            SUDO_FILE="/etc/sudoers.d/$group"
            TEMP_FILE=$(mktemp)
            echo "%$group ALL=(ALL:ALL) ALL" > "$TEMP_FILE"

            if visudo -cf "$TEMP_FILE" >/dev/null; then
                mv "$TEMP_FILE" "$SUDO_FILE"
                chmod 0440 "$SUDO_FILE"
                chown root:root "$SUDO_FILE"
                print_success "Permisos sudo configurados para: $group"
            fi
        fi


    done

    # Crear usuarios con sus respectivos grupos y shell iterando sobre USERS
    echo
    for entry in "${USERS[@]}"; do
        IFS=":" read -r user group description shell <<< "$entry"

        if ! id -u "$user" >/dev/null; then
            print_info "Creando usuario '$user' con grupo '$group' ($description)..."
            if useradd -m -g "$group" -c "$description" -s "$shell" "$user"; then
                print_success "Usuario: '$user' | Grupo: '$group' | Shell: '$shell'"
            fi    read -p "Presiona [Enter] para continuar..."
        fi 

    done

    echo
    print_header "======================================="
    print_success "     SETUP DE USUARIOS FINALIZADO     "
    print_header "======================================="
    echo ""
    read -p "Presiona [Enter] para continuar..."
    exit 0
done