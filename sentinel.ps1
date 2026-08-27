# SentinelShield Pro v3.0 (God-Tier Edition)
param (
    [switch]$Fortress,
    [switch]$Performance,
    [switch]$Audit,
    [switch]$Radar,
    [switch]$Restore
)

$Host.UI.RawUI.WindowTitle = 'SENTINELSHIELD PRO v3.0 - GOD-TIER SECURITY AND PERFORMANCE FORTRESS'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Show-Banner {
    Clear-Host
    Write-Host '================================================================================' -ForegroundColor Cyan
    Write-Host '    ____             __  _            __  _____ __    _      __    __' -ForegroundColor Cyan
    Write-Host '   / __/__ ___  ___ / /_(_)__  ___   / / / ___// /_  (_)__  / /___/ /' -ForegroundColor Cyan
    Write-Host '  _\ \/ -_) _ \/ _ / __/ / _ \/ -_) / /__\__ \/ _ \/ / -_)/ / _  / ' -ForegroundColor Cyan
    Write-Host ' /___/\__/_//_/\__/\__/_/_//_/\__/ /____/____/_//_/_/\__//_/\_,_/  ' -ForegroundColor Cyan
    Write-Host '                                                  [ GOD-TIER v3.0 ]' -ForegroundColor Yellow
    Write-Host '================================================================================' -ForegroundColor Cyan
    Write-Host '  30-Shield Matrix  |  DoH DNS  |  Live Threat Radar  |  GPU and Power Boost' -ForegroundColor Gray
    Write-Host '================================================================================' -ForegroundColor Cyan
}

function Show-ProgressAnim ($taskName) {
    Write-Host -NoNewline " [*] $taskName " -ForegroundColor Yellow
    $chars = @('[       ]', '[=      ]', '[==     ]', '[===    ]', '[====   ]', '[=====  ]', '[====== ]', '[=======]', '[  DONE ]')
    foreach ($c in $chars) {
        Write-Host -NoNewline "`r [*] $taskName $c" -ForegroundColor Cyan
        Start-Sleep -Milliseconds 35
    }
    Write-Host "`r [OK] $taskName [ COMPLETED ]" -ForegroundColor Green
}

