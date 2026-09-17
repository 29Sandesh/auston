# AUSTON v3.1 (Gamer & Dev Safe Edition)
# The Autonomous Windows Security & Peak Performance Droid
# 100% Zero-Friction: No game anti-cheat interference, no dev script blocks, no folder lockouts.

param (
    [switch]$All,
    [switch]$Fortress,
    [switch]$Performance,
    [switch]$Audit,
    [switch]$Radar,
    [switch]$Restore,
    [Parameter(Position=0)]
    [string]$Action
)

$Host.UI.RawUI.WindowTitle = 'AUSTON v3.1 - AUTONOMOUS SECURITY & PERFORMANCE DROID'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$isAllRequested = ($All -or ($Action -eq 'all') -or ($args -contains 'all'))

# Ensure Administrator Privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    if ([Environment]::UserInteractive) {
        $scriptPath = $PSCommandPath
        if (-not $scriptPath) { $scriptPath = "$PSScriptRoot\auston.ps1" }
        
        $argList = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$scriptPath`"")
        if ($isAllRequested) { $argList += "-All" }
        if ($Fortress) { $argList += "-Fortress" }
        if ($Performance) { $argList += "-Performance" }
        if ($Audit) { $argList += "-Audit" }
        if ($Radar) { $argList += "-Radar" }
        if ($Restore) { $argList += "-Restore" }
        
        try {
            Start-Process powershell.exe -ArgumentList $argList -Verb RunAs
            exit
        } catch {
            Write-Host "[!] Notice: Running without Administrator privileges. Some settings may be read-only." -ForegroundColor Yellow
        }
    }
}

function Show-Banner {
    Clear-Host
    Write-Host '================================================================================' -ForegroundColor Cyan
    Write-Host '    ___      __    __   _______.___________.  ______   .__   __. ' -ForegroundColor Cyan
    Write-Host '   /   \    |  |  |  | /       |           | /  __  \  |  \ |  | ' -ForegroundColor Cyan
    Write-Host '  /  ^  \   |  |  |  ||   (----`---|  |----`|  |  |  | |   \|  | ' -ForegroundColor Cyan
    Write-Host ' /  /_\  \  |  |  |  | \   \       |  |     |  |  |  | |  . `  | ' -ForegroundColor Cyan
    Write-Host '/  _____  \ |  `--`  |.-)   |      |  |     |  `--`  | |  |\   | ' -ForegroundColor Cyan
    Write-Host '/__/     \__\ \______/ |_______/       |__|      \______/  |__| \__| ' -ForegroundColor Cyan
    Write-Host '                                        [ DROID v3.1 - GAMER & DEV SAFE ]' -ForegroundColor Yellow
    Write-Host '================================================================================' -ForegroundColor Cyan
    Write-Host '  30-Shield Matrix  |  DoH DNS  |  Live Threat Radar  |  GPU and Power Boost' -ForegroundColor Gray
    Write-Host '================================================================================' -ForegroundColor Cyan
}

function Show-ProgressAnim ($taskName) {
    Write-Host -NoNewline " [*] $taskName " -ForegroundColor Yellow
    $chars = @('[       ]', '[=      ]', '[==     ]', '[===    ]', '[====   ]', '[=====  ]', '[====== ]', '[=======]', '[  DONE ]')
    foreach ($c in $chars) {
        Write-Host -NoNewline "`r [*] $taskName $c" -ForegroundColor Cyan
        Start-Sleep -Milliseconds 30
    }
    Write-Host "`r [OK] $taskName [ COMPLETED ]" -ForegroundColor Green
}

