#!/bin/bash
TYPE=$1
DATE=$(date +"%Y%m%d_%H%M%S")
DEST_DIR="/mnt/backups/logs_auditoria"
SOURCE_LOGS_APACHE="/opt/lampp/logs"
SOURCE_LOGS_MYSQL="/opt/lampp/var/mysql"
SOURCE_EVIDENCE="/var/evidencias_seguridad"
LOG_FILE="/var/log/backups/logs.log"
SNAPSHOT_FILE="$DEST_DIR/logs_snapshot.snar"

mkdir -p "$SOURCE_EVIDENCE"
mkdir -p "$DEST_DIR/differential" "$DEST_DIR/full"
mkdir -p $(dirname "$LOG_FILE")

if [ "$TYPE" == "full" ]; then
    rm -f "$SNAPSHOT_FILE"
    # Agrupamos ambos directorios de logs en el tar
    tar --listed-incremental="$SNAPSHOT_FILE" -czf "$DEST_DIR/full/logs_full_$DATE.tar.gz" "$SOURCE_LOGS_APACHE" "$SOURCE_LOGS_MYSQL" "$SOURCE_EVIDENCE"
    
    # Retención: 1 año
    count=$(find "$DEST_DIR/full" -type f -name "*.tar.gz" -mtime +365 | wc -l)
    if [ "$count" -gt 0 ]; then
        find "$DEST_DIR/full" -type f -name "*.tar.gz" -mtime +365 -delete
        echo "[OK] Se eliminaron con éxito $count Respaldo Logs FULL antiguos por cumplimiento de la política de retención. (365 días)" >> "$LOG_FILE"
    fi
    echo "[$(date)] Respaldo Logs FULL OK." >> "$LOG_FILE"

elif [ "$TYPE" == "differential" ]; then
    tar --listed-incremental="$SNAPSHOT_FILE" -czf "$DEST_DIR/differential/logs_diff_$DATE.tar.gz" "$SOURCE_LOGS_APACHE" "$SOURCE_LOGS_MYSQL" "$SOURCE_EVIDENCE"
    
    # Retención: 90 días
    count=$(find "$DEST_DIR/differential" -type f -name "*.tar.gz" -mtime +90 | wc -l)
    if [ "$count" -gt 0 ]; then
        find "$DEST_DIR/differential" -type f -name "*.tar.gz" -mtime +90 -delete
        echo "[OK] Se eliminaron con éxito $count Respaldo Logs DIFFERENTIAL antiguos por cumplimiento de la política de retención. (90 días)" >> "$LOG_FILE"
    fi
    echo "[$(date)] Respaldo Logs DIFFERENTIAL OK." >> "$LOG_FILE"
fi