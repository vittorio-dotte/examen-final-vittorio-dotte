#!/bin/bash

echo "--- Iniciando despliegue (Artefacto 4.1) ---"

# Crear estructura de carpetas 
mkdir -p deploy/html

#  Crear index.html 
echo "<h1>Examen Final - Vittorio - Despliegue Exitoso</h1>" > deploy/html/index.html

#  Levantar el contenedor
echo "Levantando Docker Compose..."
docker-compose -f deploy/docker-compose.yml up -d --force-recreate

if [ $? -eq 0 ]; then
    echo "¡Listo! Servicio 'production_web' activo."
else
    echo "ERROR: Docker falló."
    exit 1
fi