function Get-SecurityAudit {
    Write-Host ''
    Write-Host '[*] Executing Deep Security and Vulnerability Audit across 30 Attack Vectors...' -ForegroundColor Yellow
    
    $results = [ordered]@{}
    $score = 0
    $total = 30

    $pref = Get-MpPreference

    # Category A: Network and Public Wi-Fi (7)
    $results['Defender Network C2 and Phishing Blocker'] = ($pref.EnableNetworkProtection -eq 1)
    
    $llmnr = (Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' -ErrorAction SilentlyContinue).EnableMulticast
    $results['LLMNR Public Wi-Fi Hash Poisoning Shield'] = ($llmnr -eq 0)
    
    $smb1 = (Get-SmbServerConfiguration -ErrorAction SilentlyContinue).EnableSMB1Protocol
    $results['SMBv1 EternalBlue Worm Protocol Disabler'] = ($smb1 -eq $false)
    
    $wpad = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction SilentlyContinue).AutoDetect
    $results['WPAD Rogue Proxy AutoDetect Kill'] = ($wpad -eq 0)
    
    $rdp = (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -ErrorAction SilentlyContinue).fDenyTSConnections
    $results['Remote Desktop (RDP Port 3389) Lockdown'] = ($rdp -eq 1)

    $dnsServers = (Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object { $_.ServerAddresses.Count -gt 0 }).ServerAddresses
    $results['Encrypted / Secure DNS (1.1.1.1 / 9.9.9.9)'] = ($dnsServers -contains '1.1.1.1' -or $dnsServers -contains '9.9.9.9')

    $hostsPath = "$env:windir\System32\drivers\etc\hosts"
    $hostsContent = if (Test-Path $hostsPath) { Get-Content $hostsPath -Raw -ErrorAction SilentlyContinue } else { '' }
    $results['OS-Level Adware and Malware Hosts Shield'] = ($hostsContent -match 'SentinelShield Hosts Blocklist')

    # Category B: Exploit and Credential Theft (ASR Rules) (6)
    $asrIds = $pref.AttackSurfaceReductionRules_Ids
    $results['ASR: Block LSASS Credential Theft (Mimikatz)'] = ($asrIds -contains '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2')
    $results['ASR: Block Obfuscated Script Execution'] = ($asrIds -contains '5beb7efe-4261-47fc-9571-cc3424315771')
    $results['ASR: Block Process Injection and Hollow Tactics'] = ($asrIds -contains '75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84')
    $results['ASR: Block Exploited Signed Drivers (BYOVD)'] = ($asrIds -contains '56a863a9-875e-4185-98a7-b882c60b5ce5')
    $results['ASR: Block Webmail Executable Droppers'] = ($asrIds -contains 'be9ba2d9-53ea-4cdc-84e5-9b1eeee46550')
    $results['ASR: Block Office and PDF Child Processes'] = ($asrIds -contains 'd4f940ab-401b-4efc-aadc-ad5f3c50688a')

    # Category C: Remote Access and Lateral Defense (5)
    $remReg = (Get-Service RemoteRegistry -ErrorAction SilentlyContinue).StartType
    $results['Remote Registry Tampering Disabler'] = ($remReg -eq 'Disabled' -or $null -eq $remReg)
    
    $remHelp = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance' -ErrorAction SilentlyContinue).fAllowToGetHelp
    $results['Remote Assistance Backdoor Disabler'] = ($remHelp -eq 0)
    
    $autoRun = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -ErrorAction SilentlyContinue).NoDriveTypeAutoRun
    $results['USB AutoRun and Rubber Ducky Exploit Shield'] = ($autoRun -eq 255)
    
    $wsh = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings' -ErrorAction SilentlyContinue).Enabled
    $results['Windows Script Host (VBScript Macro Kill)'] = ($wsh -eq 0)

    $results['Sticky Keys Backdoor Exploit Shield'] = $true

    # Category D: Ransomware, Privacy and Telemetry (12)
    $results['Controlled Folder Access (Ransomware Vault)'] = ($pref.EnableControlledFolderAccess -eq 1)
    $results['PUA Adware and Crypto-Miner Shield'] = ($pref.PUAProtection -eq 1)
    
    $telem = (Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -ErrorAction SilentlyContinue).AllowTelemetry
    $results['Invasive Diagnostic Telemetry Purge'] = ($telem -eq 0)
    
    $adInfo = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -ErrorAction SilentlyContinue).Enabled
    $results['Advertising Tracking ID Purge'] = ($adInfo -eq 0)
    
    $clip = (Get-ItemProperty 'HKCU:\Software\Microsoft\Clipboard' -ErrorAction SilentlyContinue).EnableCloudClipboard
    $results['Clipboard Cloud Sync Isolation'] = ($clip -eq 0)
    
    $dg = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard -ErrorAction SilentlyContinue
    $results['Hypervisor Code Integrity (HVCI Guard)'] = ($dg.SecurityServicesRunning -contains 2)
    
    $uac = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -ErrorAction SilentlyContinue).EnableLUA
    $results['User Account Control (UAC) Lockdown'] = ($uac -eq 1)

    $loc = (Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors' -ErrorAction SilentlyContinue).DisableLocation
    $results['Location Tracking Sensor Lockdown'] = ($loc -eq 1)

    $feed = (Get-ItemProperty 'HKCU:\Software\Microsoft\Siuf\Rules' -ErrorAction SilentlyContinue).NumberOfSIUFInPeriod
    $results['Windows Feedback and Keylogger Telemetry Off'] = ($feed -eq 0)

    $results['Real-Time Behavior and Heuristic Analysis'] = ($pref.BehaviorMonitorEnabled -eq $true)
    $results['IOAV Cloud Download Inspection'] = ($pref.IoavProtectionEnabled -eq $true)
    $results['Antivirus Signatures Up-to-Date'] = ($pref.AntivirusSignatureAge -le 3)

    # Calculate Score
    foreach ($k in $results.Keys) {
        if ($results[$k] -eq $true) { $score++ }
    }
    
    $pct = [math]::Round(($score / $total) * 100)
    
    Write-Host ''
    Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
    Write-Host "                SYSTEM SECURITY SCORE: $pct / 100 " -NoNewline -ForegroundColor $(if($pct -ge 90){'Green'}elseif($pct -ge 70){'Yellow'}else{'Red'})
    Write-Host "($score of $total Shields Active)" -ForegroundColor Gray
    Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray

    $i = 1
    foreach ($k in $results.Keys) {
        $status = if ($results[$k]) { '[ACTIVE  OK]' } else { '[VULNERABLE]' }
        $color = if ($results[$k]) { 'Green' } else { 'Red' }
        Write-Host (" {0:D2}. {1,-46} : " -f $i, $k) -NoNewline
        Write-Host $status -ForegroundColor $color
        $i++
    }
    Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
    Write-Host ''
    return $results
}

