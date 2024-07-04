#!/bin/bash

echo "Stopping containers..."

docker stop $(docker ps -aq)