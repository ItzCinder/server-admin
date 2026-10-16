#!/bin/bash
DATE=$(date +"%Y%m%d_%H%M%S")
DEST_DIR="/mnt/backups/configs"
SOURCE_DIR="${SOURCE_DIR:-}"
APACHE_CONFIG_DIR="${APACHE_CONFIG_DIR:-}"
MARIADB_CONFIG_DIR="${MARIADB_CONFIG_DIR:-/etc/mysql}"
LOG_FILE="/var/log/backups/configs.log"

mkdir -p "$DEST_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

if [ -z "$SOURCE_DIR" ]; then
    if [ -d /etc/apache2 ]; then
        APACHE_CONFIG_DIR="${APACHE_CONFIG_DIR:-/etc/apache2}"
    elif [ -d /etc/httpd ]; then
        APACHE_CONFIG_DIR="${APACHE_CONFIG_DIR:-/etc/httpd}"
    fi
else
    APACHE_CONFIG_DIR="$SOURCE_DIR"
fi

CONFIG_SOURCES=()
for source in "$APACHE_CONFIG_DIR" "$MARIADB_CONFIG_DIR"; do
    if [ -n "$source" ] && [ -d "$source" ]; then
        CONFIG_SOURCES+=("$source")
    fi
done

if [ "${#CONFIG_SOURCES[@]}" -eq 0 ]; then
    echo "No se encontraron configuraciones de Apache o MariaDB." >&2
    exit 1
fi

# Respaldo Full de las configuraciones
tar -czf "$DEST_DIR/configs_full_$DATE.tar.gz" "${CONFIG_SOURCES[@]}"

# Retención: 12 meses
count=$(find "$DEST_DIR" -type f -name "*.tar.gz" -mtime +365 | wc -l)
if [ "$count" -gt 0 ]; then
	find "$DEST_DIR" -type f -name "*.tar.gz" -mtime +365 -delete
	echo "[OK] Se eliminaron con éxito $count respaldos de configuración antiguos (365 días)." >> "$LOG_FILE"
fi

echo "[$(date)] Respaldo Configuraciones Apache/MariaDB OK." >> "$LOG_FILE"