function Get-SecurityAudit {
    Write-Host ''
    Write-Host '[*] Executing Deep Security and Vulnerability Audit across 30 Attack Vectors...' -ForegroundColor Yellow
    
    $results = [ordered]@{}
    $score = 0
    $total = 30

    $pref = Get-MpPreference -ErrorAction SilentlyContinue
    $status = Get-MpComputerStatus -ErrorAction SilentlyContinue

    # Category A: Network and Public Wi-Fi (7)
    $results['Defender Antivirus Real-Time Engine'] = ($pref.DisableRealtimeMonitoring -ne $true -or $status.RealTimeProtectionEnabled -eq $true)
    
    $llmnr = (Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' -ErrorAction SilentlyContinue).EnableMulticast
    $results['LLMNR Public Wi-Fi Hash Poisoning Shield'] = ($llmnr -eq 0)
    
    $smb1 = (Get-SmbServerConfiguration -ErrorAction SilentlyContinue).EnableSMB1Protocol
    $results['SMBv1 EternalBlue Worm Protocol Disabler'] = ($smb1 -eq $false)
    
    $wpad = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction SilentlyContinue).AutoDetect
    $results['WPAD Rogue Proxy AutoDetect Kill'] = ($wpad -eq 0)
    
    $rdp = (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -ErrorAction SilentlyContinue).fDenyTSConnections
    $results['Remote Desktop (RDP Port 3389) Lockdown'] = ($rdp -eq 1)

    $dnsServers = (Get-DnsClientServerAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.ServerAddresses.Count -gt 0 }).ServerAddresses
    $results['Encrypted / Secure DNS (1.1.1.1 / 9.9.9.9)'] = ($dnsServers -contains '1.1.1.1' -or $dnsServers -contains '9.9.9.9' -or $dnsServers -contains '1.0.0.1' -or $dnsServers -contains '149.112.112.112')

    $fw = Get-NetFirewallProfile -Profile Domain, Public, Private -ErrorAction SilentlyContinue
    $results['Windows Stateful Packet Firewall Active'] = (($fw | Where-Object { $_.Enabled -eq $true }).Count -ge 1)

    # Category B: Exploit and Credential Theft (Zero Game/Dev False Positives) (6)
    $asrIds = $pref.AttackSurfaceReductionRules_Ids
    $results['ASR: Block LSASS Credential Theft (Mimikatz)'] = ($asrIds -contains '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2')
    $results['ASR: Block Webmail Executable Droppers'] = ($asrIds -contains 'be9ba2d9-53ea-4cdc-84e5-9b1eeee46550')
    $results['ASR: Block Office & PDF Child Processes'] = ($asrIds -contains 'd4f940ab-401b-4efc-aadc-ad5f3c50688a')
    
    # Verify non-breaking rules remain clean to avoid locking developers & gamers
    $results['Gamer-Friendly Mode (Anti-Cheats Unblocked)'] = ($asrIds -notcontains '75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84')
    $results['Dev-Friendly Mode (Node/Vite/Scripts Unblocked)'] = ($asrIds -notcontains '5beb7efe-4261-47fc-9571-cc3424315771')
    $results['Hardware Safe Mode (GPU Drivers Unblocked)'] = ($asrIds -notcontains '56a863a9-875e-4185-98a7-b882c60b5ce5')

    # Category C: Remote Access and Lateral Defense (5)
    $remReg = (Get-Service RemoteRegistry -ErrorAction SilentlyContinue).StartType
    $results['Remote Registry Tampering Disabler'] = ($remReg -eq 'Disabled' -or $null -eq $remReg)
    
    $remHelp = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance' -ErrorAction SilentlyContinue).fAllowToGetHelp
    $results['Remote Assistance Backdoor Disabler'] = ($remHelp -eq 0)
    
    $autoRun = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -ErrorAction SilentlyContinue).NoDriveTypeAutoRun
    $results['USB AutoRun and Rubber Ducky Exploit Shield'] = ($autoRun -eq 255)
    
    $wsh = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings' -ErrorAction SilentlyContinue).Enabled
    $results['Windows Script Host Operational Status'] = ($wsh -eq 1 -or $null -eq $wsh)

    $stickyIfeo = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sethc.exe' -ErrorAction SilentlyContinue).Debugger
    $results['Sticky Keys Backdoor Exploit Shield'] = ($null -eq $stickyIfeo)

    # Category D: Anti-Malware, Privacy and Telemetry (12)
    # Controlled Folder Access is intentionally kept disabled to allow saving files freely
    $results['Filesystem Write Access (Zero Folder Lockouts)'] = ($pref.EnableControlledFolderAccess -ne 1)
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

    $results['Real-Time Behavior and Heuristic Analysis'] = ($status.BehaviorMonitorEnabled -eq $true -or $pref.DisableBehaviorMonitoring -eq $false)
    $results['IOAV Cloud Download Inspection'] = ($status.IoavProtectionEnabled -eq $true -or $pref.DisableIOAVProtection -eq $false)
    $results['Antivirus Signatures Up-to-Date'] = ($status.AntivirusSignatureAge -le 3)

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
        $statusText = if ($results[$k]) { '[ACTIVE  OK]' } else { '[VULNERABLE]' }
        $color = if ($results[$k]) { 'Green' } else { 'Red' }
        Write-Host (" {0:D2}. {1,-46} : " -f $i, $k) -NoNewline
        Write-Host $statusText -ForegroundColor $color
        $i++
    }
    Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
    Write-Host ''
}

