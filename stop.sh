#!/usr/bin/env bash

echo "Stopping containers..."

source bin/cross_platform_utils.sh

docker compose -f $(getDockerCompose) --env-file ../.env down
