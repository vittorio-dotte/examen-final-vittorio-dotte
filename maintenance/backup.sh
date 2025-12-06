#!/bin/bash



# Directorio origen 
SOURCE_DIR="/opt/webapp/html"
# Directorio local de seguridad
LOCAL_SAFE_DIR="/var/backups/webapp"
# Nombre con Timestamp dinámico
TIMESTAMP=$(date +%Y-%m-%d_%H%M)
BACKUP_NAME="backup_web_$TIMESTAMP.tar.gz"
# Directorio temporal
TEMP_DIR="/tmp/backups_temp"

echo "--- [Fase 3] Iniciando Protocolo de Respaldo ---"

# Empaquetado y Compresión
echo "[1/3] Generando archivo comprimido..."
mkdir -p $TEMP_DIR

# Verificamos que exista el origen
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: No existe el directorio origen $SOURCE_DIR"
    exit 1
fi

sudo tar -czf "$TEMP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" .

if [ $? -eq 0 ]; then
    echo "    Archivo generado: $BACKUP_NAME"
else
    echo "ERROR: Falló la compresión."
    exit 1
fi

#Sincronización Local (rsync)
echo "[2/3] Sincronizando a directorio seguro local ($LOCAL_SAFE_DIR)..."

if [ ! -d "$LOCAL_SAFE_DIR" ]; then
    sudo mkdir -p "$LOCAL_SAFE_DIR"
    
fi

sudo rsync -avz "$TEMP_DIR/$BACKUP_NAME" "$LOCAL_SAFE_DIR/"

if [ $? -eq 0 ]; then
    echo "    Copia local exitosa."
else
    echo "ERROR: Falló rsync local."
    exit 2
fi

# Transferencia Remota 
REMOTE_USER="admin"
REMOTE_HOST="192.168.1.200" 
REMOTE_DIR="/srv/backups/"

echo "[3/3] Transfiriendo a servidor remoto ($REMOTE_HOST)..."

scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no \
    "$LOCAL_SAFE_DIR/$BACKUP_NAME" \
    "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "    Transferencia remota exitosa."
else
    echo "WARN: La transferencia remota no se completó (Código: $EXIT_CODE)."
    echo "      (Esperado en entorno de prueba sin host remoto)."
fi


rm -rf $TEMP_DIR
echo "--- Respaldo Finalizado ---"
