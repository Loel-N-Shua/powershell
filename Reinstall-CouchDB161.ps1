#Requires -Version 5.1
#Requires -RunAsAdministrator
<#
.SYNOPSIS
Reinstalls the stock Apache CouchDB 1.6.1 Inno Setup package on Windows.
.DESCRIPTION
Run during a kiosk maintenance window with kiosk applications closed.
Preserves configuration and data; does not wipe databases. Supports -WhatIf.
Requires an existing installation, its unins*.exe, and a trusted local installer.
Supports the stock LocalSystem service and standard INI configuration chain.
Backups contain configuration secrets: use a restricted, local NTFS location.
No automatic rollback is attempted. On failure, backups and logs are retained.
.EXAMPLE
.\Reinstall-CouchDB161.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [string]$InstallerPath = 'C:\setup-couchdb-1.6.1_R16B02.exe',
    [string]$InstallDirectory = 'C:\Program Files (x86)\Apache Software Foundation\CouchDB',
    [string]$BackupRoot = "$env:ProgramData\CouchDB-Reinstall",
    [uri]$HealthUri = 'http://127.0.0.1:5984/',
    [PSCredential]$Credential,
    [ValidatePattern('^[a-fA-F0-9]{64}$')][string]$InstallerSha256,
    [ValidateRange(10, 600)][int]$StartupTimeoutSeconds = 90
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function FullPath([string]$Path) {
    if (-not [IO.Path]::IsPathRooted($Path)) { throw "Use an absolute path: $Path" }
    [IO.Path]::GetFullPath($Path).TrimEnd('\')
}
function Resolve-CouchDataPath([string]$Path, [string]$InstallRoot) {
    if ([string]::IsNullOrWhiteSpace($Path)) { throw 'CouchDB data directory is empty.' }
    # The stock 1.6.1 installer sets erlsrv's working directory to {app}\bin.
    # Resolve against that directory, never Pulseway's working directory.
    if (-not [IO.Path]::IsPathRooted($Path)) {
        $Path = [IO.Path]::Combine((Join-Path $InstallRoot 'bin'), $Path)
    }
    FullPath $Path
}
function IsWithin([string]$Path, [string]$Root) {
    $Path.Equals($Root, [StringComparison]::OrdinalIgnoreCase) -or
        $Path.StartsWith($Root + '\', [StringComparison]::OrdinalIgnoreCase)
}
function CopyTree([string]$Source, [string]$Destination) {
    if (-not (Test-Path -LiteralPath $Source -PathType Container)) { return }
    # Junctions/symlinks are rejected during preflight; do not follow them.
    & robocopy.exe $Source $Destination /E /COPY:DAT /DCOPY:DAT /R:2 /W:2 /XJ /NFL /NDL /NP "/LOG+:$script:CopyLog" | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "Backup/restore failed ($LASTEXITCODE): $Source. See $script:CopyLog" }
}
function RunSetup([string]$Executable, [string[]]$Arguments) {
    $process = Start-Process -FilePath $Executable -ArgumentList $Arguments -Wait -PassThru -WindowStyle Hidden
    if ($process.ExitCode -eq 3010) {
        throw 'Installer requires a reboot. Reboot during maintenance and inspect the logs before continuing. Backup is retained.'
    }
    if ($process.ExitCode -ne 0) { throw "Setup failed with exit code $($process.ExitCode): $Executable" }
}
function FindCouchService {
    @(Get-CimInstance Win32_Service | Where-Object {
        $_.DisplayName -eq 'Apache CouchDB' -or $_.Name -eq 'Apache CouchDB'
    })
}
function CheckService($Service) {
    if ($Service.StartName -notin @('LocalSystem', 'NT AUTHORITY\SYSTEM')) {
        throw "Service uses account '$($Service.StartName)'. This script supports LocalSystem only."
    }
    $binary = [regex]::Match($Service.PathName, '^\s*(?:"([^"]+)"|(\S+))')
    $executable = $binary.Groups[1].Value
    if (-not $executable) { $executable = $binary.Groups[2].Value }
    if (-not $executable -or -not (IsWithin (FullPath $executable) $script:InstallDirectory)) {
        throw 'The Apache CouchDB service belongs to another install directory. Check -InstallDirectory.'
    }
}
function StopCouchService($Service) {
    $controller = Get-Service -Name $Service.Name
    if ($controller.Status -ne 'Stopped') {
        Stop-Service -Name $Service.Name
        $controller.WaitForStatus('Stopped', [TimeSpan]::FromSeconds(60))
    }
}
function AssertNoCouchProcesses {
    $running = @(Get-CimInstance Win32_Process | Where-Object {
        $_.ExecutablePath -and (IsWithin $_.ExecutablePath $script:InstallDirectory) -and
        $_.Name -match '^(erl|werl|beam|beam\.smp|couchjs)\.exe$'
    })
    if ($running.Count) { throw 'CouchDB processes are still running. Close console instances/kiosk launchers before retrying.' }
}

$InstallerPath = FullPath $InstallerPath
$InstallDirectory = FullPath $InstallDirectory
$BackupRoot = FullPath $BackupRoot
if ($InstallDirectory -eq [IO.Path]::GetPathRoot($InstallDirectory).TrimEnd('\')) {
    throw 'InstallDirectory must not be a drive root.'
}
if (IsWithin $InstallerPath $InstallDirectory) { throw 'Place the installer outside the CouchDB installation.' }
if ((IsWithin $BackupRoot $InstallDirectory) -or (IsWithin $InstallDirectory $BackupRoot)) {
    throw 'BackupRoot and InstallDirectory must be separate directory trees.'
}
if (-not (Test-Path -LiteralPath $InstallerPath -PathType Leaf) -or [IO.Path]::GetExtension($InstallerPath) -ne '.exe') {
    throw 'InstallerPath must be the trusted CouchDB 1.6.1 Windows EXE installer.'
}
if ($InstallerSha256 -and (Get-FileHash -LiteralPath $InstallerPath -Algorithm SHA256).Hash -ne $InstallerSha256) {
    throw 'Installer SHA256 does not match. Nothing has been stopped or uninstalled.'
}
$configDirectory = Join-Path $InstallDirectory 'etc\couchdb'
if (-not (Test-Path -LiteralPath (Join-Path $configDirectory 'default.ini'))) { throw 'CouchDB default.ini was not found.' }
$uninstallers = @(Get-ChildItem -LiteralPath $InstallDirectory -Filter 'unins*.exe' -File)
if ($uninstallers.Count -ne 1) { throw 'Expected exactly one Inno Setup uninstaller in InstallDirectory.' }

# Resolve database paths using the normal CouchDB 1.x INI precedence.
$settings = @{}
$iniFiles = @((Join-Path $configDirectory 'default.ini'))
$iniFiles += @(Get-ChildItem -Path (Join-Path $configDirectory 'default.d\*.ini') -ErrorAction SilentlyContinue | Sort-Object Name | Select-Object -ExpandProperty FullName)
if (Test-Path -LiteralPath (Join-Path $configDirectory 'local.ini')) { $iniFiles += Join-Path $configDirectory 'local.ini' }
$iniFiles += @(Get-ChildItem -Path (Join-Path $configDirectory 'local.d\*.ini') -ErrorAction SilentlyContinue | Sort-Object Name | Select-Object -ExpandProperty FullName)
foreach ($ini in $iniFiles) {
    $section = ''
    foreach ($line in Get-Content -LiteralPath $ini) {
        if ($line -match '^\s*\[([^]]+)\]') { $section = $Matches[1].Trim(); continue }
        if ($section -eq 'couchdb' -and $line -match '^\s*(database_dir|view_index_dir)\s*=\s*(.*?)\s*$') {
            $settings[$Matches[1]] = $Matches[2]
        }
    }
}
$dataPaths = @()
foreach ($key in @('database_dir', 'view_index_dir')) {
    if (-not $settings.ContainsKey($key)) { throw "Cannot determine $key from INI files." }
    $value = $settings[$key]
    $path = Resolve-CouchDataPath $value $InstallDirectory
    if ((IsWithin $InstallDirectory $path) -and $path -ne $InstallDirectory) {
        throw "$key must not be a parent of the installation directory: $path"
    }
    if ($path -eq $InstallDirectory) { throw "$key must point to a data directory, not the installation root." }
    if (-not (Test-Path -LiteralPath $path -PathType Container)) { throw "$key directory is missing: $path" }
    if ((IsWithin $BackupRoot $path) -or (IsWithin $path $BackupRoot)) { throw 'BackupRoot overlaps a database/index directory.' }
    $dataPaths += $path
}
$dataPaths = @($dataPaths | Select-Object -Unique)
$sources = @($InstallDirectory) + @($dataPaths | Where-Object { -not (IsWithin $_ $InstallDirectory) })
foreach ($source in $sources) {
    $links = @(Get-Item -LiteralPath $source) + @(Get-ChildItem -LiteralPath $source -Force -Recurse)
    if (@($links | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint }).Count) {
        throw "Reparse point found under $source. This script requires ordinary directories for a complete backup."
    }
}
$services = @(FindCouchService)
if ($services.Count -gt 1) { throw 'Multiple Apache CouchDB services found.' }
foreach ($service in $services) { CheckService $service }
Write-Host "Install directory: $InstallDirectory"
Write-Host "Database/index directories: $($dataPaths -join ', ')"
Write-Host "Backup root: $BackupRoot"
if (-not $PSCmdlet.ShouldProcess($InstallDirectory, 'Stop CouchDB, back up, uninstall, reinstall 1.6.1 as an automatic service, restore and verify')) { return }

$backup = Join-Path $BackupRoot ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -Path $backup -ItemType Directory -Force | Out-Null
# Restrict backup/log access to SYSTEM and local Administrators (language-independent SIDs).
& icacls.exe $backup /inheritance:r /grant:r '*S-1-5-18:(OI)(CI)F' '*S-1-5-32-544:(OI)(CI)F' | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not secure backup directory: $backup" }
$script:CopyLog = Join-Path $backup 'copy.log'
Start-Transcript -Path (Join-Path $backup 'reinstall.log') | Out-Null
try {
    foreach ($service in $services) { StopCouchService $service }
    AssertNoCouchProcesses
    CopyTree $InstallDirectory (Join-Path $backup 'installation')
    $external = @()
    for ($i = 0; $i -lt $sources.Count; $i++) {
        if ($i -eq 0) { continue }
        $saved = Join-Path $backup "external-$i"
        CopyTree $sources[$i] $saved
        $external += [pscustomobject]@{ Original = $sources[$i]; Backup = $saved }
    }
    [pscustomobject]@{ InstallDirectory = $InstallDirectory; DataDirectories = $dataPaths; External = $external; Services = $services } |
        ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $backup 'manifest.json') -Encoding UTF8
    Write-Host "Backup completed: $backup"
    RunSetup $uninstallers[0].FullName @('/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', "/LOG=`"$backup\uninstall.log`"")
    if (Test-Path -LiteralPath $uninstallers[0].FullName) {
        throw 'Uninstaller is still present; a reboot or manual inspection may be required before reinstalling.'
    }
    # Wait for SCM to finish removing the service. Never delete another service by name.
    $deadline = (Get-Date).AddSeconds(60)
    while (@(FindCouchService).Count) {
        if ((Get-Date) -gt $deadline) { throw 'Old service was not removed. Inspect uninstall.log before retrying.' }
        Start-Sleep -Seconds 1
    }
    RunSetup $InstallerPath @('/SP-', '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', '/RESTARTEXITCODE=3010',
        "/DIR=`"$InstallDirectory`"", '/TASKS="service"', "/LOG=`"$backup\install.log`"")
    $newServices = @(FindCouchService)
    if ($newServices.Count -ne 1) { throw 'Installer did not register exactly one Apache CouchDB service. See install.log.' }
    $newService = $newServices[0]
    CheckService $newService
    StopCouchService $newService
    AssertNoCouchProcesses
    CopyTree (Join-Path $backup 'installation\etc') (Join-Path $InstallDirectory 'etc')
    CopyTree (Join-Path $backup 'installation\var') (Join-Path $InstallDirectory 'var')
    foreach ($item in $external) { CopyTree $item.Backup $item.Original }
    Set-Service -Name $newService.Name -StartupType Automatic
    Start-Service -Name $newService.Name
    (Get-Service -Name $newService.Name).WaitForStatus('Running', [TimeSpan]::FromSeconds($StartupTimeoutSeconds))
    # Erlang assigns an installation-specific service name; use the discovered name.
    $couch = $newService.Name
    $serviceRegistryPath = Join-Path 'HKLM:\SYSTEM\CurrentControlSet\Services' $couch
    if (-not (Test-Path -LiteralPath $serviceRegistryPath)) {
        throw "Service registry key was not found: $serviceRegistryPath"
    }
    New-ItemProperty -LiteralPath $serviceRegistryPath -Name 'DelayedAutoStart' -PropertyType DWord -Value 2 -Force | Out-Null
    $serviceRegistryKey = Get-Item -LiteralPath $serviceRegistryPath
    if ($serviceRegistryKey.GetValue('DelayedAutoStart') -ne 2 -or
        $serviceRegistryKey.GetValueKind('DelayedAutoStart') -ne [Microsoft.Win32.RegistryValueKind]::DWord) {
        throw "Could not verify DelayedAutoStart as REG_DWORD 2 at $serviceRegistryPath"
    }
    Write-Host "Registry updated: $serviceRegistryPath\DelayedAutoStart = 2 (REG_DWORD)"
    $deadline = (Get-Date).AddSeconds($StartupTimeoutSeconds)
    $healthy = $false
    $authenticationRequired = $false
    $lastFailure = ''
    do {
        try {
            $request = @{ Uri = $HealthUri; TimeoutSec = 5; ErrorAction = 'Stop' }
            if ($Credential) { $request.Credential = $Credential }
            $response = Invoke-RestMethod @request
            if ($response.version -ne '1.6.1') { throw "Endpoint reports version '$($response.version)' instead of 1.6.1." }
            if ((Get-Service -Name $newService.Name).Status -ne 'Running') { throw 'Service stopped during verification.' }
            $healthy = $true
        } catch {
            $lastFailure = $_.Exception.Message
            $httpStatus = 0
            if ($_.Exception.PSObject.Properties['Response'] -and $_.Exception.Response) {
                $httpStatus = [int]$_.Exception.Response.StatusCode
            }
            if ($httpStatus -eq 401 -and -not $Credential) {
                if ((Get-Service -Name $newService.Name).Status -ne 'Running') {
                    throw 'Service stopped during verification.'
                }
                $authenticationRequired = $true
            }
        }
        if (-not $healthy -and -not $authenticationRequired) { Start-Sleep -Seconds 2 }
    } until ($healthy -or $authenticationRequired -or (Get-Date) -ge $deadline)
    if (-not $healthy -and -not $authenticationRequired) { throw "Health check failed: $lastFailure" }
    if ($authenticationRequired) {
        Write-Host 'Reinstall completed; service is Running with Automatic startup; DelayedAutoStart is REG_DWORD 2.'
        Write-Warning "Endpoint $HealthUri responded with HTTP 401 (authentication required). No credential was supplied; HTTP version and database access were not verified."
    } else {
        Write-Host "SUCCESS: CouchDB 1.6.1 is responding at $HealthUri; service startup is Automatic."
    }
    Write-Host "Retained backup and logs: $backup"
} catch {
    Write-Warning "Reinstall did not complete. Backup and logs: $backup. No automatic rollback was attempted."
    throw
} finally { Stop-Transcript | Out-Null }
