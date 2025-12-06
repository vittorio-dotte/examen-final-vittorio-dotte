#!/bin/bash



echo "--- [Fase 1] Iniciando Aprovisionamiento del Sistema ---"

# Gestión de Paquetería
echo "[+] Actualizando repositorios e instalando dependencias..."

sudo apt-get update -y
sudo apt-get install -y git curl ufw docker.io docker-compose

# Estructura de Directorios (Idempotente)
TARGET_DIR="/opt/webapp"
HTML_DIR="$TARGET_DIR/html"

echo "[+] Creando estructura de directorios en $TARGET_DIR..."
if [ ! -d "$HTML_DIR" ]; then
    sudo mkdir -p "$HTML_DIR"
    echo "    Directorios creados."
else
    echo "    Los directorios ya existen."
fi

# Obtención de Recursos (Descarga desde Gist)
GIST_URL="https://gist.githubusercontent.com/DarkestAbed/0c1cee748bb9e3b22f89efe1933bf125/raw/5801164c0a6e4df7d8ced00122c76895997127a2/docker-compose.yml"

echo "[+] Descargando docker-compose.yml..."
sudo curl -sL "$GIST_URL" -o "$TARGET_DIR/docker-compose.yml"

# Generación de Contenido
echo "[+] Generando index.html..."
CONTENT="<h1>Servidor Seguro Propiedad de Vittorio - Acceso Restringido</h1>"
echo "$CONTENT" | sudo tee "$HTML_DIR/index.html" > /dev/null

# Gestión de Identidad 
echo "[+] Configurando usuario 'sysadmin'..."
if id "sysadmin" &>/dev/null; then
    echo "    El usuario sysadmin ya existe."
else
    sudo useradd -m -s /bin/bash sysadmin
    echo "    Usuario creado."
fi

echo "[+] Agregando sysadmin al grupo docker..."
sudo usermod -aG docker sysadmin

# Despliegue del servicio 
echo "[+] Levantando servicios..."
cd "$TARGET_DIR"
sudo docker-compose up -d

echo "--- Aprovisionamiento Finalizado Exitosamente ---"