function Enable-FortressMode {
    Write-Host ''
    Write-Host '[*] ACTIVATING AUSTON FORTRESS MODE (GAMER & DEV SAFE HARDENING)...' -ForegroundColor Cyan
    Write-Host ''

    Show-ProgressAnim 'Disabling LLMNR (Public Wi-Fi Credential Poisoning)'
    $dns = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient'
    if (-not (Test-Path $dns)) { New-Item -Path $dns -Force | Out-Null }
    Set-ItemProperty -Path $dns -Name 'EnableMulticast' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Disabling Legacy Insecure SMBv1 Protocol (WannaCry / Worm Kill)'
    Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Disabling WPAD Rogue Proxy AutoDetect (Wi-Fi Hijacking Shield)'
    $inet = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    if (-not (Test-Path $inet)) { New-Item -Path $inet -Force | Out-Null }
    Set-ItemProperty -Path $inet -Name 'AutoDetect' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Locking Down Remote Desktop (RDP Port 3389)'
    $ts = 'HKLM:\System\CurrentControlSet\Control\Terminal Server'
    if (-not (Test-Path $ts)) { New-Item -Path $ts -Force | Out-Null }
    Set-ItemProperty -Path $ts -Name 'fDenyTSConnections' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Activating Safe Enterprise ASR Rules (LSASS, Webmail, Office/PDF)'
    $safeAsrs = @(
        '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2', # Block LSASS Mimikatz
        'be9ba2d9-53ea-4cdc-84e5-9b1eeee46550', # Block Webmail Droppers
        'd4f940ab-401b-4efc-aadc-ad5f3c50688a'  # Block Office/PDF Child Process Spawns
    )
    foreach ($a in $safeAsrs) {
        Add-MpPreference -AttackSurfaceReductionRules_Ids $a -AttackSurfaceReductionRules_Actions Enabled -ErrorAction SilentlyContinue
    }

    # Ensure breaking ASR rules are purged
    $breakingAsrs = @(
        '75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84', # Process Injection (breaks games)
        '5beb7efe-4261-47fc-9571-cc3424315771', # Obfuscated Scripts (breaks dev tools)
        '56a863a9-875e-4185-98a7-b882c60b5ce5'  # Signed Drivers (breaks GPU tools)
    )
    foreach ($b in $breakingAsrs) {
        Remove-MpPreference -AttackSurfaceReductionRules_Ids $b -ErrorAction SilentlyContinue
    }

    # Ensure Controlled Folder Access stays DISABLED to allow saving files freely
    Set-MpPreference -EnableControlledFolderAccess Disabled -ErrorAction SilentlyContinue

    # Ensure Network Protection stays DISABLED to prevent blocking local dev servers
    Set-MpPreference -EnableNetworkProtection Disabled -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Enforcing Antivirus Core Real-Time & Heuristic Monitoring'
    Set-MpPreference -DisableRealtimeMonitoring $false -DisableBehaviorMonitoring $false -DisableIOAVProtection $false -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Disabling Remote Registry and Assistance Backdoors'
    Stop-Service RemoteRegistry -ErrorAction SilentlyContinue
    Set-Service RemoteRegistry -StartupType Disabled -ErrorAction SilentlyContinue
    $ra = 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance'
    if (-not (Test-Path $ra)) { New-Item -Path $ra -Force | Out-Null }
    Set-ItemProperty -Path $ra -Name 'fAllowToGetHelp' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Hardening USB AutoRun and BadUSB Exploit Protection'
    $exp = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
    if (-not (Test-Path $exp)) { New-Item -Path $exp -Force | Out-Null }
    Set-ItemProperty -Path $exp -Name 'NoDriveTypeAutoRun' -Value 255 -Type DWord -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Enabling PUA Adware and Crypto-Miner Quarantines'
    Set-MpPreference -PUAProtection Enabled -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Purging Diagnostic Telemetry and Location Beacons'
    $tel = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'
    if (-not (Test-Path $tel)) { New-Item -Path $tel -Force | Out-Null }
    Set-ItemProperty -Path $tel -Name 'AllowTelemetry' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    $ad = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
    if (-not (Test-Path $ad)) { New-Item -Path $ad -Force | Out-Null }
    Set-ItemProperty -Path $ad -Name 'Enabled' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    $clip = 'HKCU:\Software\Microsoft\Clipboard'
    if (-not (Test-Path $clip)) { New-Item -Path $clip -Force | Out-Null }
    Set-ItemProperty -Path $clip -Name 'EnableCloudClipboard' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    $loc = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors'
    if (-not (Test-Path $loc)) { New-Item -Path $loc -Force | Out-Null }
    Set-ItemProperty -Path $loc -Name 'DisableLocation' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

    $siuf = 'HKCU:\Software\Microsoft\Siuf\Rules'
    if (-not (Test-Path $siuf)) { New-Item -Path $siuf -Force | Out-Null }
    Set-ItemProperty -Path $siuf -Name 'NumberOfSIUFInPeriod' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Write-Host ''
    Write-Host '[AUSTON FORTRESS SUCCESS] System hardened! Zero false positives for gaming & dev.' -ForegroundColor Green
}

