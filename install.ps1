# AUSTON v3.0 - 1-Line Global Installer
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "   🤖  AUSTON v3.0: AUTONOMOUS WINDOWS SECURITY & PERFORMANCE DROID" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""

$installDir = "$env:LOCALAPPDATA\Auston"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

Write-Host "[1/3] Downloading AUSTON Droid Engine..." -ForegroundColor Yellow
$coreUrl = "https://raw.githubusercontent.com/29Sandesh/auston/main/auston.ps1"
$ps1Path = Join-Path $installDir "auston.ps1"

if (Test-Path "$PSScriptRoot\auston.ps1") {
    Copy-Item "$PSScriptRoot\auston.ps1" -Destination $ps1Path -Force
} else {
    try {
        Invoke-WebRequest -Uri $coreUrl -OutFile $ps1Path -UseBasicParsing
    } catch {
        Write-Host "[NOTE] Pulling from repository..."
    }
}

Write-Host "[2/3] Creating Desktop Shortcut (Auston.bat)..." -ForegroundColor Yellow
$batContent = @"
@echo off
title AUSTON v3.0 - SECURITY & PERFORMANCE DROID
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -Verb RunAs -FilePath powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "$ps1Path"'"
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File "$ps1Path"
pause
"@

$desktopBat = "$([Environment]::GetFolderPath('Desktop'))\Auston.bat"
Set-Content -Path $desktopBat -Value $batContent -Encoding ASCII

Write-Host "[3/3] Adding 'auston' command to System PATH..." -ForegroundColor Yellow
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notmatch [regex]::Escape($installDir)) {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$installDir", "User")
}

$cmdWrapper = Join-Path $installDir "auston.cmd"
Set-Content -Path $cmdWrapper -Value "@powershell -NoProfile -ExecutionPolicy Bypass -File `"$ps1Path`" %*" -Encoding ASCII

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Green
Write-Host "  ✅ INSTALLATION COMPLETE! AUSTON Droid is installed on your PC." -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  👉 Launch from Desktop: Double-click 'Auston.bat'" -ForegroundColor Cyan
Write-Host "  👉 Launch from Terminal: Type 'auston' in any CMD or PowerShell" -ForegroundColor Cyan
Write-Host ""
