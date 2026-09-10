#!/bin/bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Se requiere sudo para configurar las tareas de cron." >&2
    exit 1
fi

BACKUP_USER="${BACKUP_USER:-backupop}"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
BACKUP_DIR="$PROJECT_DIR/scripts/backups"
START_MARKER="# BEGIN nuva-panelSRV-backups"
END_MARKER="# END nuva-panelSRV-backups"

# Verifica si el usuario es el backuop
if ! id -u "$BACKUP_USER" >/dev/null 2>&1; then
    echo "El usuario de respaldos no existe: $BACKUP_USER" >&2
    exit 1
fi

# Identifica si existe los scriptss
for script in "$BACKUP_DIR/backup_db_nuva.sh" "$BACKUP_DIR/backup_repos.sh" "$BACKUP_DIR/backup_configs.sh" "$BACKUP_DIR/backup_logs.sh"; do
    if [ ! -f "$script" ]; then
        echo "No se encuentra el script de backup: $script" >&2
        exit 1
    fi
done

# Identifica sus marcados para solo modificar las tareas programadas dentro de los dos marcados definidios. START_MARKER y END_MARKER.
CURRENT_CRONTAB=$(crontab -u "$BACKUP_USER" -l 2>/dev/null || true)
# Limpia las tareas marcadas dentro de START_MARKER y END_MARKER: las quita. Las filtra.
# FILTERED_CRONTAB se queda con las tareas que no estan dentro de los marcadores START y END
FILTERED_CRONTAB=$(printf '%s\n' "$CURRENT_CRONTAB" | awk -v start="$START_MARKER" -v end="$END_MARKER" '
    $0 == start { inside = 1; next }
    $0 == end { inside = 0; next }
    !inside { print }
')

CRON_BLOCK=$(cat <<EOF
$START_MARKER
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
0 23 * * * /bin/bash "$BACKUP_DIR/backup_db_nuva.sh" daily
0 2 * * 0 /bin/bash "$BACKUP_DIR/backup_db_nuva.sh" weekly
0 20 * * 1-5 /bin/bash "$BACKUP_DIR/backup_repos.sh" differential
0 1 * * 6 /bin/bash "$BACKUP_DIR/backup_repos.sh" full
0 3 * * 0 /bin/bash "$BACKUP_DIR/backup_configs.sh"
30 23 * * * /bin/bash "$BACKUP_DIR/backup_logs.sh" differential
0 4 1 * * /bin/bash "$BACKUP_DIR/backup_logs.sh" full
$END_MARKER
EOF
)
# Incrusta las tareas viejas FILTERED_CRONTAB + el bloque nuevo con las tareas de CRON_BLOCK.
printf '%s\n%s\n' "$FILTERED_CRONTAB" "$CRON_BLOCK" | crontab -u "$BACKUP_USER" -

echo "Tareas de backup configuradas en el crontab de '$BACKUP_USER'."
