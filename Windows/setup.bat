@echo off

echo.
echo                            WELCOME TO 
echo "  ______   _________     _     _________  _____  _____   ______   "
echo ".' ____ \ |  _   _  |   / \   |  _   _  ||_   _||_   _|.' ____ \  "
echo "| (___ \_||_/ | | \_|  / _ \  |_/ | | \_|  | |    | |  | (___ \_| "
echo " _.____`.     | |     / ___ \     | |      | '    ' |   _.____`.  "
echo "| \____) |   _| |_  _/ /   \ \_  _| |_      \ \__/ /   | \____) | "
echo " \______.'  |_____||____| |____||_____|      `.__.'     \______.' "
echo.

REM Define the scripts to be executed
set prepare_script=prepare_environment.bat
set start_script=start.bat
set data_script=initial_data.bat

REM Function to execute a script
:execute_script
set script_name=%1
if exist %script_name% (
    echo Executing %script_name%...
    call %script_name%
    if errorlevel 1 (
        echo Error occurred while executing %script_name%
        exit /b 1
    )
) else (
    echo The script %script_name% does not exist.
    exit /b 1
)
goto :eof

REM Step 1: Prepare the environment
call :execute_script %prepare_script%

REM Step 2: Build and start the containers
call :execute_script %start_script%

REM Step 3: Insert initial data
call :execute_script %data_script%

echo Infrastructure up and running successfully.
echo You can access the application at http://localhost:3000/login
