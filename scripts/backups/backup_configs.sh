#!/bin/bash
DATE=$(date +"%Y%m%d_%H%M%S")
DEST_DIR="/mnt/backups/configs"
SOURCE_DIR="/opt/lampp/etc" # Configuraciones de XAMPP (httpd.conf, php.ini, my.cnf)
LOG_FILE="/var/log/backups/configs.log"

mkdir -p "$DEST_DIR"

# Respaldo Full de las configuraciones
tar -czf "$DEST_DIR/configs_full_$DATE.tar.gz" -C "$SOURCE_DIR" .

# Retención: 12 meses
find "$DEST_DIR" -type f -name "*.tar.gz" -mtime +365 -delete

echo "[$(date)] Respaldo Configuraciones XAMPP OK." >> "$LOG_FILE"