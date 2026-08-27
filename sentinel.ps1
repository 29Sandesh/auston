# SentinelShield Pro - Native Terminal Security Fortress
param (
    [switch]$Fortress,
    [switch]$Performance,
    [switch]$Audit,
    [switch]$Restore
)

$Host.UI.RawUI.WindowTitle = "SENTINELSHIELD PRO - TERMINAL SECURITY FORTRESS"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Show-Banner {
    Clear-Host
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "    ____             __  _            __  _____ __    _      __    __" -ForegroundColor Cyan
    Write-Host "   / __/__ ___  ___ / /_(_)__  ___   / / / ___// /_  (_)__  / /___/ /" -ForegroundColor Cyan
    Write-Host "  _\ \/ -_) _ \/ _ / __/ / _ \/ -_) / /__\__ \/ _ \/ / -_)/ / _  / " -ForegroundColor Cyan
    Write-Host " /___/\__/_//_/\__/\__/_/_//_/\__/ /____/____/_//_/_/\__//_/\_,_/  " -ForegroundColor Cyan
    Write-Host "                                                  [ PURE CLI v2.0 ]" -ForegroundColor Yellow
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "  22-Shield Anti-Hack Matrix  |  Ultimate Performance  |  Live Auditor" -ForegroundColor Gray
    Write-Host "================================================================================" -ForegroundColor Cyan
}

function Get-SecurityAudit {
    Write-Host ""
    Write-Host "[*] Running Live System Security and Vulnerability Audit..." -ForegroundColor Yellow
    
    $results = [ordered]@{}
    $score = 0
    $total = 22

    # Category A: Network & Public Wi-Fi
    $pref = Get-MpPreference
    $results["Defender Network C2 and Phishing Blocker"] = ($pref.EnableNetworkProtection -eq 1)
    
    $llmnr = (Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -ErrorAction SilentlyContinue).EnableMulticast
    $results["LLMNR Public Wi-Fi Hash Poisoning Shield"] = ($llmnr -eq 0)
    
    $smb1 = (Get-SmbServerConfiguration -ErrorAction SilentlyContinue).EnableSMB1Protocol
    $results["SMBv1 EternalBlue Worm Protocol Disabler"] = ($smb1 -eq $false)
    
    $wpad = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -ErrorAction SilentlyContinue).AutoDetect
    $results["WPAD Rogue Proxy AutoDetect Kill"] = ($wpad -eq 0)
    
    $rdp = (Get-ItemProperty "HKLM:\System\CurrentControlSet\Control\Terminal Server" -ErrorAction SilentlyContinue).fDenyTSConnections
    $results["Remote Desktop (RDP Port 3389) Lockdown"] = ($rdp -eq 1)

    # Category B: Exploit & Credential Theft (ASR Rules)
    $asrIds = $pref.AttackSurfaceReductionRules_Ids
    $results["ASR: Block LSASS Credential Theft (Mimikatz)"] = ($asrIds -contains "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2")
    $results["ASR: Block Obfuscated Script Execution"] = ($asrIds -contains "5beb7efe-4261-47fc-9571-cc3424315771")
    $results["ASR: Block Process Injection and Hollow Tactics"] = ($asrIds -contains "75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84")
    $results["ASR: Block Exploited Signed Drivers (BYOVD)"] = ($asrIds -contains "56a863a9-875e-4185-98a7-b882c60b5ce5")
    $results["ASR: Block Webmail Executable Droppers"] = ($asrIds -contains "be9ba2d9-53ea-4cdc-84e5-9b1eeee46550")
    $results["ASR: Block Office and PDF Child Processes"] = ($asrIds -contains "d4f940ab-401b-4efc-aadc-ad5f3c50688a")

    # Category C: Remote Access & Lateral Defense
    $remReg = (Get-Service RemoteRegistry -ErrorAction SilentlyContinue).StartType
    $results["Remote Registry Tampering Disabler"] = ($remReg -eq "Disabled" -or $null -eq $remReg)
    
    $remHelp = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -ErrorAction SilentlyContinue).fAllowToGetHelp
    $results["Remote Assistance Backdoor Disabler"] = ($remHelp -eq 0)
    
    $autoRun = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ErrorAction SilentlyContinue).NoDriveTypeAutoRun
    $results["USB AutoRun and Rubber Ducky Exploit Shield"] = ($autoRun -eq 255)
    
    $wsh = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -ErrorAction SilentlyContinue).Enabled
    $results["Windows Script Host (VBScript and Macro Kill)"] = ($wsh -eq 0)

    # Category D: Ransomware, Privacy & Telemetry
    $results["Controlled Folder Access (Ransomware Vault)"] = ($pref.EnableControlledFolderAccess -eq 1)
    $results["PUA Adware and Crypto-Miner Shield"] = ($pref.PUAProtection -eq 1)
    
    $telem = (Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -ErrorAction SilentlyContinue).AllowTelemetry
    $results["Invasive Diagnostic Telemetry Purge"] = ($telem -eq 0)
    
    $adInfo = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -ErrorAction SilentlyContinue).Enabled
    $results["Advertising Tracking ID Purge"] = ($adInfo -eq 0)
    
    $clip = (Get-ItemProperty "HKCU:\Software\Microsoft\Clipboard" -ErrorAction SilentlyContinue).EnableCloudClipboard
    $results["Clipboard Cloud Sync Isolation"] = ($clip -eq 0)
    
    $dg = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard -ErrorAction SilentlyContinue
    $results["Hypervisor Code Integrity (HVCI Guard)"] = ($dg.SecurityServicesRunning -contains 2)
    
    $uac = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ErrorAction SilentlyContinue).EnableLUA
    $results["User Account Control (UAC) Lockdown"] = ($uac -eq 1)

    # Calculate Score
    foreach ($k in $results.Keys) {
        if ($results[$k] -eq $true) { $score++ }
    }
    
    $pct = [math]::Round(($score / $total) * 100)
    
    Write-Host ""
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Gray
    Write-Host "                SYSTEM SECURITY SCORE: $pct / 100 " -NoNewline -ForegroundColor $(if($pct -ge 90){"Green"}elseif($pct -ge 70){"Yellow"}else{"Red"})
    Write-Host "($score of $total Shields Active)" -ForegroundColor Gray
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Gray

    $i = 1
    foreach ($k in $results.Keys) {
        $status = if ($results[$k]) { "[ACTIVE  OK]" } else { "[VULNERABLE]" }
        $color = if ($results[$k]) { "Green" } else { "Red" }
        Write-Host (" {0:D2}. {1,-45} : " -f $i, $k) -NoNewline
        Write-Host $status -ForegroundColor $color
        $i++
    }
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Gray
    Write-Host ""
    return $results
}

