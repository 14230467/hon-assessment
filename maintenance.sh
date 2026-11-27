#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="${1:-/var/log}"
Backup_DIR="${2:-/.log_backups}"
TARGET_FILE="${3:-./maintenance.sh}"

# 1. Set file permission
chmod 755 "$TARGET_FILE"

# 2. Create backup directory if it doesn't exist
mkdir -p "$Backup_DIR"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
if [ -d "$LOG_DIR" ]; then
    tar -czf "$Backup_DIR/log_backup_$TIMESTAMP.tar.gz" -C "$LOG_DIR" .
fi

# 3. Update packages
if command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get upgrade -y
elif command -v yum &> /dev/null; then
    sudo yum update -y
fi

echo "Maintenance completed at $(date)"