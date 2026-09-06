@echo off
rem COSMOS dev environment checker (Windows) - double-click launcher.
rem Prefers PowerShell 7 (pwsh) if installed, otherwise falls back to Windows PowerShell 5.1.
chcp 65001 >nul
where pwsh >nul 2>&1
if %errorlevel%==0 (
  pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0check-windows.ps1"
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0check-windows.ps1"
)
echo.
pause
