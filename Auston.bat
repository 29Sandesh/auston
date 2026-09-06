@echo off
title AUSTON v3.0 - SECURITY & PERFORMANCE DROID
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command  Start-Process -Verb RunAs -FilePath powershell.exe -ArgumentList -NoProfile -ExecutionPolicy Bypass -File ""C:\Users\OMEN\Desktop\Projects\03_AI_and_Automation\auston\auston.ps1"" 
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File  C:\Users\OMEN\Desktop\Projects\03_AI_and_Automation\auston\auston.ps1
pause
