@echo off
rem COSMOS dev environment installer (Windows) - double-click launcher.
rem Runs install-windows.ps1 (same folder) with the execution policy bypassed for this run only.
rem Korean messages are printed by the .ps1 itself.
chcp 65001 >nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-windows.ps1"
echo.
pause
