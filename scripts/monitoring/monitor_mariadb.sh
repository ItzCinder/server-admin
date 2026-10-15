#!/bin/bash

set -euo pipefail

MYSQLADMIN="${MYSQLADMIN:-/opt/lampp/bin/mysqladmin}"
MYSQL="${MYSQL:-/opt/lampp/bin/mysql}"
MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
DB_PASS="${DB_PASS:-}"
DB_NAME="${DB_NAME:-NuvaBD}"
LOG_FILE="${MARIADB_MONITOR_LOG:-/var/log/backups/mariadb_monitor.log}"

for client in "$MYSQLADMIN" "$MYSQL"; do
    if [ ! -x "$client" ]; then
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