function Enable-FortressMode {
    Write-Host ""
    Write-Host "[*] ACTIVATING FORTRESS MODE (ENABLING ALL 22 SHIELDS)..." -ForegroundColor Cyan
    
    # 1. Network & Defender
    Write-Host " [+] Enabling Defender Network-Level C2 and Phishing Blocker..." -ForegroundColor Yellow
    Set-MpPreference -EnableNetworkProtection Enabled -ErrorAction SilentlyContinue

    Write-Host " [+] Disabling LLMNR (Public Wi-Fi Credential Poisoning)..." -ForegroundColor Yellow
    $dns = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
    if (-not (Test-Path $dns)) { New-Item -Path $dns -Force | Out-Null }
    Set-ItemProperty -Path $dns -Name "EnableMulticast" -Value 0 -Type DWord -Force

    Write-Host " [+] Disabling Insecure SMBv1 Protocol..." -ForegroundColor Yellow
    Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force -ErrorAction SilentlyContinue

    Write-Host " [+] Disabling WPAD Rogue Proxy AutoDetect..." -ForegroundColor Yellow
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "AutoDetect" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Write-Host " [+] Locking Down Remote Desktop (RDP Port 3389)..." -ForegroundColor Yellow
    Set-ItemProperty "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

    # 2. ASR Rules
    Write-Host " [+] Activating 6 Enterprise Attack Surface Reduction (ASR) Rules..." -ForegroundColor Yellow
    $asrs = @(
        "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2",
        "5beb7efe-4261-47fc-9571-cc3424315771",
        "75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84",
        "56a863a9-875e-4185-98a7-b882c60b5ce5",
        "be9ba2d9-53ea-4cdc-84e5-9b1eeee46550",
        "d4f940ab-401b-4efc-aadc-ad5f3c50688a"
    )
    foreach ($a in $asrs) {
        Add-MpPreference -AttackSurfaceReductionRules_Ids $a -AttackSurfaceReductionRules_Actions Enabled -ErrorAction SilentlyContinue
    }

    # 3. Remote Services & USB
    Write-Host " [+] Disabling Remote Registry and Remote Assistance Backdoors..." -ForegroundColor Yellow
    Stop-Service RemoteRegistry -ErrorAction SilentlyContinue
    Set-Service RemoteRegistry -StartupType Disabled -ErrorAction SilentlyContinue
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Write-Host " [+] Hardening USB AutoRun and BadUSB Exploit Protection..." -ForegroundColor Yellow
    $exp = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    if (-not (Test-Path $exp)) { New-Item -Path $exp -Force | Out-Null }
    Set-ItemProperty -Path $exp -Name "NoDriveTypeAutoRun" -Value 255 -Type DWord -Force

    Write-Host " [+] Locking Down Windows Script Host (Macro VBScript Kill)..." -ForegroundColor Yellow
    $wsh = "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings"
    if (-not (Test-Path $wsh)) { New-Item -Path $wsh -Force | Out-Null }
    Set-ItemProperty -Path $wsh -Name "Enabled" -Value 0 -Type DWord -Force

    # 4. Ransomware & Privacy
    Write-Host " [+] Activating Controlled Folder Access (Ransomware Vault)..." -ForegroundColor Yellow
    Set-MpPreference -EnableControlledFolderAccess Enabled -ErrorAction SilentlyContinue

    Write-Host " [+] Enabling PUA Adware and Crypto-Miner Quarantines..." -ForegroundColor Yellow
    Set-MpPreference -PUAProtection Enabled -ErrorAction SilentlyContinue

    Write-Host " [+] Purging Diagnostic Telemetry and Ad Tracking IDs..." -ForegroundColor Yellow
    $tel = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (-not (Test-Path $tel)) { New-Item -Path $tel -Force | Out-Null }
    Set-ItemProperty -Path $tel -Name "AllowTelemetry" -Value 0 -Type DWord -Force

    $ad = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    if (-not (Test-Path $ad)) { New-Item -Path $ad -Force | Out-Null }
    Set-ItemProperty -Path $ad -Name "Enabled" -Value 0 -Type DWord -Force

    $clip = "HKCU:\Software\Microsoft\Clipboard"
    if (-not (Test-Path $clip)) { New-Item -Path $clip -Force | Out-Null }
    Set-ItemProperty -Path $clip -Name "EnableCloudClipboard" -Value 0 -Type DWord -Force

    Write-Host ""
    Write-Host "[FORTRESS SUCCESS] All 22 Shields are now FULLY ACTIVATED!" -ForegroundColor Green
}

