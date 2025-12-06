#!/bin/bash

# Directorio a respaldar 
SOURCE_DIR="../deploy"
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backup_deploy_$TIMESTAMP.tar.gz"

echo "--- Iniciando Respaldo ---"

# Crear carpeta de backups
mkdir -p $BACKUP_DIR

# Crear el archivo comprimido
tar -czf "$BACKUP_DIR/$BACKUP_FILE" $SOURCE_DIR

echo "[+] Respaldo creado exitosamente en:"
echo "$BACKUP_DIR/$BACKUP_FILE"
ls -lh $BACKUP_DIR
