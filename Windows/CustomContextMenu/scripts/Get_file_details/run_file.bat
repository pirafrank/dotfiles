@echo off

:: Check if a 'file' command is available
where file >nul 2>&1
if %errorlevel% neq 0 (
    echo No 'file' command is installed.
    exit /b 1
)

REM Print the first argument
file.exe %1

REM Print an empty line for better readability
echo.

REM Pause the script to keep the command window open
pause
