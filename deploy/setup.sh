#!/bin/bash

echo "--- Iniciando Aprovisionamiento ---"

# 1. Crear index.html (Corrección: especificar el archivo, no solo la carpeta)
echo "<h1>Examen Final - Vittorio - Despliegue Exitoso</h1>" > deploy/index.html

# 2. Levantar contenedor (Corrección: sintaxis estricta de docker-compose)
echo "Levantando contenedor Nginx..."
docker-compose -f deploy/docker-compose.yml up -d

echo "--- Aprovisionamiento Completado ---"
echo "Verifica el acceso en: http://localhost:8080"
