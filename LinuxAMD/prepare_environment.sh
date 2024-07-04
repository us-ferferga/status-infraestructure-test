#!/bin/bash

## Compare versions
version_greater_equal() {
    printf '%s\n%s' "$2" "$1" | sort -C -V
}

## Check if Docker is installed
docker_version=$(docker --version | awk '{print $3}' | sed 's/,//')
required_version="21.0.0"

if version_greater_equal "$docker_version" "$required_version"; then
    echo "Docker version: $docker_version (sufficient)"
else
    echo "Docker version: $docker_version (insufficient). At least version $required_version is required."
    exit 1
fi

## Clean up previous installations
directories=("status-backend" "status-frontend" "node-red-status" "mysql" "collector-events")

for dir in "${directories[@]}"; do
    if [ -d "../$dir" ]; then
        echo "Deleting $dir..."
        rm -rf "../$dir"
    fi
done


## Clone repositories

echo "_______________________CLONING REPOSITORIES_______________________"

git clone -b feat/9-Manage_AI_requests https://github.com/statuscompliance/status-backend.git ../status-backend

git clone -b feature/24-Bluejay_integration https://github.com/statuscompliance/status-frontend.git ../status-frontend

git clone https://github.com/statuscompliance/collector-events.git ../collector-events

cp ../.env.deploy ../status-backend/.env

cp ../.env.deploy ../.env

## If a folder is not created before doing a bind mount in Docker, the folder will be created with root permissions only.
mkdir -p ../node-red-status

## If a settings.js file exists, delete it and create a new one from settings_template.js
if [ -f "../settings.js" ]; then
    echo "Deleting settings.js..."
    rm ../settings.js
fi

cp ../settings_template.js ../settings.js

## Create a new user and password for Node-RED

echo "_______________________CREATE YOUR USER_______________________"
read -p "Enter a new username: " username
read -s -p "Enter a new password: " password
echo
read -p "Enter your email: " email
echo # newline

## Save username and password as environment variables

echo "$username" > /tmp/user_data
echo "$password" >> /tmp/user_data
echo "$email" >> /tmp/user_data

if ! npm list -g bcrypt; then
    npm install -g bcrypt
fi

hashed_password=$(node -e "console.log(require('bcrypt').hashSync(process.argv[1], 10));" "$password")
escaped_hashed_password=$(printf '%s\n' "$hashed_password" | sed -e 's/[\/&]/\\&/g')

## Replace the example_user and example_pass strings with the new user and password

sed -i '' -e "s/\"example_user\"/\"$username\"/g" ../settings.js
sed -i '' -e "s/\"example_pass\"/\"$escaped_hashed_password\"/g" ../settings.js

echo "Node-RED user created successfully."