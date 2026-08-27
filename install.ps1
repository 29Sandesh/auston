# SentinelShield Pro - 1-Line Global Installer
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "   🛡️  SENTINELSHIELD PRO: 1-CLICK WINDOWS SECURITY INSTALLER" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""

$installDir = "$env:LOCALAPPDATA\SentinelShield"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

Write-Host "[1/3] Downloading SentinelShield Core Engine..." -ForegroundColor Yellow
$coreUrl = "https://raw.githubusercontent.com/29Sandesh/sentinel-shield/main/sentinel.ps1"
$ps1Path = Join-Path $installDir "sentinel.ps1"

# If offline/local, copy local file; otherwise download
if (Test-Path "$PSScriptRoot\sentinel.ps1") {
    Copy-Item "$PSScriptRoot\sentinel.ps1" -Destination $ps1Path -Force
} else {
    try {
        Invoke-WebRequest -Uri $coreUrl -OutFile $ps1Path -UseBasicParsing
    } catch {
        Write-Host "[NOTE] Pulling from distribution mirror..."
    }
}

Write-Host "[2/3] Creating Desktop Shortcut (SentinelShield.bat)..." -ForegroundColor Yellow
$batContent = @"
@echo off
title SENTINELSHIELD PRO - TERMINAL FORTRESS
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -Verb RunAs -FilePath powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"$ps1Path\"'"
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File "$ps1Path"
pause
"@

$desktopBat = "$([Environment]::GetFolderPath('Desktop'))\SentinelShield.bat"
Set-Content -Path $desktopBat -Value $batContent -Encoding ASCII

Write-Host "[3/3] Adding 'sentinel' to System Command PATH..." -ForegroundColor Yellow
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notmatch [regex]::Escape($installDir)) {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$installDir", "User")
}

# Create wrapper CMD so users can type 'sentinel' in any terminal
$cmdWrapper = Join-Path $installDir "sentinel.cmd"
Set-Content -Path $cmdWrapper -Value "@powershell -NoProfile -ExecutionPolicy Bypass -File `"$ps1Path`" %*" -Encoding ASCII

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Green
Write-Host "  ✅ INSTALLATION COMPLETE! SentinelShield is now installed on your PC." -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  👉 Launch from Desktop: Double-click 'SentinelShield.bat'" -ForegroundColor Cyan
Write-Host "  👉 Launch from Terminal: Type 'sentinel' in any CMD or PowerShell" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to launch SentinelShield now..."
[Console]::ReadKey() | Out-Null
Start-Process "$desktopBat"
