@echo off

REM Function to compare versions
:version_greater_equal
setlocal EnableDelayedExpansion
set "ver1=%~1"
set "ver2=%~2"
for /f "tokens=1,2,3 delims=." %%a in ("%ver1%") do (
    set "v1_maj=%%a"
    set "v1_min=%%b"
    set "v1_pat=%%c"
)
for /f "tokens=1,2,3 delims=." %%a in ("%ver2%") do (
    set "v2_maj=%%a"
    set "v2_min=%%b"
    set "v2_pat=%%c"
)
if !v1_maj! gtr !v2_maj! ( exit /b 0 )
if !v1_maj! lss !v2_maj! ( exit /b 1 )
if !v1_min! gtr !v2_min! ( exit /b 0 )
if !v1_min! lss !v2_min! ( exit /b 1 )
if !v1_pat! gtr !v2_pat! ( exit /b 0 )
if !v1_pat! lss !v2_pat! ( exit /b 1 )
exit /b 0

REM Check if Docker is installed
for /f "tokens=3 delims= " %%i in ('docker --version') do set docker_version=%%i
set docker_version=%docker_version:,=%

set required_version=21.0.0

call :version_greater_equal %docker_version% %required_version%
if %errorlevel% neq 0 (
    echo Docker version: %docker_version% (insufficient). At least version %required_version% is required.
    exit /b 1
) else (
    echo Docker version: %docker_version% (sufficient)
)

REM Clean up previous installations
set directories=status-backend status-frontend node-red-status mysql collector-events

for %%d in (%directories%) do (
    if exist ..\%%d (
        echo Deleting %%d...
        rmdir /s /q ..\%%d
    )
)

REM Clone repositories

echo _______________________CLONING REPOSITORIES_______________________

git clone -b feat/9-Manage_AI_requests https://github.com/statuscompliance/status-backend.git ..\status-backend
git clone -b feature/24-Bluejay_integration https://github.com/statuscompliance/status-frontend.git ..\status-frontend
git clone https://github.com/statuscompliance/collector-events.git ..\collector-events

copy ..\.env.deploy ..\status-backend\.env
copy ..\.env.deploy ..\.env

REM If a folder is not created before doing a bind mount in Docker, the folder will be created with root permissions only.
if not exist ..\node-red-status mkdir ..\node-red-status

REM If a settings.js file exists, delete it and create a new one from settings_template.js
if exist ..\settings.js (
    echo Deleting settings.js...
    del ..\settings.js
)

copy ..\settings_template.js ..\settings.js

REM Create a new user and password for Node-RED

echo _______________________CREATE YOUR USER_______________________
set /p username=Enter a new username: 
set /p password=Enter a new password: 
echo.
set /p email=Enter your email: 
echo.

REM Save username and password as environment variables

echo %username% > %temp%\user_data
echo %password% >> %temp%\user_data
echo %email% >> %temp%\user_data

npm list -g bcrypt >nul 2>&1
if %errorlevel% neq 0 (
    npm install -g bcrypt
)

for /f "delims=" %%i in ('node -e "console.log(require('bcrypt').hashSync(process.argv[1], 10));" "%password%"') do set hashed_password=%%i
setlocal disabledelayedexpansion
set "escaped_hashed_password=%hashed_password:/=\/%"
set "escaped_hashed_password=%escaped_hashed_password:&=\&%"
setlocal enabledelayedexpansion

REM Replace the example_user and example_pass strings with the new user and password

powershell -Command "(gc ..\settings.js) -replace '\"example_user\"', '\"%username%\"' | Out-File -encoding ASCII ..\settings.js"
powershell -Command "(gc ..\settings.js) -replace '\"example_pass\"', '\"!escaped_hashed_password!\"' | Out-File -encoding ASCII ..\settings.js"

echo Node-RED user created successfully.