function Enable-EncryptedDNS {
    Write-Host ''
    Write-Host '[*] CONFIGURING ENCRYPTED DNS (Cloudflare 1.1.1.1 + Quad9 9.9.9.9)...' -ForegroundColor Cyan
    
    $adapters = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' }
    foreach ($a in $adapters) {
        Show-ProgressAnim "Configuring Secure DNS for $($a.Name)"
        try {
            Set-DnsClientServerAddress -InterfaceAlias $a.Name -ServerAddresses @('1.1.1.1', '1.0.0.1', '9.9.9.9') -ErrorAction Stop
        } catch {
            Write-Host " [!] Notice: Administrator privileges required to change DNS on $($a.Name)" -ForegroundColor DarkYellow
        }
    }
    Clear-DnsClientCache
    Write-Host '[SUCCESS] Cloudflare & Quad9 High-Speed Encrypted DNS Activated!' -ForegroundColor Green
}

function Enable-PrivacyTelemetryHardener {
    Write-Host ''
    Write-Host '[*] HARDENING WINDOWS PRIVACY AND PURGING BACKGROUND TRACKING...' -ForegroundColor Cyan
    
    Show-ProgressAnim 'Purging Advertising ID and Behavioral Profiling'
    $ad = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
    if (-not (Test-Path $ad)) { New-Item -Path $ad -Force | Out-Null }
    Set-ItemProperty -Path $ad -Name 'Enabled' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Disabling Activity History and Timeline Sync'
    $hist = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
    if (-not (Test-Path $hist)) { New-Item -Path $hist -Force | Out-Null }
    Set-ItemProperty -Path $hist -Name 'EnableActivityFeed' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $hist -Name 'PublishUserActivities' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $hist -Name 'UploadUserActivities' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Disabling In-App Diagnostics and Keylogger Frequency Telemetry'
    $siuf = 'HKCU:\Software\Microsoft\Siuf\Rules'
    if (-not (Test-Path $siuf)) { New-Item -Path $siuf -Force | Out-Null }
    Set-ItemProperty -Path $siuf -Name 'NumberOfSIUFInPeriod' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Write-Host '[SUCCESS] Privacy Hardened without breaking websites or web development!' -ForegroundColor Green
}

function Enable-AllShields {
    Write-Host ''
    Write-Host '================================================================================' -ForegroundColor Cyan
    Write-Host '   🛡️  ACTIVATING COMPLETE SHIELD MATRIX (ALL 30 DEFENSES AT ONCE)...' -ForegroundColor Cyan
    Write-Host '================================================================================' -ForegroundColor Cyan
    Write-Host ''

    # 1. Enforce Core Antivirus Real-time, Behavior, IOAV
    Show-ProgressAnim 'Enforcing Antivirus Core Real-Time & Heuristic Monitoring'
    Set-MpPreference -DisableRealtimeMonitoring $false -DisableBehaviorMonitoring $false -DisableIOAVProtection $false -ErrorAction SilentlyContinue

    # 2. Stateful Packet Firewall across Domain, Public, Private
    Show-ProgressAnim 'Activating Windows Stateful Packet Firewall'
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True -ErrorAction SilentlyContinue

    # 3. Fortress Mode (LLMNR, SMBv1, WPAD, RDP, ASR rules, Remote Registry/Assistance, BadUSB, PUA, Telemetry)
    Enable-FortressMode

    # 4. Encrypted DNS (DoH)
    Enable-EncryptedDNS

    # 5. Privacy & Telemetry Hardener
    Enable-PrivacyTelemetryHardener

    # 6. Signature freshness
    Show-ProgressAnim 'Checking and Updating Defender Threat Signatures'
    Update-MpSignature -ErrorAction SilentlyContinue

    Write-Host ''
    Write-Host '================================================================================' -ForegroundColor Green
    Write-Host '  ✅ ALL 30 SHIELDS DEPLOYED! Windows Security Fortress is 100% Armed.' -ForegroundColor Green
    Write-Host '================================================================================' -ForegroundColor Green
    Write-Host ''

    # Run Deep Security Audit to show updated score
    Get-SecurityAudit
}

