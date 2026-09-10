#!/bin/bash
TYPE=$1
DATE=$(date +"%Y%m%d_%H%M%S")
DEST_DIR="/mnt/backups/repos"
SOURCE_DIR="/opt/lampp/htdocs" # Ruta de tu código web
LOG_FILE="/var/log/backups/repos.log"
SNAPSHOT_FILE="$DEST_DIR/repos_snapshot.snar"

mkdir -p "$DEST_DIR/differential" "$DEST_DIR/full"

if [ "$TYPE" == "full" ]; then
    # Eliminar el snapshot anterior para forzar un backup completo nuevo
    rm -f "$SNAPSHOT_FILE"
    tar --listed-incremental="$SNAPSHOT_FILE" -czf "$DEST_DIR/full/repos_full_$DATE.tar.gz" -C "$SOURCE_DIR" .
    
    # Retención: 6 mese
    find "$DEST_DIR/full" -type f -name "*.tar.gz" -mtime +180 -delete
    echo "[$(date)] Respaldo Código Completo OK." >> "$LOG_FILE"

elif [ "$TYPE" == "differential" ]; then
    # Backup que lee el snapshot creado por el FULL para guardar solo los cambios
    tar --listed-incremental="$SNAPSHOT_FILE" -czf "$DEST_DIR/differential/repos_diff_$DATE.tar.gz" -C "$SOURCE_DIR" .
    
    # Retención: 14 días
    find "$DEST_DIR/differential" -type f -name "*.tar.gz" -mtime +14 -delete
    echo "[$(date)] Respaldo Código Diferenciaal OK." >> "$LOG_FILE"
fi