#!/bin/bash


cat << "EOF"
                            WELCOME TO 
  ______   _________     _     _________  _____  _____   ______   
.' ____ \ |  _   _  |   / \   |  _   _  ||_   _||_   _|.' ____ \  
| (___ \_||_/ | | \_|  / _ \  |_/ | | \_|  | |    | |  | (___ \_| 
 _.____`.     | |     / ___ \     | |      | '    ' |   _.____`.  
| \____) |   _| |_  _/ /   \ \_  _| |_      \ \__/ /   | \____) | 
 \______.'  |_____||____| |____||_____|      `.__.'     \______.' 
                                                                                                    
EOF

                                                       
## Define the scripts to be executed
prepare_script="prepare_environment.sh"
start_script="start_containers.sh"
data_script="initial_data.sh"

## Function to execute a script
execute_script() {
    script_name=$1
    if [ -f "$script_name" ]; then
        echo "Executing $script_name..."
        bash $script_name
        if [ $? -ne 0 ]; then
            echo "Error occurred while executing $script_name" 
            exit 1
        fi
    else
        echo "The script $script_name does not exist."
        exit 1
    fi
}


## Step 1: Prepare the environment
execute_script $prepare_script

## Step 2: Build and start the containers
execute_script $start_script

## Step 3: Insert initial data
execute_script $data_script


echo "Infrastucture up and running successfully."
echo "You can access the application at http://localhost:3000/login"