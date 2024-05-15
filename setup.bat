@echo off

git clone -b feat/9-Manage_AI_requests https://github.com/statuscompliance/status-backend.git

git clone -b feature/22-Create_initial_chatbot https://github.com/statuscompliance/status-frontend.git

copy .env.deploy status-backend\.env

copy .env.deploy .env

docker-compose -p status up -d

echo "Configuración completada. Visita http://localhost:3000 para ver la aplicación o http://localhost:3001/docs para acceder a la documentación de la API."