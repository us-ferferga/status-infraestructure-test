#!/bin/bash

echo "Starting the containers..."

docker compose -f ../docker-compose-ARM.yml -p status --env-file ../.env up -d