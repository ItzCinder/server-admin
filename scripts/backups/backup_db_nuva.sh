#!/bin/bash
TYPE=$1
DATE=$(date +"%Y%m%d_%H%M%S")
DEST_DIR="/mnt/backups/db_nuva"
LOG_FILE="/var/log/backups/db_audit.log"

MYSQLDUMP="/opt/lampp/bin/mysqldump"
DB_USER="root" # Usuario de la BD
DB_PASS="" # Contraseña del usuario de la BD
DB_NAME="nuva_db" # Nombre de la base de datos

mkdir -p "$DEST_DIR/daily" "$DEST_DIR/weekly"
mkdir -p $(dirname "$LOG_FILE")

if [ "$TYPE" == "daily" ]; then
    # Exportación lógica diaria (Estructura y datos)
    $MYSQLDUMP -u $DB_USER -p$DB_PASS $DB_NAME | gzip > "$DEST_DIR/daily/nuva_daily_$DATE.sql.gz"
    
    # Retención de 30 días
    find "$DEST_DIR/daily" -type f -name "*.gz" -mtime +30 -delete
    echo "[$(date)] Respaldo MariaDB daily OK." >> "$LOG_FILE"

elif [ "$TYPE" == "weekly" ]; then
    # Completo (Full) que incluye rutinas, triggers y eventos
    $MYSQLDUMP -u $DB_USER -p$DB_PASS --routines --triggers --events $DB_NAME | gzip > "$DEST_DIR/weekly/nuva_full_$DATE.sql.gz"
    
    # Retención de 12 meses
    find "$DEST_DIR/weekly" -type f -name "*.gz" -mtime +365 -delete
    echo "[$(date)] Respaldo MariaDB weekly Full OK." >> "$LOG_FILE"
fi