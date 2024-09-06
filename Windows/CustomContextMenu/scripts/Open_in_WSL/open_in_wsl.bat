@echo off
setlocal enabledelayedexpansion

REM First argument given is the Windows path to open in WSL
set "windowsPath=%~1"

REM Escape backslashes
set "escapedPath=%windowsPath:\=\\%"

REM Convert Windows path to WSL path
for /f "delims=" %%i in ('wsl wslpath "!escapedPath!"') do set "linuxPath=%%i"

REM Change directory to the WSL path and execute zsh
wsl -e bash -c "cd '!linuxPath!'; exec zsh"
