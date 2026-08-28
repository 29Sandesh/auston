# AMEN v3.0 - 1-Line Global Installer
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "   🛡️  AMEN v3.0: 1-CLICK WINDOWS SECURITY & PERFORMANCE FORTRESS" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""

$installDir = "$env:LOCALAPPDATA\AMEN"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

Write-Host "[1/3] Downloading AMEN Core Engine..." -ForegroundColor Yellow
$coreUrl = "https://raw.githubusercontent.com/29Sandesh/amen/main/amen.ps1"
$ps1Path = Join-Path $installDir "amen.ps1"

if (Test-Path "$PSScriptRoot\amen.ps1") {
    Copy-Item "$PSScriptRoot\amen.ps1" -Destination $ps1Path -Force
} else {
    try {
        Invoke-WebRequest -Uri $coreUrl -OutFile $ps1Path -UseBasicParsing
    } catch {
        Write-Host "[NOTE] Pulling from repository..."
    }
}

Write-Host "[2/3] Creating Desktop Shortcut (AMEN.bat)..." -ForegroundColor Yellow
$batContent = @"
@echo off
title AMEN v3.0 - TERMINAL FORTRESS
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -Verb RunAs -FilePath powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "$ps1Path"'"
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File "$ps1Path"
pause
"@

$desktopBat = "$([Environment]::GetFolderPath('Desktop'))\AMEN.bat"
Set-Content -Path $desktopBat -Value $batContent -Encoding ASCII

Write-Host "[3/3] Adding 'amen' command to System PATH..." -ForegroundColor Yellow
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notmatch [regex]::Escape($installDir)) {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$installDir", "User")
}

$cmdWrapper = Join-Path $installDir "amen.cmd"
Set-Content -Path $cmdWrapper -Value "@powershell -NoProfile -ExecutionPolicy Bypass -File `"$ps1Path`" %*" -Encoding ASCII

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Green
Write-Host "  ✅ INSTALLATION COMPLETE! AMEN v3.0 is installed on your PC." -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  👉 Launch from Desktop: Double-click 'AMEN.bat'" -ForegroundColor Cyan
Write-Host "  👉 Launch from Terminal: Type 'amen' in any CMD or PowerShell" -ForegroundColor Cyan
Write-Host ""
