@echo off
setlocal

echo ========================================================
echo  Publishing A3UE Mafia PvPvEvE Extender to Steam Workshop
echo ========================================================

set SCRIPT_DIR=%~dp0
set ROOT_DIR=%SCRIPT_DIR%..
set VDF_PATH=%ROOT_DIR%\workshop_item.vdf

REM Check for SteamCMD in common locations
set STEAMCMD_EXE=""
if exist "C:\steamcmd\steamcmd.exe" set STEAMCMD_EXE="C:\steamcmd\steamcmd.exe"
if exist "%ProgramFiles(x86)%\Steam\steamcmd.exe" set STEAMCMD_EXE="%ProgramFiles(x86)%\Steam\steamcmd.exe"

if %STEAMCMD_EXE%=="" (
    where steamcmd >nul 2>nul
    if %ERRORLEVEL% equ 0 (
        set STEAMCMD_EXE=steamcmd
    )
)

if %STEAMCMD_EXE%=="" (
    echo.
    echo [!] SteamCMD not found on this system.
    echo.
    echo You can publish using one of these two methods:
    echo   Method 1 (Arma 3 Publisher GUI):
    echo     1. Open 'Arma 3 Tools' from Steam library.
    echo     2. Launch 'Publisher'.
    echo     3. Select mod folder: %ROOT_DIR%\build\@A3UE_Mafia
    echo     4. Set title, description, and preview image (%ROOT_DIR%\build\@A3UE_Mafia\preview.png).
    echo     5. Click 'Publish'.
    echo.
    echo   Method 2 (SteamCMD CLI):
    echo     Download steamcmd from https://developer.valvesoftware.com/wiki/SteamCMD
    echo     Run: steamcmd +login ^<your_username^> +workshop_build_item "%VDF_PATH%" +quit
    echo.
    pause
    exit /b 1
)

set /p STEAM_USER="Enter your Steam username: "
echo.
echo Launching SteamCMD to build and publish workshop item...
%STEAMCMD_EXE% +login %STEAM_USER% +workshop_build_item "%VDF_PATH%" +quit

echo.
echo Process complete. Check output above for the Workshop Item ID.
pause
