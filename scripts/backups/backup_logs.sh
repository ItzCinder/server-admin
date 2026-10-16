#!/bin/bash
TYPE=$1
DATE=$(date +"%Y%m%d_%H%M%S")
DEST_DIR="/mnt/backups/logs_auditoria"
SOURCE_LOGS_APACHE="${SOURCE_LOGS_APACHE:-}"
SOURCE_LOGS_MARIADB="${SOURCE_LOGS_MARIADB:-}"
SOURCE_EVIDENCE="/var/evidencias_seguridad"
LOG_FILE="/var/log/backups/logs.log"
SNAPSHOT_FILE="$DEST_DIR/logs_snapshot.snar"

mkdir -p "$SOURCE_EVIDENCE"
mkdir -p "$DEST_DIR/differential" "$DEST_DIR/full"
mkdir -p "$(dirname "$LOG_FILE")"

if [ -z "$SOURCE_LOGS_APACHE" ]; then
    if [ -d /var/log/apache2 ]; then
        SOURCE_LOGS_APACHE="/var/log/apache2"
    else
        SOURCE_LOGS_APACHE="/var/log/httpd"
    fi
fi
if [ -z "$SOURCE_LOGS_MARIADB" ]; then
    if [ -d /var/log/mysql ]; then
        SOURCE_LOGS_MARIADB="/var/log/mysql"
    else
        SOURCE_LOGS_MARIADB="/var/log/mariadb"
    fi
fi

LOG_SOURCES=("$SOURCE_EVIDENCE")
for source in "$SOURCE_LOGS_APACHE" "$SOURCE_LOGS_MARIADB"; do
    if [ -d "$source" ]; then
        LOG_SOURCES+=("$source")
    fi
done

if [ "$TYPE" == "full" ]; then
    rm -f "$SNAPSHOT_FILE"
    # Agrupamos ambos directorios de logs en el tar
    tar --listed-incremental="$SNAPSHOT_FILE" -czf "$DEST_DIR/full/logs_full_$DATE.tar.gz" "${LOG_SOURCES[@]}"
    
    # Retención: 1 año
    count=$(find "$DEST_DIR/full" -type f -name "*.tar.gz" -mtime +365 | wc -l)
    if [ "$count" -gt 0 ]; then
        find "$DEST_DIR/full" -type f -name "*.tar.gz" -mtime +365 -delete
        echo "[OK] Se eliminaron con éxito $count Respaldo Logs FULL antiguos por cumplimiento de la política de retención. (365 días)" >> "$LOG_FILE"
    fi
    echo "[$(date)] Respaldo Logs FULL OK." >> "$LOG_FILE"

elif [ "$TYPE" == "differential" ]; then
    tar --listed-incremental="$SNAPSHOT_FILE" -czf "$DEST_DIR/differential/logs_diff_$DATE.tar.gz" "${LOG_SOURCES[@]}"
    
    # Retención: 90 días
    count=$(find "$DEST_DIR/differential" -type f -name "*.tar.gz" -mtime +90 | wc -l)
    if [ "$count" -gt 0 ]; then
        find "$DEST_DIR/differential" -type f -name "*.tar.gz" -mtime +90 -delete
        echo "[OK] Se eliminaron con éxito $count Respaldo Logs DIFFERENTIAL antiguos por cumplimiento de la política de retención. (90 días)" >> "$LOG_FILE"
    fi
    echo "[$(date)] Respaldo Logs DIFFERENTIAL OK." >> "$LOG_FILE"
fi