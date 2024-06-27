#!/bin/bash

git clone -b feat/9-Manage_AI_requests https://github.com/statuscompliance/status-backend.git

git clone -b feature/24-Bluejay_integration https://github.com/statuscompliance/status-frontend.git

cp .env.deploy ./status-backend/.env

cp .env.deploy .env

## If a folder is not created before doing a bind mount in Docker, the folder will be created with root permissions only.
mkdir -p node-red-status

docker compose -p status up -d 

echo "Setup completado. Accede a http://localhost:3000 para ver la aplicación o a http://localhost:3001/docs para acceder a la documentación de la API."
