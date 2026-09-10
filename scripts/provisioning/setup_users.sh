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

# Definiciones -> grupo y si requiere sudo
REQUIRED_GROUPS=(
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
            continue
            ;;
    esac

done

create_group() {
    local group_name="$1"

    if getent group "$group_name" >/dev/null 2>&1; then
        print_warning "El grupo '$group_name' ya existe."
        return 0
    fi

    print_info "Creando grupo '$group_name'..."
    if groupadd "$group_name"; then
        if getent group "$group_name" >/dev/null 2>&1; then
            print_success "Grupo creado: $group_name"
            return 0
        fi

        print_error "El grupo '$group_name' no se pudo verificar tras crearse."
        return 1
    fi

    print_error "No se pudo crear el grupo '$group_name'."
    return 1
}

# Iterar REQUIRED_GROUPS -> crear grupos
for entry in "${REQUIRED_GROUPS[@]}"; do
    IFS=":" read -r group req_sudo <<< "$entry"

    create_group "$group"

    # Darle permisos sudo a un grupo que le corresponde permisos SUDO
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
        else
            rm -f "$TEMP_FILE"
            print_error "No se pudo validar la configuración sudo para '$group'."
        fi
    fi
done

# Crear usuarios con sus respectivos grupos y shell iterando sobre USERS
echo
for entry in "${USERS[@]}"; do
    IFS=":" read -r user group description shell <<< "$entry"

    if ! getent group "$group" >/dev/null 2>&1; then
        print_error "El grupo requerido '$group' no existe. No se puede crear el usuario '$user'."
        continue
    fi

    if ! id -u "$user" >/dev/null 2>&1; then
        print_info "Creando usuario '$user' con grupo '$group' ($description)..."
        if useradd -m -g "$group" -c "$description" -s "$shell" "$user"; then
            print_success "Usuario: '$user' | Grupo: '$group' | Shell: '$shell'"
        else
            print_error "No se pudo crear el usuario '$user'."
        fi
    else
        print_warning "El usuario '$user' ya existe. Se omite su creación."
    fi
done

echo
print_header "======================================="
print_success "     SETUP DE USUARIOS FINALIZADO     "
print_header "======================================="
echo ""