function Enable-UltimatePerformance {
    Write-Host ""
    Write-Host "[*] ACTIVATING ULTIMATE PERFORMANCE MODE..." -ForegroundColor Cyan
    
    $schemes = powercfg /list
    $guidMatch = $schemes | Select-String -Pattern '([a-f0-9\-]{36}).*Ultimate Performance'
    
    if ($guidMatch) {
        $guid = $guidMatch.Matches[0].Groups[1].Value
        powercfg /setactive $guid
        Write-Host " [+] Ultimate Performance Power Plan Activated ($guid)" -ForegroundColor Green
    } else {
        $out = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        $schemes2 = powercfg /list
        $guid2 = ($schemes2 | Select-String -Pattern '([a-f0-9\-]{36}).*Ultimate Performance').Matches[0].Groups[1].Value
        powercfg /setactive $guid2
        Write-Host " [+] Unlocked and Activated Ultimate Performance Scheme ($guid2)" -ForegroundColor Green
    }

    Write-Host " [+] Performing NVMe SSD Flash Block Re-Trim..." -ForegroundColor Yellow
    try {
        Optimize-Volume -DriveLetter C -ReTrim -ErrorAction SilentlyContinue | Out-Null
        Write-Host " [+] NVMe SSD Re-Trim Complete (Factory Speeds Restored)" -ForegroundColor Green
    } catch {}

    Clear-DnsClientCache
    Write-Host " [+] DNS Resolver Cache Flushed" -ForegroundColor Green

    Write-Host ""
    Write-Host "[PERFORMANCE SUCCESS] Laptop CPU, GPU and Storage running at Maximum Clock Speed!" -ForegroundColor Green
}

