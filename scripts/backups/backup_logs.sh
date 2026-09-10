#!/bin/bash
TYPE=$1
DATE=$(date +"%Y%m%d_%H%M%S")
DEST_DIR="/mnt/backups/logs_auditoria"
SOURCE_LOGS_APACHE="/opt/lampp/logs"
SOURCE_LOGS_MYSQL="/opt/lampp/var/mysql" # Logs de MariaDB (errores y binarios si están activos)
LOG_FILE="/var/log/backups/logs.log"
SNAPSHOT_FILE="$DEST_DIR/logs_snapshot.snar"

mkdir -p "$DEST_DIR/differential" "$DEST_DIR/full"

if [ "$TYPE" == "full" ]; then
    rm -f "$SNAPSHOT_FILE"
    # Agrupamos ambos directorios de logs en el tar
    tar --listed-incremental="$SNAPSHOT_FILE" -czf "$DEST_DIR/full/logs_full_$DATE.tar.gz" "$SOURCE_LOGS_APACHE" "$SOURCE_LOGS_MYSQL"
    
    # Retención: 1 año
    find "$DEST_DIR/full" -type f -name "*.tar.gz" -mtime +365 -delete
    echo "[$(date)] Respaldo Logs FULL OK." >> "$LOG_FILE"

elif [ "$TYPE" == "differential" ]; then
    tar --listed-incremental="$SNAPSHOT_FILE" -czf "$DEST_DIR/differential/logs_diff_$DATE.tar.gz" "$SOURCE_LOGS_APACHE" "$SOURCE_LOGS_MYSQL"
    
    # Retención: 90 días
    find "$DEST_DIR/differential" -type f -name "*.tar.gz" -mtime +90 -delete
    echo "[$(date)] Respaldo Logs DIFFERENTIAL OK." >> "$LOG_FILE"
fi