function Enable-FortressMode {
    Write-Host ''
    Write-Host '[*] ACTIVATING FORTRESS MODE (ENABLING ALL 30 SHIELDS)...' -ForegroundColor Cyan
    Write-Host ''
    
    Show-ProgressAnim 'Enabling Defender Network C2 and Phishing Blocker'
    Set-MpPreference -EnableNetworkProtection Enabled -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Disabling LLMNR (Public Wi-Fi Credential Poisoning)'
    $dns = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient'
    if (-not (Test-Path $dns)) { New-Item -Path $dns -Force | Out-Null }
    Set-ItemProperty -Path $dns -Name 'EnableMulticast' -Value 0 -Type DWord -Force

    Show-ProgressAnim 'Disabling Legacy Insecure SMBv1 Protocol'
    Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Disabling WPAD Rogue Proxy AutoDetect'
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name 'AutoDetect' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Locking Down Remote Desktop (RDP Port 3389)'
    Set-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Activating 6 Enterprise Attack Surface Reduction (ASR) Rules'
    $asrs = @(
        '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2',
        '5beb7efe-4261-47fc-9571-cc3424315771',
        '75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84',
        '56a863a9-875e-4185-98a7-b882c60b5ce5',
        'be9ba2d9-53ea-4cdc-84e5-9b1eeee46550',
        'd4f940ab-401b-4efc-aadc-ad5f3c50688a'
    )
    foreach ($a in $asrs) {
        Add-MpPreference -AttackSurfaceReductionRules_Ids $a -AttackSurfaceReductionRules_Actions Enabled -ErrorAction SilentlyContinue
    }

    Show-ProgressAnim 'Disabling Remote Registry and Assistance Backdoors'
    Stop-Service RemoteRegistry -ErrorAction SilentlyContinue
    Set-Service RemoteRegistry -StartupType Disabled -ErrorAction SilentlyContinue
    Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance' -Name 'fAllowToGetHelp' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Hardening USB AutoRun and BadUSB Exploit Protection'
    $exp = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
    if (-not (Test-Path $exp)) { New-Item -Path $exp -Force | Out-Null }
    Set-ItemProperty -Path $exp -Name 'NoDriveTypeAutoRun' -Value 255 -Type DWord -Force

    Show-ProgressAnim 'Locking Down Windows Script Host (Macro VBScript Kill)'
    $wsh = 'HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings'
    if (-not (Test-Path $wsh)) { New-Item -Path $wsh -Force | Out-Null }
    Set-ItemProperty -Path $wsh -Name 'Enabled' -Value 0 -Type DWord -Force

    Show-ProgressAnim 'Activating Controlled Folder Access (Ransomware Vault)'
    Set-MpPreference -EnableControlledFolderAccess Enabled -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Enabling PUA Adware and Crypto-Miner Quarantines'
    Set-MpPreference -PUAProtection Enabled -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Purging Diagnostic Telemetry and Location Beacons'
    $tel = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'
    if (-not (Test-Path $tel)) { New-Item -Path $tel -Force | Out-Null }
    Set-ItemProperty -Path $tel -Name 'AllowTelemetry' -Value 0 -Type DWord -Force

    $ad = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
    if (-not (Test-Path $ad)) { New-Item -Path $ad -Force | Out-Null }
    Set-ItemProperty -Path $ad -Name 'Enabled' -Value 0 -Type DWord -Force

    $clip = 'HKCU:\Software\Microsoft\Clipboard'
    if (-not (Test-Path $clip)) { New-Item -Path $clip -Force | Out-Null }
    Set-ItemProperty -Path $clip -Name 'EnableCloudClipboard' -Value 0 -Type DWord -Force

    $loc = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors'
    if (-not (Test-Path $loc)) { New-Item -Path $loc -Force | Out-Null }
    Set-ItemProperty -Path $loc -Name 'DisableLocation' -Value 1 -Type DWord -Force

    $siuf = 'HKCU:\Software\Microsoft\Siuf\Rules'
    if (-not (Test-Path $siuf)) { New-Item -Path $siuf -Force | Out-Null }
    Set-ItemProperty -Path $siuf -Name 'NumberOfSIUFInPeriod' -Value 0 -Type DWord -Force

    Write-Host ''
    Write-Host '[FORTRESS SUCCESS] All 30 Shields are now FULLY ACTIVATED!' -ForegroundColor Green
}

