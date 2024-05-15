#!/bin/bash

git clone -b feat/9-Manage_AI_requests https://github.com/statuscompliance/status-backend.git

git clone -b feature/22-Create_initial_chatbot https://github.com/statuscompliance/status-frontend.git

cp .env.deploy ./status-backend/.env

cp .env.deploy .env

docker-compose -p status up -d 

echo "Setup completado. Accede a http://localhost:3000 para ver la aplicación o a http://localhost:3001/docs para acceder a la documentación de la API."
