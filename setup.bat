@echo off

git clone -b feat/9-Manage_AI_requests https://github.com/statuscompliance/status-backend.git

git clone -b feature/24-Bluejay_integration https://github.com/statuscompliance/status-frontend.git

copy .env.deploy status-backend\.env

copy .env.deploy .env

:: If a folder is not created before doing a bind mount in Docker, the folder will be created with root permissions only.
md node-red-status >nul 2>&1

docker compose -p status --env-file .env up -d 

echo "Configuración completada. Visita http://localhost:3000 para ver la aplicación o http://localhost:3001/docs para acceder a la documentación de la API."