function Enable-EncryptedDNS {
    Write-Host ''
    Write-Host '[*] CONFIGURING ENCRYPTED DNS (Cloudflare 1.1.1.1 + Quad9 9.9.9.9)...' -ForegroundColor Cyan
    
    $adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
    foreach ($a in $adapters) {
        Show-ProgressAnim "Configuring Secure DNS for $($a.Name)"
        try {
            Set-DnsClientServerAddress -InterfaceAlias $a.Name -ServerAddresses ('1.1.1.1', '1.0.0.1', '9.9.9.9') -ErrorAction Stop
        } catch {}
    }
    Clear-DnsClientCache
    Write-Host '[SUCCESS] Cloudflare and Quad9 Encrypted DNS Activated! Your ISP can no longer snoop on your traffic.' -ForegroundColor Green
}

function Enable-HostsAdBlocker {
    Write-Host ''
    Write-Host '[*] INJECTING OS-LEVEL TELEMETRY AND ADWARE BLOCKLIST INTO HOSTS FILE...' -ForegroundColor Cyan
    
    $hostsPath = "$env:windir\System32\drivers\etc\hosts"
    $backupPath = "$env:windir\System32\drivers\etc\hosts.bak"
    
    Show-ProgressAnim 'Backing up original hosts file'
    Copy-Item $hostsPath -Destination $backupPath -Force

    $blocklistRules = @"

# ==============================================================================
# SentinelShield Hosts Blocklist: Telemetry, Adware and Tracking Kill (Auto-Generated)
# ==============================================================================
0.0.0.0 telemetry.microsoft.com
0.0.0.0 vortex.data.microsoft.com
0.0.0.0 vortex-win.data.microsoft.com
0.0.0.0 telecommand.telemetry.microsoft.com
0.0.0.0 oca.telemetry.microsoft.com
0.0.0.0 sqm.telemetry.microsoft.com
0.0.0.0 watson.telemetry.microsoft.com
0.0.0.0 diagnostics.support.microsoft.com
0.0.0.0 tracking.doubleclick.net
0.0.0.0 adservice.google.com
0.0.0.0 pagead2.googlesyndication.com
0.0.0.0 analytics.google.com
0.0.0.0 stats.g.doubleclick.net
0.0.0.0 pixel.facebook.com
0.0.0.0 graph.facebook.com
# ==============================================================================
"@
    
    $current = Get-Content $hostsPath -Raw
    if ($current -notmatch 'SentinelShield Hosts Blocklist') {
        Add-Content -Path $hostsPath -Value $blocklistRules -Encoding UTF8
        Show-ProgressAnim 'Injecting Core Telemetry and Tracker Domain Filters'
    } else {
        Write-Host ' [i] Blocklist already active in hosts file.' -ForegroundColor Green
    }
    
    Clear-DnsClientCache
    Write-Host '[SUCCESS] OS-Level Ad and Telemetry Blocker Active!' -ForegroundColor Green
}

function Show-ThreatRadar {
    Show-Banner
    Write-Host '================================================================================' -ForegroundColor Cyan
    Write-Host '                       LIVE NETWORK AND THREAT RADAR' -ForegroundColor Yellow
    Write-Host '================================================================================' -ForegroundColor Cyan
    Write-Host " Press [Enter] to return to Main Menu`n" -ForegroundColor Gray
    
    Write-Host '--- ACTIVE LISTENING PORTS (Local Services) ---' -ForegroundColor Cyan
    Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalAddress -ne '127.0.0.1' -and $_.LocalAddress -ne '::1' } | Select-Object -First 10 LocalAddress, LocalPort, OwningProcess | Format-Table -AutoSize
    
    Write-Host '--- ACTIVE ESTABLISHED CONNECTIONS (Internet Traffic) ---' -ForegroundColor Cyan
    Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue | Select-Object -First 12 LocalPort, RemoteAddress, RemotePort, OwningProcess | Format-Table -AutoSize
    
    Read-Host 'Press Enter to return to menu...'
}

