@echo off
setlocal

REM Check whether a file path was provided
if "%~1"=="" (
    echo Usage: %~nx0 "path\to\file"
    exit /b 1
)

REM Check whether the file exists
if not exist "%~1" (
    echo File not found: "%~1"
    exit /b 1
)

REM Copy the file contents to the Windows clipboard
clip < "%~1"

if errorlevel 1 (
    echo Failed to copy the file contents to the clipboard.
    exit /b 1
)

echo Contents of "%~1" copied to the clipboard.

endlocal
