@echo off
setlocal
title AUSTON v3.1 - AUTONOMOUS SECURITY & PERFORMANCE DROID
cd /d "%~dp0"

:: Check for administrative permissions
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [*] Requesting Administrator privileges for AUSTON...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell.exe -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', '%~dp0auston.ps1') -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0auston.ps1" %*
if %errorlevel% neq 0 pause