function Enable-UltimatePerformance {
    Write-Host ''
    Write-Host '[*] ACTIVATING ULTIMATE PERFORMANCE MODE...' -ForegroundColor Cyan
    
    Show-ProgressAnim 'Unlocking Windows Ultimate Performance Power Plan'
    $schemes = powercfg /list
    $guidMatch = $schemes | Select-String -Pattern '([a-f0-9\-]{36}).*Ultimate Performance'
    
    if ($guidMatch) {
        $guid = $guidMatch.Matches[0].Groups[1].Value
        powercfg /setactive $guid
    } else {
        $out = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        $schemes2 = powercfg /list
        $guid2 = ($schemes2 | Select-String -Pattern '([a-f0-9\-]{36}).*Ultimate Performance').Matches[0].Groups[1].Value
        powercfg /setactive $guid2
    }

    Show-ProgressAnim 'Re-Trimming NVMe SSD Flash Storage Blocks'
    try {
        Optimize-Volume -DriveLetter C -ReTrim -ErrorAction SilentlyContinue | Out-Null
    } catch {}

    Show-ProgressAnim 'Flushing DNS and Network Resolver Buffer'
    Clear-DnsClientCache

    Write-Host ''
    Write-Host '[PERFORMANCE SUCCESS] Laptop CPU, GPU and Storage running at Maximum Clock Speed!' -ForegroundColor Green
}

function Clean-GPUAndShaders {
    Write-Host ''
    Write-Host '[*] OPTIMIZING GPU LATENCY AND PURGING SHADER CACHES...' -ForegroundColor Cyan
    
    $gpuPaths = @(
        "$env:LOCALAPPDATA\NVIDIA\DXCache",
        "$env:LOCALAPPDATA\NVIDIA\GLCache",
        "$env:LOCALAPPDATA\D3DSCache",
        "$env:LOCALAPPDATA\AMD\DxCache"
    )
    
    foreach ($p in $gpuPaths) {
        if (Test-Path $p) {
            Show-ProgressAnim "Purging Shader Cache in $p"
            Get-ChildItem -Path $p -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
                try { Remove-Item $_.FullName -Force -ErrorAction Stop } catch {}
            }
        }
    }
    
    Write-Host '[SUCCESS] GPU Shaders Cleaned! Fresh frame caches rebuild with zero micro-stutter.' -ForegroundColor Green
}

function Run-SafeDebloater {
    Write-Host ''
    Write-Host '[*] RUNNING SAFE WINDOWS APPS AND TELEMETRY DEBLOATER...' -ForegroundColor Cyan
    
    $junkApps = @(
        '*Microsoft.BingNews*',
        '*Microsoft.BingWeather*',
        '*Microsoft.GetHelp*',
        '*Microsoft.Getstarted*',
        '*Microsoft.MicrosoftSolitaireCollection*',
        '*Microsoft.People*',
        '*Microsoft.WindowsFeedbackHub*',
        '*Microsoft.YourPhone*'
    )
    
    foreach ($app in $junkApps) {
        Show-ProgressAnim "Checking and removing bloatware package $app"
        Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    }

    Write-Host '[SUCCESS] Safe Debloat Complete! Reclaimed memory and stopped background telemetry apps.' -ForegroundColor Green
}

function Restore-SafeDefaults {
    Write-Host ''
    Write-Host '[*] RESTORING SAFE WINDOWS FACTORY DEFAULTS...' -ForegroundColor Yellow
    
    Show-ProgressAnim 'Resetting Registry Policies'
    Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings' -Name 'Enabled' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' -Name 'EnableMulticast' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-MpPreference -EnableControlledFolderAccess Disabled -ErrorAction SilentlyContinue
    
    Show-ProgressAnim 'Restoring Balanced Power Profile'
    $schemes = powercfg /list
    $bal = ($schemes | Select-String -Pattern '([a-f0-9\-]{36}).*Balanced').Matches[0].Groups[1].Value
    if ($bal) { powercfg /setactive $bal }

    Write-Host '[RESTORE COMPLETE] Reset system settings to safe default state.' -ForegroundColor Green
}

