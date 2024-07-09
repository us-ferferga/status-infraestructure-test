#!/usr/bin/env bash

echo "Starting the containers..."

source bin/cross_platform_utils.sh

setupCrossPlatformEnvironment

docker compose -f $(getDockerCompose) --env-file ../.env up -d --wait
