#!/bin/bash

set -euo pipefail

MYSQLADMIN="${MYSQLADMIN:-$(command -v mariadb-admin || command -v mysqladmin || true)}"
MYSQL="${MYSQL:-$(command -v mariadb || command -v mysql || true)}"
APACHE_SERVICE="${APACHE_SERVICE:-}"
MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
DB_PASS="${DB_PASS:-}"
DB_NAME="${DB_NAME:-NuvaBD}"
LOG_FILE="${SERVER_MONITOR_LOG:-${MARIADB_MONITOR_LOG:-/var/log/backups/server_monitor.log}}"

for client in "$MYSQLADMIN" "$MYSQL"; do
    if [ -z "$client" ] || [ ! -x "$client" ]; then
        echo "No se encuentra el cliente MariaDB ejecutable: $client" >&2
        exit 1
    fi
done

mkdir -p "$(dirname "$LOG_FILE")"

MYSQL_OPTIONS=(
    --host="$MYSQL_HOST"
    --port="$MYSQL_PORT"
    --user="$MYSQL_USER"
    --database="$DB_NAME"
    --batch
    --skip-column-names
)

timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

apache_service_is_active() {
    local service

    if ! command -v systemctl >/dev/null 2>&1; then
        return 1
    fi

    if [ -n "$APACHE_SERVICE" ]; then
        systemctl is-active --quiet "$APACHE_SERVICE"
        return
    fi

    for service in apache2 httpd; do
        if systemctl is-active --quiet "$service"; then
            return 0
        fi
    done
    return 1
}

if ! apache_service_is_active; then
    printf '[%s] ERROR: Apache no está activo (servicio apache2/httpd).\n' \
        "$(timestamp)" >> "$LOG_FILE"
    apache_status=error
else
    printf '[%s] Apache disponible y servicio activo.\n' \
        "$(timestamp)" >> "$LOG_FILE"
    apache_status=ok
fi

if ! "$MYSQLADMIN" \
    --host="$MYSQL_HOST" \
    --port="$MYSQL_PORT" \
    --user="$MYSQL_USER" \
    ping >/dev/null 2>&1; then
    printf '[%s] ERROR: MariaDB no responde (%s:%s).\n' \
        "$(timestamp)" "$MYSQL_HOST" "$MYSQL_PORT" >> "$LOG_FILE"
    exit 1
fi

if ! table_count=$(MYSQL_PWD="$DB_PASS" "$MYSQL" "${MYSQL_OPTIONS[@]}" \
    --execute='SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE();' \
    2>/dev/null); then
    printf '[%s] ERROR: no se pudo ejecutar una consulta en la base de datos "%s".\n' \
        "$(timestamp)" "$DB_NAME" >> "$LOG_FILE"
    exit 1
fi

if ! [[ "$table_count" =~ ^[0-9]+$ ]]; then
    printf '[%s] ERROR: la consulta de MariaDB devolvió una respuesta inválida para "%s".\n' \
        "$(timestamp)" "$DB_NAME" >> "$LOG_FILE"
    exit 1
fi

printf '[%s] MariaDB disponible y consulta OK (%s:%s, base "%s", tablas: %s).\n' \
    "$(timestamp)" "$MYSQL_HOST" "$MYSQL_PORT" "$DB_NAME" "$table_count" >> "$LOG_FILE"

if [ "$apache_status" = error ]; then
    exit 1
fi
