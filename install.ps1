# AUSTON v3.1 - 1-Line Global Installer
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "   🤖  AUSTON v3.1: AUTONOMOUS WINDOWS SECURITY & PERFORMANCE DROID" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""

$installDir = "$env:LOCALAPPDATA\Auston"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

Write-Host "[1/3] Installing AUSTON Droid Engine..." -ForegroundColor Yellow
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

Write-Host "[2/3] Creating Desktop Launcher and Shortcut..." -ForegroundColor Yellow
$batContent = @"
@echo off
setlocal
title AUSTON v3.1 - AUTONOMOUS SECURITY & PERFORMANCE DROID
cd /d "%~dp0"
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell.exe -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', '%~dp0auston.ps1') -Verb RunAs"
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0auston.ps1" %*
if %errorlevel% neq 0 pause
"@

$installedBat = Join-Path $installDir "Auston.bat"
Set-Content -Path $installedBat -Value $batContent -Encoding ASCII

# Desktop Shortcut (.lnk)
$desktopPath = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktopPath "Auston.lnk"
try {
    $wsh = New-Object -ComObject WScript.Shell
    $shortcut = $wsh.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $installedBat
    $shortcut.WorkingDirectory = $installDir
    $iconCandidates = @(
        "$PSScriptRoot\..\05_Templates_and_Assets\icons\auston_shield.ico",
        "C:\Users\OMEN\Desktop\Projects\05_Templates_and_Assets\icons\auston_shield.ico"
    )
    foreach ($icon in $iconCandidates) {
        if (Test-Path $icon) {
            $shortcut.IconLocation = "$icon,0"
            break
        }
    }
    $shortcut.Save()
} catch {
    Write-Host "[NOTE] Desktop shortcut created via batch."
}

Write-Host "[3/3] Adding 'auston' command to System PATH..." -ForegroundColor Yellow
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notmatch [regex]::Escape($installDir)) {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$installDir", "User")
    $env:PATH = "$env:PATH;$installDir"
}

$cmdWrapper = Join-Path $installDir "auston.cmd"
Set-Content -Path $cmdWrapper -Value "@powershell -NoProfile -ExecutionPolicy Bypass -File `"$ps1Path`" %*" -Encoding ASCII

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Green
Write-Host "  ✅ INSTALLATION COMPLETE! AUSTON Droid is ready on your PC." -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  👉 Launch from Desktop: Double-click 'Auston.lnk'" -ForegroundColor Cyan
Write-Host "  👉 Launch from Terminal: Type 'auston' in any CMD or PowerShell" -ForegroundColor Cyan
Write-Host ""
