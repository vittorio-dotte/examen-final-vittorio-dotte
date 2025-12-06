#!/bin/bash

echo "-Iniciando hardening de seguridad -"

# configuración de (UFW)
# Permitir SSH (22) y el puerto (8080)
echo "[+] Configurando reglas de Firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 8080/tcp


echo " Reglas aplicadas. Estado actual:"
sudo ufw status verbose

# Hardening de SSH (Deshabilitar Root)
echo " Asegurando configuración SSH..."
SSH_CONFIG="/etc/ssh/sshd_config"

#  backup 
sudo cp $SSH_CONFIG "$SSH_CONFIG.bak"

# sed para cambiar PermitRootLogin yes/prohibit-password a 'no'
if grep -q "PermitRootLogin" $SSH_CONFIG; then
    sudo sed -i 's/^.*PermitRootLogin.*/PermitRootLogin no/' $SSH_CONFIG
else
    echo "PermitRootLogin no" | sudo tee -a $SSH_CONFIG
fi

echo " Login de Root deshabilitado."
echo "- Hardening Finalizado -"
