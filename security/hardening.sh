#!/bin/bash


echo "--- [Fase 2] Iniciando Hardening ---"

# Seguridad de Red (Firewalling)
echo "[+] Configurando UFW (Default Deny)..."

sudo ufw default deny incoming
sudo ufw default allow outgoing

# Excepciones requeridas
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 8080/tcp  # Web App

echo "[+] Estado del Firewall:"

sudo ufw status verbose

# Seguridad del Daemon SSH
SSH_CONFIG="/etc/ssh/sshd_config"
echo "[+] Asegurando SSH en $SSH_CONFIG..."

# Backup previo si no existe
if [ ! -f "$SSH_CONFIG.bak" ]; then
    sudo cp $SSH_CONFIG "$SSH_CONFIG.bak"
fi

# Edición no interactiva: Forzar PermitRootLogin no
if grep -q "^PermitRootLogin" $SSH_CONFIG; then
    sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' $SSH_CONFIG
else
    echo "PermitRootLogin no" | sudo tee -a $SSH_CONFIG > /dev/null
fi

echo "    Acceso root deshabilitado."

# Permisos de Sistema de Archivos 
echo "[+] Restringiendo permisos de archivos sensibles..."

TARGET_FILE="/opt/webapp/docker-compose.yml"

if [ -f "$TARGET_FILE" ]; then
    echo "    Aplicando chmod 600 a $TARGET_FILE..."
    sudo chmod 600 "$TARGET_FILE"
    sudo chown root:root "$TARGET_FILE"
else
    echo "    [ALERTA] No se encontró $TARGET_FILE"
fi

# Asegurar los scripts propios también (700)
chmod 700 maintenance/backup.sh 2>/dev/null

echo "--- Hardening Finalizado ---"
