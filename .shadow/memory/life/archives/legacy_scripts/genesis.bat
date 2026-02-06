@echo off
setlocal

:: Get the directory of this script
set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%genesis.ps1"

:: Check if arguments are provided (Simple check for 2 arguments)
if "%~1"=="" goto :Interactive
if "%~2"=="" goto :Interactive

:: Arguments provided, assume 1st is Dir, 2nd is Name
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" -TargetDirectory "%~1" -ProjectName "%~2"
goto :End

:Interactive
echo ==========================================
echo       SHADOW AGENT GENESIS PROTOCOL
echo ==========================================
echo.
echo No arguments detected. Entering interactive mode.
echo.

:AskDir
set /p "TARGET_DIR=Title: Enter Target Directory (Full Path): "
if "%TARGET_DIR%"=="" goto :AskDir

:AskName
set /p "PROJ_NAME=Title: Enter Project Name: "
if "%PROJ_NAME%"=="" goto :AskName

echo.
echo Initializing Shadow Protocol...
echo Target:  %TARGET_DIR%
echo Project: %PROJ_NAME%
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" -TargetDirectory "%TARGET_DIR%" -ProjectName "%PROJ_NAME%"
echo.
echo [Genesis Complete]
pause
goto :End

:End
endlocal
