@echo off

echo "Stopping containers..."

docker stop $(docker ps -aq)