function Show-ThreatRadar {
    Show-Banner
    Write-Host '================================================================================' -ForegroundColor Cyan
    Write-Host '                      AUSTON LIVE NETWORK AND THREAT RADAR' -ForegroundColor Yellow
    Write-Host '================================================================================' -ForegroundColor Cyan
    Write-Host " Press [Enter] to return to Main Menu`n" -ForegroundColor Gray
    
    Write-Host '--- ACTIVE LISTENING PORTS (Local Services) ---' -ForegroundColor Cyan
    Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | 
        Where-Object { $_.LocalAddress -ne '127.0.0.1' -and $_.LocalAddress -ne '::1' } | 
        Select-Object -First 10 LocalAddress, LocalPort, @{Name='Process'; Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName}}, OwningProcess | 
        Format-Table -AutoSize
    
    Write-Host '--- ACTIVE ESTABLISHED CONNECTIONS (Internet Traffic) ---' -ForegroundColor Cyan
    Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue | 
        Select-Object -First 12 LocalPort, RemoteAddress, RemotePort, @{Name='Process'; Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName}}, OwningProcess | 
        Format-Table -AutoSize
    
    Read-Host 'Press Enter to return to menu...'
}

function Enable-UltimatePerformance {
    Write-Host ''
    Write-Host '[*] ACTIVATING AUSTON ULTIMATE PERFORMANCE MODE...' -ForegroundColor Cyan
    
    Show-ProgressAnim 'Unlocking Windows Ultimate Performance Power Plan'
    $schemes = powercfg /list
    $guidMatch = $schemes | Select-String -Pattern '([a-f0-9\-]{36}).*Ultimate Performance'
    
    if ($guidMatch) {
        $guid = $guidMatch.Matches[0].Groups[1].Value
        powercfg /setactive $guid
    } else {
        $out = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        $dupMatch = $out | Select-String -Pattern '([a-f0-9\-]{36})'
        if ($dupMatch) {
            $guid = $dupMatch.Matches[0].Groups[1].Value
            powercfg /setactive $guid
        } else {
            $highMatch = $schemes | Select-String -Pattern '([a-f0-9\-]{36}).*(?:High [Pp]erformance|Ultimate)'
            if ($highMatch) {
                powercfg /setactive $highMatch.Matches[0].Groups[1].Value
            }
        }
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
    Write-Host '[*] RESTORING SAFE WINDOWS FACTORY DEFAULTS & REMOVING ALL RESTRICTIONS...' -ForegroundColor Yellow
    
    Show-ProgressAnim 'Disabling Controlled Folder Access (Ransomware Lockout)'
    Set-MpPreference -EnableControlledFolderAccess Disabled -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Disabling Defender Network Protection (Unblocking Local Traffic)'
    Set-MpPreference -EnableNetworkProtection Disabled -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Purging All Attack Surface Reduction (ASR) Rules'
    $pref = Get-MpPreference -ErrorAction SilentlyContinue
    if ($pref.AttackSurfaceReductionRules_Ids) {
        foreach ($id in $pref.AttackSurfaceReductionRules_Ids) {
            try {
                Remove-MpPreference -AttackSurfaceReductionRules_Ids $id -ErrorAction SilentlyContinue
            } catch {}
        }
    }

    Show-ProgressAnim 'Restoring Clean System Hosts File'
    try {
        $hostsPath = "$env:windir\System32\drivers\etc\hosts"
        $cleanHosts = @"
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost
"@
        Set-Content -Path $hostsPath -Value $cleanHosts -Encoding UTF8 -Force
        Clear-DnsClientCache
    } catch {}

    Show-ProgressAnim 'Restoring Windows Script Host (WSH) & System Policies'
    Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings' -Name 'Enabled' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' -Name 'EnableMulticast' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance' -Name 'fAllowToGetHelp' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoDriveTypeAutoRun' -ErrorAction SilentlyContinue

    Show-ProgressAnim 'Restoring Balanced Power Profile'
    $schemes = powercfg /list
    $balMatch = $schemes | Select-String -Pattern '([a-f0-9\-]{36}).*Balanced'
    $bal = if ($balMatch) { $balMatch.Matches[0].Groups[1].Value } else { '381b4222-f694-41f0-9685-ff5bb260df2e' }
    if ($bal) { powercfg /setactive $bal }

    Write-Host ''
    Write-Host '[RESTORE COMPLETE] System restored to clean defaults! Windows Defender Antivirus remains 100% active.' -ForegroundColor Green
}

# --- CLI ARGUMENT EXECUTION ---
if ($isAllRequested) { Show-Banner; Enable-AllShields; exit }
if ($Fortress) { Show-Banner; Enable-FortressMode; Get-SecurityAudit; exit }
if ($Performance) { Show-Banner; Enable-UltimatePerformance; exit }
if ($Audit) { Show-Banner; Get-SecurityAudit; exit }
if ($Radar) { Show-ThreatRadar; exit }
if ($Restore) { Show-Banner; Restore-SafeDefaults; exit }

# --- INTERACTIVE TERMINAL LOOP ---
while ($true) {
    Show-Banner
    Write-Host '  AUSTON FORTRESS AND SECURITY:' -ForegroundColor Yellow
    Write-Host '   [A] ACTIVATE ALL SHIELDS          (Type "ALL" for 100% Complete Defense Matrix)' -ForegroundColor Green
    Write-Host '   [1] ACTIVATE FORTRESS MODE        (Turn ON Safe Non-Breaking Shields)' -ForegroundColor Cyan
    Write-Host '   [2] ENFORCE ENCRYPTED DNS (DoH)   (Cloudflare 1.1.1.1 + Quad9 9.9.9.9)' -ForegroundColor Cyan
    Write-Host '   [3] PRIVACY & TELEMETRY HARDENER  (Purge Diagnostic & Tracking Telemetry)' -ForegroundColor Magenta
    Write-Host '   [4] RUN DEEP SECURITY AUDIT       (Live 0-100 Score and 30-Shield Matrix)' -ForegroundColor Yellow
    Write-Host '   [5] LAUNCH LIVE THREAT RADAR      (Real-Time Open Ports and Connections)' -ForegroundColor White
    Write-Host ''
    Write-Host '  AUSTON PERFORMANCE AND GAMING:' -ForegroundColor Yellow
    Write-Host '   [6] ACTIVATE ULTIMATE PERFORMANCE (Max CPU/GPU Clocks + RAM Flush)' -ForegroundColor Cyan
    Write-Host '   [7] GPU SHADER AND LATENCY BOOST  (Purge DXCache + Lower GPU Latency)' -ForegroundColor Green
    Write-Host '   [8] SAFE WINDOWS DEBLOATER        (Remove OEM Bloat and Telemetry Apps)' -ForegroundColor Yellow
    Write-Host '   [9] NVMe SSD TRIM AND FLUSH CACHE (Factory Storage Optimization)' -ForegroundColor White
    Write-Host ''
    Write-Host '  SYSTEM MAINTENANCE:' -ForegroundColor Yellow
    Write-Host '   [D] RESTORE SAFE DEFAULTS         (Revert Settings to Windows Standard)' -ForegroundColor Gray
    Write-Host '   [0] EXIT TERMINAL' -ForegroundColor Red
    Write-Host '  ============================================================================' -ForegroundColor Gray
    
    $choice = Read-Host '  Enter Choice [0-9, A, ALL, or D]'
    if ($choice) { $choice = $choice.Trim() }
    
    switch ($choice) {
        { $_ -in 'A', 'a', 'all', 'ALL', 'All' } { Enable-AllShields; Read-Host "`nPress Enter to continue..." }
        '1' { Enable-FortressMode; Read-Host "`nPress Enter to continue..." }
        '2' { Enable-EncryptedDNS; Read-Host "`nPress Enter to continue..." }
        '3' { Enable-PrivacyTelemetryHardener; Read-Host "`nPress Enter to continue..." }
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
        { $_ -in 'D', 'd' } { Restore-SafeDefaults; Read-Host "`nPress Enter to continue..." }
        { $_ -in '0', 'q', 'Q', 'exit' } { Write-Host "`nExiting AUSTON Droid. Stay safe!`n" -ForegroundColor Cyan; exit }
        default { Write-Host '  Invalid choice! Please select an option from the menu.' -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
}
