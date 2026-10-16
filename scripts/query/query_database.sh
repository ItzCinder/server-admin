#!/bin/bash

set -u

source "$(dirname "$0")/../colors.sh"

MYSQL="${MYSQL:-$(command -v mariadb || command -v mysql || true)}"
MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
DB_PASS="${DB_PASS:-}"
DB_NAME="${DB_NAME:-NuvaBD}"

if [ -z "$MYSQL" ] || [ ! -x "$MYSQL" ]; then
    print_error "No se encuentra el cliente mysql ejecutable: $MYSQL"
    exit 1
fi

MYSQL_OPTIONS=(
    --host="$MYSQL_HOST"
    --port="$MYSQL_PORT"
    --user="$MYSQL_USER"
    --database="$DB_NAME"
    --batch
    --table
)

run_query() {
    MYSQL_PWD="$DB_PASS" "$MYSQL" "${MYSQL_OPTIONS[@]}" --execute="$1"
}

list_tables() {
    MYSQL_PWD="$DB_PASS" "$MYSQL" \
        --host="$MYSQL_HOST" \
        --port="$MYSQL_PORT" \
        --user="$MYSQL_USER" \
        --batch \
        --skip-column-names \
        --execute="SELECT table_name FROM information_schema.tables WHERE table_schema = '$DB_NAME' ORDER BY table_name;"
}

select_table() {
    local table
    local tables

    tables=$(list_tables) || {
        print_error "No se pudieron consultar las tablas de '$DB_NAME'."
        return 1
    }

    if [ -z "$tables" ]; then
        print_warning "La base de datos '$DB_NAME' no contiene tablas."
        return 0
    fi

    echo "$tables" | nl -w2 -s') '
    read -r -p "Selecciona el número de la tabla: " table_number

    if ! [[ "$table_number" =~ ^[0-9]+$ ]]; then
        print_error "Debes seleccionar un número válido."
        return 1
    fi

    table=$(printf '%s\n' "$tables" | sed -n "${table_number}p")
    if [ -z "$table" ]; then
        print_error "La tabla seleccionada no existe."
        return 1
    fi

    printf '%s\n' "Tabla seleccionada: $table"
    printf '%s\n' "-----------------------------------------------"
    run_query "DESCRIBE \`$table\`;"
}

while true; do
    clear
    print_header "==============================================="
    print_header "          CONSULTAS DE LA BASE DE DATOS        "
    print_header "==============================================="
    print_info "Base de datos: $DB_NAME"
    echo
    print_option "1) Ver información de la base de datos"
    print_option "2) Listar tablas"
    print_option "3) Ver estructura de una tabla"
    print_option "4) Contar registros por tabla"
    print_option "0) Volver al menú anterior"
    echo
    print_header "==============================================="
    read -r -p "Selecciona una opción: " option

    case "$option" in
        1)
            run_query "SELECT DATABASE() AS base_de_datos, VERSION() AS version, NOW() AS fecha_servidor;"
            ;;
        2)
            run_query "SELECT table_name AS tabla, table_rows AS registros FROM information_schema.tables WHERE table_schema = '$DB_NAME' ORDER BY table_name;"
            ;;
        3)
            select_table
            ;;
        4)
            run_query "SELECT table_name AS tabla, table_rows AS registros FROM information_schema.tables WHERE table_schema = '$DB_NAME' ORDER BY table_rows DESC, table_name;"
            ;;
        0)
            exit 0
            ;;
        *)
            print_error "Opción no válida."
            ;;
    esac

    echo
    read -r -p "Presiona [Enter] para continuar..."
done