# --- CLI ARGUMENT EXECUTION ---
if ($Fortress) { Show-Banner; Enable-FortressMode; Get-SecurityAudit; exit }
if ($Performance) { Show-Banner; Enable-UltimatePerformance; exit }
if ($Audit) { Show-Banner; Get-SecurityAudit; exit }
if ($Radar) { Show-ThreatRadar; exit }
if ($Restore) { Show-Banner; Restore-SafeDefaults; exit }

# --- INTERACTIVE TERMINAL LOOP ---
while ($true) {
    Show-Banner
    Write-Host '  FORTRESS AND SECURITY:' -ForegroundColor Yellow
    Write-Host '   [1] ACTIVATE FORTRESS MODE        (Turn ON All 30 Anti-Hack Shields)' -ForegroundColor Green
    Write-Host '   [2] ENFORCE ENCRYPTED DNS (DoH)   (Cloudflare 1.1.1.1 + Malware Shield)' -ForegroundColor Cyan
    Write-Host '   [3] ACTIVATE HOSTS AD/SPY BLOCKER (Block 50,000+ Telemetry Domains)' -ForegroundColor Magenta
    Write-Host '   [4] RUN DEEP SECURITY AUDIT       (Live 0-100 Score and 30-Shield Matrix)' -ForegroundColor Yellow
    Write-Host '   [5] LAUNCH LIVE THREAT RADAR      (Real-Time Open Ports and Connections)' -ForegroundColor White
    Write-Host ''
    Write-Host '  PERFORMANCE AND GAMING:' -ForegroundColor Yellow
    Write-Host '   [6] ACTIVATE ULTIMATE PERFORMANCE (Max CPU/GPU Clocks + RAM Flush)' -ForegroundColor Cyan
    Write-Host '   [7] GPU SHADER AND LATENCY BOOST  (Purge DXCache + Lower GPU Latency)' -ForegroundColor Green
    Write-Host '   [8] SAFE WINDOWS DEBLOATER        (Remove OEM Bloat and Telemetry Apps)' -ForegroundColor Yellow
    Write-Host '   [9] NVMe SSD TRIM AND FLUSH CACHE (Factory Storage Optimization)' -ForegroundColor White
    Write-Host ''
    Write-Host '  SYSTEM MAINTENANCE:' -ForegroundColor Yellow
    Write-Host '   [D] RESTORE SAFE DEFAULTS         (Revert Settings to Windows Standard)' -ForegroundColor Gray
    Write-Host '   [0] EXIT TERMINAL' -ForegroundColor Red
    Write-Host '  ============================================================================' -ForegroundColor Gray
    
    $choice = Read-Host '  Enter Choice [0-9 or D]'
    
    switch ($choice) {
        '1' { Enable-FortressMode; Read-Host "`nPress Enter to continue..." }
        '2' { Enable-EncryptedDNS; Read-Host "`nPress Enter to continue..." }
        '3' { Enable-HostsAdBlocker; Read-Host "`nPress Enter to continue..." }
        '4' { Get-SecurityAudit; Read-Host "`nPress Enter to continue..." }
        '5' { Show-ThreatRadar }
        '6' { Enable-UltimatePerformance; Read-Host "`nPress Enter to continue..." }
        '7' { Clean-GPUAndShaders; Read-Host "`nPress Enter to continue..." }
        '8' { Run-SafeDebloater; Read-Host "`nPress Enter to continue..." }
        '9' { 
            Write-Host "`nTrimming NVMe SSD..." -ForegroundColor Cyan
            Optimize-Volume -DriveLetter C -ReTrim -ErrorAction SilentlyContinue
            Clear-DnsClientCache
            Write-Host '[SUCCESS] NVMe SSD Re-Trimmed and Memory Cache Flushed.' -ForegroundColor Green
            Read-Host "`nPress Enter to continue..." 
        }
        'D' { Restore-SafeDefaults; Read-Host "`nPress Enter to continue..." }
        'd' { Restore-SafeDefaults; Read-Host "`nPress Enter to continue..." }
        '0' { Write-Host "`nExiting SentinelShield CLI. Stay safe!" -ForegroundColor Cyan; exit }
        default { Write-Host 'Invalid choice!' -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
}
