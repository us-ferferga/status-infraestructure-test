@echo off

REM Read user data from temporary file
setlocal enabledelayedexpansion
set /p username=<%temp%\user_data
set /p password=<%temp%\user_data
set /p email=<%temp%\user_data
endlocal

echo _______________________INITIAL DATA_______________________

REM Wait for the server to be ready
timeout /t 10 /nobreak >nul

curl -X GET http://localhost:3001/api/user >nul 2>&1

REM Create a new user
curl -X POST http://localhost:3001/api/user/signUp ^
     -H "Content-Type: application/json" ^
     -d "{ \"username\": \"%username%\", \"password\": \"%password%\", \"authority\": \"ADMIN\", \"email\": \"%email%\" }" >nul 2>&1

REM Sign in to get the access token
curl -X POST http://localhost:3001/api/user/signIn ^
     -H "Content-Type: application/json" ^
     -d "{ \"username\": \"%username%\", \"password\": \"%password%\" }" | jq -r ".accessToken" > %temp%\token

set /p token=<%temp%\token
echo Token JWT: %token%

del %temp%\user_data
del %temp%\token
