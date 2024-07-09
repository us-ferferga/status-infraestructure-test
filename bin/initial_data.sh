#!/usr/bin/env bash

set -e

echo "_______________________INITIAL DATA_______________________"

## Wait for the server to be ready
sleep 10

curl -X GET http://localhost:3001/api/user > /dev/null 2>&1

## Create a new user
curl -X POST http://localhost:3001/api/user/signUp \
     -H "Content-Type: application/json" \
     -d "{ \"username\": \"${username}\", \"password\": \"${password}\", \"authority\": \"ADMIN\", \"email\": \"${email}\" }" > /dev/null 2>&1


## Sign in to get the access token
curl -X POST http://localhost:3001/api/user/signIn \
     -H "Content-Type: application/json" \
     -d "{ \"username\": \"${username}\", \"password\": \"${password}\" }" | jq -r '.accessToken' > /tmp/token

token=$(cat /tmp/token)
echo "Token JWT: $token"