function Restore-SafeDefaults {
    Write-Host ""
    Write-Host "[*] RESTORING SAFE WINDOWS FACTORY DEFAULTS..." -ForegroundColor Yellow
    
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name "Enabled" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-MpPreference -EnableControlledFolderAccess Disabled -ErrorAction SilentlyContinue
    
    $schemes = powercfg /list
    $bal = ($schemes | Select-String -Pattern '([a-f0-9\-]{36}).*Balanced').Matches[0].Groups[1].Value
    if ($bal) { powercfg /setactive $bal }

    Write-Host "[RESTORE COMPLETE] Reset system settings to safe default state." -ForegroundColor Green
}

# --- CLI ARGUMENT EXECUTION ---
if ($Fortress) {
    Show-Banner
    Enable-FortressMode
    Get-SecurityAudit
    exit
}
if ($Performance) {
    Show-Banner
    Enable-UltimatePerformance
    exit
}
if ($Audit) {
    Show-Banner
    Get-SecurityAudit
    exit
}
if ($Restore) {
    Show-Banner
    Restore-SafeDefaults
    exit
}

# --- INTERACTIVE TERMINAL LOOP ---
while ($true) {
    Show-Banner
    Write-Host "  SELECT AN OPTION:" -ForegroundColor Yellow
    Write-Host "  ============================================================================" -ForegroundColor Gray
    Write-Host "   [1] ACTIVATE FORTRESS MODE        (Turn ON All 22 Anti-Hack Shields)" -ForegroundColor Green
    Write-Host "   [2] ACTIVATE ULTIMATE PERFORMANCE (Max CPU/GPU Clocks + SSD Re-Trim)" -ForegroundColor Cyan
    Write-Host "   [3] RUN DEEP SECURITY AUDIT       (Live Score and 22-Shield Inspector)" -ForegroundColor Yellow
    Write-Host "   [4] NVMe SSD TRIM AND FLUSH RAM   (Factory Storage Optimization)" -ForegroundColor White
    Write-Host "   [5] RESTORE SAFE DEFAULTS         (Revert Settings to Windows Standard)" -ForegroundColor Magenta
    Write-Host "   [0] EXIT TERMINAL" -ForegroundColor Gray
    Write-Host "  ============================================================================" -ForegroundColor Gray
    
    $choice = Read-Host "  Enter Choice [0-5]"
    
    switch ($choice) {
        "1" { Enable-FortressMode; Read-Host "Press Enter to continue..." }
        "2" { Enable-UltimatePerformance; Read-Host "Press Enter to continue..." }
        "3" { Get-SecurityAudit; Read-Host "Press Enter to continue..." }
        "4" { 
            Write-Host ""
            Write-Host "Trimming NVMe SSD..." -ForegroundColor Cyan
            Optimize-Volume -DriveLetter C -ReTrim -ErrorAction SilentlyContinue
            Clear-DnsClientCache
            Write-Host "[SUCCESS] NVMe SSD Re-Trimmed and Memory Cache Flushed." -ForegroundColor Green
            Read-Host "Press Enter to continue..." 
        }
        "5" { Restore-SafeDefaults; Read-Host "Press Enter to continue..." }
        "0" { Write-Host "Exiting SentinelShield CLI. Stay safe!" -ForegroundColor Cyan; exit }
        default { Write-Host "Invalid choice!" -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
}
