# Installing windows updates via Powershell

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Install-PackageProvider -Name NuGet

Install-Module PSWindowsUpdate -Force    Type A and press Enter to confirm. 

Get-WindowsUpdate    Type A and press Enter to confirm

# Script for Checking/Installing Nuget and PSWindows Updates
$ngt = Get-PackageProvider -Name NuGet
$winUp = Get-Package -Name PSWindowsUpdate 

Function Get-Ready{ 
Install-PackageProvider NuGet -Force;
Install-Module PSWindowsUpdate -Force;
Get-Package -Name PSWindowsUpdate; 
}

#Enable Scripts for All without restriction
Set-ExecutionPolicy bypass


if($ngt -and $winUp){
	Write-Host "You are already setup"
} else {
	Write-Host "NuGet and PSWindows Update Packages are being installed"
	 Get-Ready
    }


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Install-PackageProvider NuGet -Force

Set-PSRepository PSGallery -InstallationPolicy Trusted


# Check if restart is needed
 (Install-WindowsFeature Containers).RestartNeeded
 
# Restart computer
	Restart-Computer -Force

# Lists packages with the Nuget keyword in the current source, up to 50
Get-Package -ListAvailable -Filter Nuget

Install-PackageProvider NuGet -Force

Install-Module PSWindowsUpdate -Force
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot


Write-Host Get-RDone -ForegroundColor Green -BackgroundColor Black

### Windows Updates Verbose Setting 
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot -Verbose


#One potential problem that may arise is the use of deprecated security protocols. To address this, it's important to verify the existing TLS versions in use.

[PS] C:\>[Net.ServicePointManager]::SecurityProtocol
Ssl3, Tls
#The output indicates that SSL3 and TLS are currently supported, but TLS 1.2 is not enabled.

#Solution:

#If that's the case you need to enable TLS 1.2 or later on the system.

#Follow these steps:

#1. Execute the following cmdlets to set strong cryptography on 64-bit and on 32-bit

[PS] C:\>Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord

[PS] C:\>Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
#2. Restart PowerShell

#3. Verify if the security protocol TLS 1.2 has been added by running the command again, and the newly added Tls12 can be seen now

[PS] C:\>[Net.ServicePointManager]::SecurityProtocol
Ssl3, Tls, Tls12
#4. Finally, proceed to install your desired provider i.e

Install-PackageProvider NuGet -Force

Install-Package -Name Dotnet4.6.1

### OS Version Build Information 
Get-CimInstance -ClassName Win32_OperatingSystem | fl Name,Caption,Version,BuildNumber,InstallDate | Out-String | ForEach-Object { $_.Trim() }
Get-ComputerInfo | Select-Object WindowsProductName

https://download.microsoft.com/download/4/b/2/cd00d4ed-ebdd-49ee-8a33-eabc3d1030e3/NDP481-Web.exe

$url = "https://download.microsoft.com/download/4/b/2/cd00d4ed-ebdd-49ee-8a33-eabc3d1030e3/NDP481-Web.exe
"
$output = "$PSScriptRoot\10meg.test"
$start_time = Get-Date

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)
#OR
(New-Object System.Net.WebClient).DownloadFile($url, $output)

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"


$url = "https://github.com/PowerShell/PowerShell/releases/download/v7.5.0/PowerShell-7.5.0-win-x64.zip"
$output = "C:\users\Three Square Market\desktop\PowerShell-7.5.0-win-x64.zip"
$start_time = Get-Date

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)
#OR
(New-Object System.Net.WebClient).DownloadFile($url, $output)

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"


Install-PackageProvider NuGet -Force
Install-Module PSWindowsUpdate -Force
$ErrorActionPreference = "SilentlyContinue"

## Checking Storage 
$temp = (gci $env:TEMP\* | measure Length -s).sum / 1Gb
Write-Host "Used Space in Windows Temp Folder " $temp 
$old = (gci $env:WINDIR.old\* | measure Length -s).sum / 1Gb
Write-Host "Used Space WINDIR.old " $old 
$logs = (gci $env:WINDIR\Logs\* | measure Length -s).sum / 1Gb
Write-Host "Used Space WINDIR/LOGS " $logs 
$winUpd = (gci $env:WINDIR\Logs\WindowsUpdate\* | measure Length -s).sum / 1Gb
Write-Host "Used Space Windows Updates Logs " $winUpd 
$softDistr = (gci $env:WINDIR\SoftwareDistribution\Download\* | measure Length -s).sum / 1Gb
Write-Host "Used Space Software Distribution " $softDistr 
$otherTemp = (gci C:\users\"Three Square Market"\AppData\local\Temp\ | measure Length -s).sum / 1GB
Write-Host "Used Space Local Temp " $otherTemp 
$downloads = (gci C:\users\"Three Square Market"\Downloads | measure Length -s).sum / 1Gb
Write-Host "Used Space Download Folder " $downloads

#0
$freeSpace = ((Get-PSDrive C).free/ 1GB);
$usedSpace = ((Get-PSDrive C).used/ 1GB);

if((((Get-PSDrive C).free/ 1GB)/((Get-PSDrive C).used/ 1GB))*100 -gt 10){$true}else{$false};

 <# temp ​ GB Used TEMP
 old ​ GB Used WINDOWS.old
 logs ​ GB Used Logs
 winUpd ​ GB Used Windows Updates
 softDistr ​GB Used Software Distribution
 otherTemp ​ GB Used Local TEMP
 downloads ​ GB Used Download Folder #>
#In order to install the Nuget Package Manager non-interactively, simply use the -Force flag which bypasses prompting

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Install-PackageProvider NuGet -Force

Install-Module PSWindowsUpdate -Force

Get-Package -Name PSWindowsUpdate

Install-WindowsUpdate -MicrosoftUpdate

# Windows Update with auto 
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

Get-WindowsUpdate -AcceptAll -Install -AutoReboot

#Lists installed HOT Fixes and Windows Updates 
Get-HotFix



# Get all installed drivers that are available at Windows Update. Additionaly show pre search criteria.  
Get-WindowsUpdate -WindowsUpdate -UpdateType Driver -IsInstalled -ShowPreSearchCriteria -Verbose

# Install updates on remote computer. After all send a report from the installation process.
# Install-WindowsUpdate -ComputerName MG-PC -MicrosoftUpdate -AcceptAll -AutoReboot -SendReport -PSWUSettings 
# @{SmtpServer="your.smtp.server";From="sender@email.address";To="recipient@email.address";Port=25} -Verbose
# or use global PSWUSettings
# @{SmtpServer="your.smtp.server";From="sender@email.address";To="recipient@email.address";Port=25} | Export-Clixml 
# -Path 'C:\Program Files\WindowsPowerShell\Modules\PSWindowsUpdate\PSWUSettings.xml'
# Install-WindowsUpdate -ComputerName MG-PC -MicrosoftUpdate -AcceptAll -AutoReboot -SendReport -Verbose

# Install External module 
Install-PackageProvider -Name NuGet -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name PSWindowsUpdate

$folderPath = "C:\Program Files\Wireshark";

if (Test-Path -Path $folderPath) {
    Write-Host "Folder '$folderPath' exists."
} else {
    Write-Host "Folder '$folderPath' does not exist. Creating Folder Now"
    New-Item -Path "C:\Program Files\Wireshark" -ItemType Directory
};

# Checking Correct Path of PWS
(get-module -ListAvailable windowsupdateprov*).path
(get-module -ListAvailable windowsupdateprov*).ExportedCommands

#install specific updates:
Get-WindowsUpdate -AcceptAll -Install -KBArticleID KB2267602 -ForceInstall
Get-WindowsUpdate -AcceptAll -Install -KBArticleID KB2538242 -ForceInstall
Get-WindowsUpdate -AcceptAll -Install -KBArticleID KB2467173 -ForceInstall
Get-WindowsUpdate -AcceptAll -Install -KBArticleID KB5043124
	Options -ForceDownload -ForceInstall
	
# TSMX19-3690  -------    KB4550947    1GB 2020-04 Cumulative Update for Windo...
# TSMX19-3690  -------    KB5043124   12MB 2024-09 Servicing Stack Update for ...

Get-Command -Module PSWindowsUpdate | Sort-Object CommandType, Name

Get-WindowsUpdate -MicrosoftUpdate -UpdateID a4af463c-13b2-448a-badc-b117df61ca13

#Check update history:
Get-WUHistory

# Check History of Specific Update
Get-WUHistory | Where-Object { $_.KB -eq "KB5087537" }

#Get Available Updates
Get-WUlist -MicrosoftUpdate

#Get windows updates available from default service manager.
Get-WindowsUpdate -Verbose

# Schedule job at 6:00 PM to install update with UpdateId='ddb74579-7a1f-4d1f-80c8-e8647055314e' and 
#  RevisionNumber=200. Update will be automaticaly accepted and after all serwer will be automaticaly restarted if 
# needed.     
Get-WindowsUpdate -MicrosoftUpdate -UpdateID ddb74579-7a1f-4d1f-80c8-e8647055314e -RevisionNumber 200 -ScheduleJob 
(Get-Date -Hour 18 -Minute 0 -Second 0) -Install -AcceptAll -AutoReboot -Verbose
#or use alias
Install-WindowsUpdate -MicrosoftUpdate -UpdateID ddb74579-7a1f-4d1f-80c8-e8647055314e -RevisionNumber 200 
-ScheduleJob (Get-Date -Hour 18 -Minute 0 -Second 0) -AcceptAll -AutoReboot -Verbose
{
  "ip": "208.107.60.142",
  "hostname": "208-107-60-142-static.midco.net",
  "city": "Sioux Falls",
  "region": "South Dakota",
  "country": "US",
  "loc": "43.5500,-96.7003",
  "org": "AS11232 Midcontinent Communications",
  "postal": "57101",
  "timezone": "America/Chicago",
  "readme": "https://ipinfo.io/missingauth"
}
$url = "http://ipinfo.io"
$results = Invoke-RestMethod -Uri $url | Format-Table -Property city, region, country, org, timezone

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$results = Invoke-WebRequest "http://ipinfo.io" | ConvertFrom-Json


@{ip=166.226.63.252; hostname=252-63-226-166.mobile.uscc.net; city=Doylestown; region=Pennsylvania; country=US; loc=40.3101,-75.1299; org=AS6614 UNITED STATES CELLULAR TELEPHONE COMPANY (GREATER KNOXVILLE), L.P.; postal=18901; timezone=America/New_York; readme=https://ipinfo.io/missingauth}

# Schedule Job to install all available updates and automatically reboot system if needed. Also send report after 
# installation (but before reboot if needed) and send second instalation history report after reboot.
Set-PSWUSettings -SmtpServer smtp.office365.com -SmtpPort 587 -SmtpEnableSsl $true -SmtpSubject "PSWindowsUpdate 
Report" -SmtpTo mgajda@psmvp.pl -SmtpFrom mgajda@psmvp.pl -SmtpCredential (Get-Credential mgajda@psmvp.pl)
Install-WindowsUpdate -MicrosoftUpdate -SendReport -SendHistory -AcceptAll -AutoReboot -ScheduleJob (Get-Date
-Hour 18 -Minute 30 -Second 0) -ComputerName MG-PC -Verbose

#IP information 
$data = curl http://ipinfo.io  -UseBasicParsing | select -ExpandProperty content;

$results = $data | ConvertFrom-Json

Install-PackageProvider NuGet -Force; Get-Package -Name PSWindowsUpdate; Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot;

curl http://ipinfo.io  -UseBasicParsing | select -ExpandProperty content

#The operators are:

## && this will run the second command only if the first one succeeds.
## || this will run the second command only if the first one fails.


#C:\> Write-Host "This will succeed" && Write-Host "So this will run too"
# This will succeed
# So this will run too

# C:\> Write-Error "This is an error" && Write-Host "So this shouldn't run"
Write-Error "This is an error" && Write-Host "So this shouldn't run": This is an error

#C:\> Write-Host "This will succeed" || Write-Host "This won't run"
#This will succeed

##C:\> Write-Error "This is an error" || Write-Host "That's why this runs"
Write-Error "This is an error" || Write-Host "That's why this runs" 


Get-Content -Path "C:\users\Three Square Market\AppData\local\Temp\10-8-24-16-08.log"
Get-Content -Path "C:\Windows\Logs\DISM\dism.log"

C:\users\"Three Square Market"\AppData\local\Temp\

Get-Content -Path "C:\users\Three Square Market\Install.log"

Push-Location
Set-Location HKLM:\\SYSTEM\\CurrentControlSet\\services\\W32Time\\Parameters
Set-ItemProperty . NtpServer "ntp.pool.ntp.org"
Pop-Location

w32tm /config /manualpeerlist:ntp.pool.ntp.org /syncfromflags:manual /update

Stop-Service w32time
Start-Service w32time

$cleanmgrPath = “$env:SystemRoot\System32\cleanmgr.exe”
Start-Process $cleanmgrPath -ArgumentList “/sageset:65535 /sagerun:65535” -Wait

# Get the Current Date and Time 
# %A	Day of the week - full name
# %m	Month number
# %d	Day of the month - 2 digits
# %Y	Year in 4-digit format
# %R	Time in 24-hour format - no seconds
# %Z	Time zone offset from Universal Time Coordinate (UTC)
Get-Date -UFormat "Cleanup Completed on %a %m/%d %R"
$tZone = Get-Date -UFormat "%Z"
Get-Date -Format "dddd MM/dd/yyyy HH:mm"

$timezone = switch ( $tZone )
{
	-06
	{
		'EST'
	}
	
		
}
if((Get-Date -UFormat "%Z") -eq $est)
{
	
}


# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
Get-ItemProperty -Path $RegistryPath -Name $Name 
$RegistryPath = 'HKLM:\Software\WOW6432Node\StokedKiosk';$Name='QuickConnectPassword';Get-ItemProperty -Path $RegistryPath -Name $Name;

## Setting Day(s) to pause automatic updates
$pause = (Get-Date).AddDays(3) 
$pause = $pause.ToUniversalTime().ToString( "yyyy-MM-ddTHH:mm:ssZ" )
#Pause Updates for 3 days
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -Value $pause

Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches

#Pause Update for 35 Days
$pause = (Get-Date).AddDays(35); $pause = $pause.ToUniversalTime().ToString( "yyyy-MM-ddTHH:mm:ssZ" ); Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -Value $pause


Set-Service -DisplayName "Apache CouchDB" -StartupType AutomaticDelayedStart


Get-Process | Where-Object {$_.mainWindowTitle} | Format-Table Id, Name, mainWindowtitle -AutoSize

#Check Size of File before Removing 
(gci $env:TEMP\* | measure Length -s).sum / 1Gb
(gci $env:WINDIR.old\* | measure Length -s).sum / 1Gb
(gci $env:WINDIR\Logs\* | measure Length -s).sum / 1Gb
(gci $env:WINDIR\Logs\WindowsUpdate\* | measure Length -s).sum / 1Gb
(gci C:\Windows\SoftwareDistribution\Download | measure Length -s).sum / 1Gb 

(gci C:\users\"Three Square Market"\AppData\local\Temp\ | measure Length -s).sum / 1GB
(gci "C:\users\Three Square Market\Downloads" | measure Length -s).sum / 1Gb
(gci C:\users\"Three Square Market"\Desktop\ndp48-web.exe | measure Length -s).sum / 1Gb
(gci C:\users\"Three Square Market"\Downloads | measure Length -s).sum / 1Gb
(gci "C:\users\Three Square Market\Install.log" | measure Length -s).sum / 1Gb

C:\users\"Three Square Market"\Downloads

Remove-Item -Path "$env:TEMP\*" -Recurse -Force
Remove-Item -Path "C:\users\Three Square Market\AppData\local\Temp\*" -Recurse -Force
Remove-Item -Path "C:\users\Three Square Market\Downloads" -Recurse -Force
Remove-Item -Path "$env:WINDIR.old\*" -Recurse -Force
Remove-Item -Path "$env:WINDIR\Logs\WindowsUpdate\*" -Recurse -Force
Remove-Item -Path "$env:WINDIR\Logs\*" -Recurse -Force
Remove-Item -Path "$env:WINDIR\SoftwareDistribution\Download\*" -Recurse -Force

Remove-Item -Path "C:\users\Three Square Market\AppData\local\Temp\" -Recurse -Force

Remove-Item -Path ".\TsmKioskV2Installer v42.msi" -Force
Remove-Item -Path  ".\ndp48-web.exe" -Force

((Get-PSDrive C).used / 1GB)/((Get-PSDrive C).free / 1GB)

# Checking if a path exists 
Test-Path -Path "C:\users\Three Square Market\Desktop\dot NET SDK Demo\SDKDemo_Setup.msi" # Returns True/False 


Remove-Item -Path C:\Windows\SoftwareDistribution -Recurse -Force; 
Remove-Item -Path C:\Windows\System32\catroot2 -Recurse -Force

$folderPath = "cantaloupe" # Replace with the actual path
Get-ChildItem -Path $folderPath -Force | Remove-Item -Force -Recurse

# Pulseways Version of checking diskspace
Get-PSDrive -PSProvider FileSystem | Select-Object -Property @{Name='FreeSpace';Expression={$_.Free / 1GB}}, @{Name='TotalSize';Expression={$_.Used / 1GB}}

# Returns True if diskspace is above threshold otherwise returns false
if((((Get-PSDrive C).free/ 1GB)/((Get-PSDrive C).used/ 1GB))*100 -gt 10){$true}else{$false};

if((((Get-PSDrive C).used/ 1GB)/((Get-PSDrive C).free / 1GB))*100 -gt 10){Write-Host "Above 10% threshold"}

#Checking Credentials 
$c = Get-Credential -credential Users

## Check if Disk needs defrag
 Optimize-Volume -DriveLetter C -Analyze -Verbose
 
## To defrag Drive
 Optimize-Volume -DriveLetter C
 Optimize-Volume -DriveLetter C -Defrag -Verbose
 
## Get Computer Name 
$env:computername

# Restart from Terminal 
shutdown /r /f /t 0 #End can be replaced for a delayed restart /r reboot /f force /t time to restart

Optimize-Volume -DriveLetter C -ReTrim -Verbose

# Windows Updates
# Microsoft.Update.Session COM object can be used to check for active update sessions.
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$Searcher = $UpdateSession.CreateupdateSearcher()
$Searcher.IsBusy
# If $Searcher.IsBusy returns $true, an update search or installation is in progress.

# Windows Update involves several processes. A key process to check for is TiWorker.exe (Windows Modules Installer Worker
Get-Process TiWorker -ErrorAction SilentlyContinue

# Checks if the Windows Update Service is Running 
Get-Service wuauserv

## Disk Clean Counter
$RegPath = 'HKLM:\SOFTWARE\Tier2\Maintenance'
$RegName = 'diskCleanCounter'
$current = (Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue).$RegName
if ($current -gt 5){$supportNeeded = 'true'}

# Checks if a reboot is pending due to updates
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue) -ne $null

Function Get-Ready{ 
Install-PackageProvider NuGet -Force;
Install-Module PSWindowsUpdate -Force;
Get-Package -Name PSWindowsUpdate; 
}
Remove-Item -Path $env:TEMP\* -Recurse -Force;
Remove-Item -Path $env:windir\SoftwareDistribution\* -Recurse -Force;
Remove-Item -Path $env:windir\System32\LogFiles\* -Recurse -Force
#Setting the Registry Path
	$RegistryRootPath='HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches'
	#Creating the Group 1307 for cleanup option SetON
	$GroupNum='StateFlags1307'
	$ActiveTemp = "Active Setup Temp Folders"
	$TempSetupFiles = "Temporary Setup Files"
	$TempFolder = "Temporary Files"
	$DownloadFolder = "DownloadFolder"
	$DLProgFolder = "Downloaded Program Files"
	$DirectX = "D3D Shader Cache"
	$DeliveryOptFiles = "Delivery Optimization Files"
	$Thumbnails = "Thumbnail Cache"
	$Defender = "Windows Defender"
	$UpgradeDiscardedFiles = "Upgrade Discarded Files"
	$RecycleBin = "Recycle Bin"
	$UpdateCleanup = "Update Cleanup"
	$OldWinFiles = "Old ChkDsk Files"
	#Download Folder
	REG ADD $RegistryRootPath\$DownloadFolder /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	# Downloaded Program Folder 
	REG ADD $RegistryRootPath\$DLProgFolder /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	# DirectX Shader Cache
	REG ADD $RegistryRootPath\$DirectX /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	#Delivery Optimization Files
	REG ADD $RegistryRootPath\$DeliveryOptFiles /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	#Temporary Folders 
	REG ADD $RegistryRootPath\$TempFolder /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	REG ADD $RegistryRootPath\$ActiveTemp /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	REG ADD $RegistryRootPath\$TempSetupFiles /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	## Windows Defender Files
	REG ADD $RegistryRootPath\$Defender /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	#Thumbnails Cache
	REG ADD $RegistryRootPath\$Thumbnails /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	# Upgrade Discarded Files 
	REG ADD $RegistryRootPath\$UpgradeDiscardedFiles /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	# Empty Recycle Bin
	REG ADD $RegistryRootPath\$RecycleBin /v $GroupNum /t REG_DWORD /d $OptionalCleaning /f
	#Windows Update Cleanup/Old Copies of Windows used for rolling back
	## These option clears a lot of storage
	REG ADD $RegistryRootPath\$UpdateCleanup /v $GroupNum /t REG_DWORD /d $SetON /f
	REG ADD $RegistryRootPath\$OldWinFiles /v $GroupNum /t REG_DWORD /d $SetON /f

# Check if running in non-interactive mode and procceeding to install the correct items 
if ($Host.UI.SupportsVirtualTerminal) {
    # Use ShouldContinue only in interactive mode
    if ($PSCmdlet.ShouldContinue("Are you sure you want to proceed?", "Confirmation")) {
        # Perform the action
		Install-Module PSWindowsUpdate
    }
} else {
    # Perform the action without confirmation in non-interactive mode
	Install-PackageProvider NuGet -Force
	Install-Module PSWindowsUpdate -Force
}

if ($Host.UI.SupportsVirtualTerminal) {if ($PSCmdlet.ShouldContinue("Are you sure you want to proceed?", "Confirmation")) {Install-Module PSWindowsUpdate}} else {Install-Module PSWindowsUpdate -Force}



Get-ChildItem -Path C:\users\* -Recurse | Measure-Object -Property Length -Sum

#Creation Date of Windows Installation 

# Installation CreationCreation Date of PC
(Get-CimInstance -Class Win32_OperatingSystem).InstallDate
([WMI]'').ConvertToDateTime((Get-WmiObject Win32_OperatingSystem).InstallDate)


$RegistryPath = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches';$OldWinFiles = "Old ChkDsk Files";Get-ItemProperty -Path $RegistryPath -Name $OldWinFiles;

# Date
 


strComputer = “TSM19-3990”

Set objWMIService = GetObject(“winmgmts:\\” & strComputer & “\root\cimv2”)


Set objWMIService = GetObject(“winmgmts:\\” & $strComputer & “\root\cimv2”)


Get-WUHistory | Where-Object {$_.KB -eq "KB5087544"}

Get-ChildItem -Path C:\users\ -Recurse -Directory | sort length | select -last 1

dir $env:USERPROFILE -Recurse -File | sort length | select -last 1


$value = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\BITS'
$value

HKLM:\SYSTEM\CurrentControlSet\Services\Background Intelligent Transfer Service

# Specify the registry key path and value name
$keyPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\Apache CouchDB01db5089bc8472e0';
$valueName = 'Start'

# Get the value of the registry key
$value = Get-ItemPropertyValue -Path $keyPath -Name $valueName

# Print the value
$value

## Check is CouchDB is running 
Get-Service -DisplayName "Apache CouchDB" | Select-Object -Property Name, StartType, Status

#Latest Installed Windows Updates 
wmic qfe list

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Apache CouchDB01db5089bc8472e0' -Name Start -Value 2

# Scripts from Pulseway 
# Quick Connect:

$QuickConnectPassword = "00951854"
$RegistryPath = 'HKLM:\Software\WOW6432Node\StokedKiosk'
$Name         = 'QuickConnectPassword'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $QuickConnectPassword -PropertyType String -Force

## Getting the Details of an item 
Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion -Name "ProgramFilesDir"

# DelayedAutoStart Value 1

#Password Generator
$num = Get-Random -Maximum 16
$uri = "https://random-word-api.herokuapp.com/word?length=" + $num
$word1 = Invoke-RestMethod -Uri $uri
$word1 = ( Get-Culture ).TextInfo.ToTitleCase( $word1 )
$num = 20 - $num
$uri = "https://random-word-api.herokuapp.com/word?length=" + $num
$word2 = Invoke-RestMethod -Uri $uri
$word2 = ( Get-Culture ).TextInfo.ToTitleCase( $word2 )
$symbol = @('.','!','@',':','
','?','+','=','-','_','%','$','#','^','&','*')
$date = Get-Date
$num = Get-Random -Minimum 1 -Maximum ($symbol.count+1)
$pass = (Get-Random -Maximum 10).toString() + $word1 + $symbol[$num] + $word2 + " Date of Creation " + $date.toString()
Write-Host $pass
Add-Content -Path .\Password.txt -Value $pass



## Checking if Program is installed
Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | ForEach-Object {
    Get-ItemProperty $_.PSPath | Where-Object { $_.DisplayName -like "*Chrome*" }
}



#Power Settings 
Set-CimInstance -Query 'SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE "USB\\%"' -Namespace root/WMI -Property @{Enable = $false}

#Rename TSMCopyUpdateFiles.exe
Rename-Item -Path "c:\Program Files (x86)\Turnkey Corrections\Three Square Meals\TsmCopyUpdateFiles.exe.bak" -NewName "TsmCopyUpdateFiles.exe"

# Import the Windows Update module
Import-Module PSWindowsUpdate

Install-PackageProvider NuGet -Force;Install-Module PSWindowsUpdate -Force;
# Get the update history
$updateHistory = Get-WUHistory

Get-WUHistory -Last 30 | Select-Object -Property Date, Title | Where-Object {$_.Date -match "1/22/2025*"} | Format-Table -AutoSize

# Display the update history with size
$updateHistory | Select-Object Date, Title, KBArticleID, SizeInBytes / 1MB | Format-List

# Get Size of Specific Updates 
(Get-WUList | Where-Object {$_.KBArticleID -eq "KB5063709"}).SizeInBytes / 1MB 

# Getting the size of windowes updates
Get-WUHistory | Select-Object -Property Date, Result | Format-Table -AutoSize

# Windows update history formatted 
Get-WUHistory -Last 30 | Select-Object -Property Date, Result | Format-Table -AutoSize -Wrap

# Get size of all available updates
(Get-WUList | Measure-Object -Sum SizeInBytes).Sum / 1GB

(Get-WUHistory | Measure-Object -Sum Size).Sum / 1MB

Get-WUHistory | Select-Object -Property Date, Title | Where-Object {$_.Title -match "KB5063709"} | Format-Table -AutoSize -Wrap

# Checking Device Manager from Powershell
Get-PnpDevice | Where-Object { $_.FriendlyName -match 'MEI ' } | Format-Table -Autosize

# Checks all devices 
Get-PnpDevice -PresentOnly | Format-Table -AutoSize

# Get details of  Ports and USB devices
Get-PnpDevice -PresentOnly -Class 'Ports', 'USB' | Format-Table -Property Name, Friendlyname, InstanceId -AutoSize

# Get PnP devices with the status ERROR DEGRADED UNKNOWN
Get-PnpDevice -PresentOnly -Status ERROR,DEGRADED,UNKNOWN | Format-Table -AutoSize

#Get Property for PnP Device
Get-PnpDeviceProperty -InstanceId "USB\VID_0000&PID_0001\6&38339FE&0&4" 
Get-PnpDeviceProperty -InstanceId "USB\VID_0000&PID_0001\6&38339FE&0&4"  | Format-Table -AutoSize -Wrap

# Get Update History with Sizes
## Retrieve the update history using Get-WUHistory.
## Select the Title, UpdateID, and Date of the updates.
## Calculate the size of each update in megabytes (MB) and add it as a new column.
Get-WUHistory | Select-Object -Property Date, @{Name="Size (MB)"; Expression={$_.Size / 1MB}}, UpdateID

# List of Available Updates and the Size
Get-WUList | Select-Object Title, KBArticleID, SizeInBytes

# Check if a reboot is required for Windows Updates
Get-WUIsPendingReboot

$PendingRebootInfo = Get-PendingReboot
If ($PendingRebootInfo.IsSystemRebootPending) {
	Write-log "Pending Reboots found"
	If ($runningTaskSequence) {
		Write-log "INSIDE TASK SEQUENCE: Ignoring pending reboots" -Severity 2

	} Else {
		Write-log "NOT Running inside a task sequence. " -Severity 2

	}		
} Else {
	Write-Log "No pending reboot detected. Continuing install..." 
}

Install-Module PendingReboot
# The RebootPending value at HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing
# The RebootRequired value at HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update
# The PendingFileRenameOperations value at HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager



(Test-PendingReboot -Detailed | Select-Object -ExpandProperty PendingFileRenameOperationsValue) |
ForEach-Object {$_}

function Test-PendingReboot
{
    if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $true }
    if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $true }
    if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
    if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\ControlSet001\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
    if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\ControlSet002\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }

    try 
    { 
    $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
    $status = $util.DetermineIfRebootPending()
    if(($status -ne $null) -and $status.RebootPending)
    {
        return $true
    }
    }
    catch
    {
    }

 return $false
}

## Windows Updates 
Get-WUList | Format-Table -AutoSize
Get-WUList -Criteria Important ## Important Updates
Get-WUList -Classification SecurityUpdates ## Only Security Updates
### Get all installed drivers that are available at Windows Update. Additionaly show pre search criteria.
Get-WindowsUpdate -WindowsUpdate -UpdateType Driver -IsInstalled -ShowPreSearchCriteria -Verbose

## Get Help and Examples of a Get Command
Get-Help Get-WindowsUpdate -Examples

# Get Services Running
Get-Service | Where-Object {$_.Status -eq "Running"}

# Get Service with Windows in the Display Name 
Get-Service -Displayname "*window*"

Get-Service -Displayname "Windows Update" | Where-Object {$_.Status -eq "Running"}


# See what Processes are using the most memory 
Get-Process | Sort-Object WorkingSet -Descending

# See what Processes are using the most CPU
Get-Process | Sort-Object CPU -Descending

#If you want to measure the time taken for specific commands to execute (to analyze their performance),
#use the Measure-Command cmdlet. This is useful for testing how long particular tasks or scripts take to 
#run.
#For example, to measure how long it takes to retrieve a list of processes:
Measure-Command { Get-Process }

# Method 3: Using WMI (Windows Management Instrumentation)
# WMI provides a way to access system information, including network statistics:
Get-WmiObject -Class Win32_PerfFormattedData_Tcpip_NetworkInterface | Select-Object -Property Name, BytesSentPersec, BytesReceivedPersec

# Get Event Logs 
Get-EventLog -LogName System -Newest 10

# Event logs filtered by errors 
Get-EventLog -LogName Application -EntryType Error -Newest 10 | Format-Table -AutoSize

# Restart PC and boot into BIOS without pushing the key to enter bios 
shutdown /r /fw

# Check Firewalls Rules
Get-NetFirewallRule

# Check the PowerShell Execution Policy
Get-ExecutionPolicy -List

# Check if current session is ran in admin mode
[Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent().IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")


## Scheduling Updates to install at certain times 
# Schedule job at 6:00 PM to install update with UpdateId='ddb74579-7a1f-4d1f-80c8-e8647055314e' and 
  #  RevisionNumber=200. Update will be automaticaly accepted and after all serwer will be automaticaly restarted if 
   # needed. 
    
    Get-WindowsUpdate -MicrosoftUpdate -UpdateID ddb74579-7a1f-4d1f-80c8-e8647055314e -RevisionNumber 200 -ScheduleJob 
    (Get-Date -Hour 18 -Minute 0 -Second 0) -Install -AcceptAll -AutoReboot -Verbose
   # or use alias
    Install-WindowsUpdate -MicrosoftUpdate -UpdateID ddb74579-7a1f-4d1f-80c8-e8647055314e -RevisionNumber 200     -ScheduleJob (Get-Date -Hour 18 -Minute 0 -Second 0) -AcceptAll -AutoReboot -Verbose

Get-WindowsUpdate -Criteria \"(UpdateID = #'ddb74579-7a1f-4d1f-80c8-e8647055314e' 
   # and RevisionNumber = 200)\" -AcceptAll -AutoReboot -Download -Install -MicrosoftUpdate -Verbose *>&1 | Out-File 
$Env:TEMP\PSWindowsUpdate.log



# Checking .NET Version Installed
$release = Get-ItemPropertyValue -LiteralPath 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -Name Release
switch ($release) {
    { $_ -ge 533320 } { $version = '4.8.1 or later'; break }
    { $_ -ge 528040 } { $version = '4.8'; break }
    { $_ -ge 461808 } { $version = '4.7.2'; break }
    { $_ -ge 461308 } { $version = '4.7.1'; break }
    { $_ -ge 460798 } { $version = '4.7'; break }
    { $_ -ge 394802 } { $version = '4.6.2'; break }
    { $_ -ge 394254 } { $version = '4.6.1'; break }
    { $_ -ge 393295 } { $version = '4.6'; break }
    { $_ -ge 379893 } { $version = '4.5.2'; break }
    { $_ -ge 378675 } { $version = '4.5.1'; break }
    { $_ -ge 378389 } { $version = '4.5'; break }
    default { $version = $null; break }
}

if ($version) {
    Write-Host -Object ".NET Framework Version: $version"
} else {
    Write-Host -Object '.NET Framework Version 4.5 or later is not detected.'
}


# Install .NET via PowerShell
iex ((New-Object System.Net.WebClient).DownloadString('https://download.microsoft.com/download/F/3/A/F3A8E590-3080-4CEB-B6A2-5609A6A7B5A9/dotnetfx48_Full_x86_x64.exe')) | Invoke-Expression



Start-Process -FilePath 'C:\users\Three Square Market\Desktop\net48-offline-installer' -ArgumentList '/install'



#Download .NET 4.8 framework via PowerShell 
$source = 'https://download.microsoft.com/download/4/b/2/cd00d4ed-ebdd-49ee-8a33-eabc3d1030e3/NDP481-Web.exe';
$destination = 'C:\users\Three Square Market\Desktop\NDP481-Web.exe';
Invoke-WebRequest -Uri $source -OutFile $Destination; 


### More Winget ###
$source ='https://github.com/microsoft/winget-cli/releases/download/v1.10.340/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle';
$destination = 'C:\users\Three Square Market\Desktop\Microsoft.DesktopAppInstaller.msixbundle';
Invoke-WebRequest -Uri $source -OutFile $Destination;
#$WebClient = New-Object System.Net.WebClient;
#$WebClient.DownloadFile($source,$destination);
add-appxpackage -Path "C:\Users\Three Square Market\Downloads\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

# Attempting to get Winget to install 
taskkill /im AppInstaller.exe /f

Start-Process "shell:Local AppData\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"

Get-AppxPackage -allusers Microsoft.DesktopAppInstaller | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}


Get-LocalUser -Name "Three Square Market" | Enable-LocalUser

Enable-LocalUser -Name "Three Square Market"

# You can try the following steps to fix the problem: 

# 1. Reset the update component and clean up the component residue, run CMD with administrator privileges and enter the following commands in order 

net stop wuauserv 

net stop cryptSvc 

net stop bits 

net stop msiserver 

ren C:\Windows\SoftwareDistribution\ SoftwareDistribution.old1 

net start wuauserv 

net start cryptSvc 

net start bits 

net start msiserver 

dism /online /cleanup-image /startcomponentcleanup 

# Reboot your device 
 

# 2. To execute the System Repair command, in the search box on the taskbar, type Command Prompt, select Run as administrator, and then execute the following commands in order: 
#### Ran in the Terminal Not PowerShell
dism.exe /online /cleanup-image /restorehealth 
#Powershell ##############
Get-ChildItem - Path "C:\Windows\Logs\DISM\dism.log"
#### Ran in the Terminal Not PowerShell
sfc /scannow
findstr.exe /c:"[SR] Cannot repair member file" %windir%\Logs\CBS\CBS.log >"C:\Users\lnelson\OneDrive - Cantaloupe, Inc\Desktop\Tier_2_Cases\Docs_ResearchSFCResults-Unrepairables.Log"

    DISM /Online /Cleanup-Image /CheckHealth
    DISM /Online /Cleanup-Image /ScanHealth
    DISM /Online /Cleanup-Image /RestoreHealth

# $directoryPath = "C:\ProgramData\ssh" $acl = Get-Acl -Path $directoryPath $sddlString = "O:BAD:PAI(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICI;0x1200a9;;;AU)" $securityDescriptor = New-Object System.Security.AccessControl.RawSecurityDescriptor $sddlString $acl.SetSecurityDescriptorSddlForm($securityDescriptor.GetSddlForm("All")) Set-Acl -Path $directoryPath -AclObject $acl

# $directoryPath = "C:\ProgramData\ssh\logsh" 
# $acl = Get-Acl -Path $directoryPath 
# $sddlString = "O:BAD:PAI(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICI;0x1200a9;;;AU)" 
# $securityDescriptor = New-Object System.Security.AccessControl.RawSecurityDescriptor $sddlString 
# $acl.SetSecurityDescriptorSddlForm($securityDescriptor.GetSddlForm("All")) 
# Set-Acl -Path $directoryPath -AclObject $acl

# 5809
# 4454619


#Fixing Registry Keys 
function Check-RegistryKeys {
    $regRoots = @("HKCR:", "HKCU:", "HKLM:", "HKU:", "HKCC:")
    foreach ($root in $regRoots) {
        Write-Host "Testing keys in $($root)..."
        Get-ChildItem -Path $root -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            $keyPath = $_.FullName
            try {
                [void](Get-Item -Path $keyPath -ErrorAction Stop)
            } catch {
                Write-Warning "Corrupted key found: $keyPath - $($_.Exception.Message)"
            }
        }
    }
}Check-RegistryKeys

# KB5050008 Updates may not be compatible with certain components or configurations in the system, causing Remote Assistance to not work properly. The COM object interaction failure mentioned in the event log may be due to some system component not being updated or registered correctly.

# 1. Repair or re-register the COM component. Open the Command Prompt (cmd) with administrator privileges and run the following command to re-register the relevant COM component:

regsvr32 /u msrdp.ocx

regsvr32 msrdp.ocx

# Restart the server to apply the changes.

# 2. Make sure that the network settings for Remote Assistance and Remote Desktop Services are correct and that the firewall is not blocking the relevant port (e.g. 3389). Check the user's permissions to make sure they have permission to log in remotely.

# 3. Make sure that the system has installed all the necessary updates, especially those related to Remote Desktop Services. If an KB5050008 update is causing problems, you can try uninstalling the update and then reinstalling it to make sure the update process completes correctly.

# 4.Open the Event Viewer and navigate to: Applications and Services Logs>Microsoft>Windows>RemoteDesktopServices-RdpCoreTS and TerminalServices-LocalSessionManager, check whether the error message is reported at the point in time when the problem occurred.

# 5. Open the Group Policy Editor (gpedit.msc) on the target server, navigate to: Computer Configuration\Administrative Templates\Windows Components\Remote Desktop Services\Remote Desktop Session Host\Security，disable“Require user authentication for remote connections by using Network Level Authentication”, then enable“Require use of specific layer for remote(RDP) connections”，And change the security layer to the RDP security layer.

# Open cmd with administrator privileges, run gpupdate /force to make the modification take effect, restart the server, and then try to connect remotely to see if the problem can be reproduced.

### Attempting to Install Winget ###
$progressPreference = 'silentlyContinue'
Write-Host "Installing WinGet PowerShell module from PSGallery..."
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery -Scope AllUsers | Out-Null
Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
Repair-WinGetPackageManager -IncludePrerelease
Write-Host "Done."
winget install -e --id Microsoft.DotNet.Framework.DeveloperPack_4
winget install -e --id Microsoft.DotNet.Framework.DeveloperPack_4
#install the microsoft store for all users 
Get-AppxPackage -AllUsers Microsoft.WindowsStore* | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\\AppXManifest.xml\"}
C:\Users\Three Square Market\Desktop\winget.install\winget-install
Add-AppxProvisionedPackage -Online -PackagePath "c:\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -SkipLicense



## Power Management Troubleshooting ###
# Lists existing power schemes with (*) being the active plan
powercfg /list

# command will display a list of devices that are currently allowed to wake up the system from sleep
powercfg /devicequery wake_armed

# prevent a USB device from waking up the system
powercfg /devicedisablewake "Device Name" ## Device name is the USB Device you wish to target

## Is Fastboot enabled 
(Get-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power").GetValue("HiberbootEnabled") # 0 is off 1 is on 

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name 'HiberbootEnabled' -Value '0' -Type DWord # Turns off FastBoot

Set-CimInstance -Query 'SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE "USB\\%"' -Namespace root/WMI -Property @{Enable = $false} # Powersettings off 

$powerMgmt = Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root/WMI |
    Where-Object InstanceName -Like USB*

foreach ($p in $powerMgmt) {
    $p.Enable = $false
    Set-CimInstance -InputObject $p
}

get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" -Name StateFlags1307
#1. Press the Windows key + R on your keyboard to open the Run dialog box.
#2. Type "regedit" (without quotes) in the box and hit Enter.
#3. Navigate to this path in the registry editor: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\A4B195F5-8225-47EB-89C6-43CDD82A19B6
#4. Double-click on the "Attributes" key on the right-hand side.
#5. Change the value from 1 to 2.
#6. Click "OK" to save the changes.


## HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power
Get-ItemPropertyValue -LiteralPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name HiberbootEnabled
Get-ItemProperty -Path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name HiberbootEnabled
## HiberbootEnabled DWORD

## 0 = Turn off fast startup
## 1 = Turn on fast startup


# Checking the last boot time of PC
    (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
# Last system restart
	(get-date)–(gcim Win32_OperatingSystem).LastBootUpTime
# Displays the Computer Name and the last boot time 
	Get-CimInstance -ClassName win32_operatingsystem | select csname, lastbootuptime
# To force apps to close and to restart the local computer after a one-minute delay, with the reason Application: Maintenance (Planned) and the comment "Reconfiguring myapp.exe", type:	
shutdown /r /t 600 /c "Scheduled Reboot" /f /d p:4:1	
	
# Scripts to add to pulseway 
$status = Get-WUlist -MicrosoftUpdate
Write-Host $status

$status = Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
Write-Host $status



Get-WUlist -MicrosoftUpdate | Format-Table -Property Size, Title -Autosize

### Resetting USB Ports | Checking the value of the Registry editor ####
$keypath = "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR"
$valueName = "Start"
$valueData = Get-ItemProperty -Path $keyPath -Name $valueName
Write-Host "The Value of $valueName is $(valueData.Start)"

#####################################
#Checking the value of Registry Key #
#####################################
$keyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR"
$valueName = "Start"
try {
    $valueData = Get-ItemProperty -Path $keyPath -Name $valueName -ErrorAction Stop
    Write-Host "Value exists: $($valueData.$valueName)"
} catch {
    Write-Host "Value does not exist"
}

Get-PnpDevice -PresentOnly -Class USB | Enable-PnpDevice
Get-PnpDevice -PresentOnly -Class USB | Disable-PnpDevice


#### Disabling | Reanabling USB Devices
$disbRslts = 'No Diggity'
$enblRslts = 'No Scrubs'
function Get-USBDisabled{
Set-Service -Name "USBSTOR" -StartupType Disabled
$disbRslts = Get-PnpDevice -PresentOnly -Class 'Ports', 'USB','Biometric' | Format-Table -Property Status, Friendlyname
}
function Get-Sleepytime{
Start-Sleep -Seconds 30
}
function Get-USBEnabled{

Set-Service -Name "USBSTOR" -StartupType Automatic
$enblRslts = Get-PnpDevice -PresentOnly -Class 'Ports', 'USB','Biometric' | Format-Table -Property Status, Friendlyname
}

Get-USBDisabled
Write-Host $disbRslts
Get-Sleepytime
Get-USBEnabled
Write-Host $enblRslts


    Set-Service -Name "USBSTOR" -StartupType Disabled
    Start-Sleep -Seconds 5
    Set-Service -Name "USBSTOR" -StartupType Automatic

pnputil.exe
## Registry Key Value 
$keyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\USB"
$valueName = "DisableSelectiveSuspend"
try {
    $valueData = Get-ItemProperty -Path $keyPath -Name $valueName -ErrorAction Stop
    Write-Host "Value exists: $($valueData.$valueName)"
} catch {
    Write-Host "Value does not exist"
}

Get-PowerPlan | Where-Object {$_.Active}
Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan | Where-Object {$_.IsActive} | Format-Table ElementName, InstanceID
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

    powercfg /setvalue SCHEME_CURRENT SUB_USB USBSELECTIVESUSPEND 0
    powercfg /query SCHEME_CURRENT SUB_USB USBSELECTIVESUSPEND
	 
#Disable USB Selective Suspend on Battery#
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
#Enable USB Selective Suspend on Battery#
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
#Disable USB Selective Suspend on Plugged in#
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
#Enable USB Selective Suspend on Plugged in#
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

#Add or Remove "Hub Selective Suspend Timeout" in Power Options#
#Remove Hub timeout#
powercfg -attributes 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 +ATTRIB_HIDE
#Add hub timeout#
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683 /v Attributes /t REG_DWORD /d 2 /f


Function Get-Ready{ 
	Install-PackageProvider NuGet -Force
	Install-Module PSWindowsUpdate -Force
	Get-Package -Name PSWindowsUpdate
} Get-Ready



#Check if Selective Suspend is Enabled#
$powerPlan = Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan | Where-Object {$_.IsActive}
$powerGuid = $powerPlan.InstanceID.Substring(14, 38)
$usbSettings = powercfg /Q $powerGuid 48e6b7ab-86f5-4da9-b22b-65792ed6a78a
if ($usbSettings -match "Attribute sub setting: 00 \(Enabled\)"){
    Write-Host "USB selective suspend is enabled."
} elseif ($usbSettings -match "Attribute sub setting: 01 \(Disabled\)"){
    Write-Host "USB selective suspend is disabled."
} else {
    Write-Host "Unable to determine USB selective suspend status."
}


$powerPlan = Get-CimInstance -ClassName Win32_PowerPlan -Filter "IsActive = TRUE"
$powerGuid = $powerPlan.InstanceID.Substring(14, 38)
$usbSettings = powercfg /Q $powerGuid 48e6b7ab-86f5-4da9-b22b-65792ed6a78a
if ($usbSettings -match "Attribute sub setting: 00 \(Enabled\)"){
    Write-Host "USB selective suspend is enabled."
} elseif ($usbSettings -match "Attribute sub setting: 01 \(Disabled\)"){
    Write-Host "USB selective suspend is disabled."
} else {
    Write-Host "Unable to determine USB selective suspend status."
}


#Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB\VID_0BED&PID_1101\47280176830\Device Parameters
#EnablePowerManagement
HKLM:\SYSTEM\CurrentControlSet\Enum\USB\VID_0BED&PID_1101\47280176830\Device Parameters
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\USB\VID_0BED&PID_1101\47280176830\Device Parameters" -Name EnablePowerManagement -Value 0

$valueName = "EnablePowerManagement"
try {
    $valueData = Get-ItemProperty -Path $keyPath -Name $valueName -ErrorAction Stop
    Write-Host "Value exists: $($valueData.$valueName)"
} catch {
    Write-Host "There is no Spoon"
}



#Corrupted Registry Keys#
# Outputs
$errorResult = "So long and thanks for the fish"
$testingResult = "Two lost souls swimming in a fish bowl."
function Check-RegistryKeys {
    $regRoots = @("HKCR:", "HKCU:", "HKLM:", "HKU:", "HKCC:")
    foreach ($root in $regRoots) {
        Write-Host "Testing keys in $($root)..."
        $testingResult = "Testing keys in $($root)..."
		Start-Process -FilePath "$env:PWY_HOME\CLI.exe" -ArgumentList ("setVariable testingResult ""$testingResult""") -Wait
        Get-ChildItem -Path $root -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            $keyPath = $_.FullName
            try {
                [void](Get-Item -Path $keyPath -ErrorAction Stop)
            } catch {
                Write-Warning "Corrupted key found: $keyPath - $($_.Exception.Message)"
                $errorResult = "Corrupted key found: $keyPath - $($_.Exception.Message)"
				Start-Process -FilePath "$env:PWY_HOME\CLI.exe" -ArgumentList ("setVariable errorResult ""$errorResult""") -Wait
            }
        }
    }
}Check-RegistryKeys

#Checking all keys in registry tree#
$reg = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\" -Recurse
$reg.Name

## Checking Registry KeyValue and creating if doesn't exist ##
$KeyPath = "HKCU:\Registry\Key\Path"  #Path you want to check
$ValueName = "name"  # Key Value you are looking for
$ValueData = "data"  # Value to change/add
try{  
    Get-ItemProperty -Path $KeyPath -Name $valueName -ErrorAction Stop  
}  
catch [System.Management.Automation.ItemNotFoundException] {  
    New-Item -Path $KeyPath -Force  
    New-ItemProperty -Path $KeyPath -Name $ValueName -Value $ValueData -Force  
}  
catch {  
    New-ItemProperty -Path $KeyPath -Name $ValueName -Value $ValueData -Type String -Force  
}  
$RegistryRootPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
$RegistryKeyValues = @(
    $RegistryRootPath"\"$ActiveTemp"\"$GroupNum,
    $RegistryRootPath"\"$TempSetupFiles"\"$GroupNum,
    $RegistryRootPath"\"$TempFolder"\"$GroupNum,
	$RegistryRootPath"\"$DownloadFolder"\"$GroupNum,
	$RegistryRootPath"\"$DLProgFolder"\"$GroupNum,
	$RegistryRootPath"\"$DirectX"\"$GroupNum,
	$RegistryRootPath"\"$DeliveryOptFiles"\"$GroupNum,
	$RegistryRootPath"\"$Thumbnails"\"$GroupNum,
	$RegistryRootPath"\"$Defender"\"$GroupNum,
	$RegistryRootPath"\"$UpgradeDiscardedFiles"\"$GroupNum,
	$RegistryRootPath"\"$RecycleBin"\"$GroupNum,
	$RegistryRootPath"\"$UpdateCleanup"\"$GroupNum,
	$RegistryRootPath"\"$OldWinFiles"\"$GroupNum
)

foreach ($KeyValue in $RegistryKeyValues) {
    if (Test-Path $KeyValue) {
        Write-Host "Key '$KeyValue' exists."
    } else {
        Write-Host "Key '$KeyValue' does not exist."
    }
}

$powerPlan = Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan | Where-Object {$_.IsActive}
$powerGuid = $powerPlan.InstanceID.Substring(21,36)
$usbSettings = powercfg /query $powerGuid 48e6b7ab-86f5-4da9-b22b-65792ed6a78a
if ($usbSettings -match "Attribute sub setting: 00 \(Enabled\)"){
    Write-Host "USB selective suspend is enabled."
} elseif ($usbSettings -match "Attribute sub setting: 01 \(Disabled\)"){
    Write-Host "USB selective suspend is disabled."
} else {
    Write-Host "Unable to determine USB selective suspend status."
}


# Current Power Plan - CGO24-10383 = 381b4222-f694-41f0-9685-ff5bb260df2e

# Power Saver = a1841308-3541-4fab-bc81-f71556f20b4a
# Balanced Power Plan = 381b4222-f694-41f0-9685-ff5bb260df2e
# High Performance = 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c


Microsoft:PowerPlan\{381b4222-f694-41f0-9685-ff5bb260df2e}
$powerGuid = $powerPlan.InstanceID.Substring(21,36)

$powerSaver = "a1841308-3541-4fab-bc81-f71556f20b4a"
$balanced = "381b4222-f694-41f0-9685-ff5bb260df2e"
$highPerformance = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
$ultimatePerformance = "e9a42b02-d5df-448d-aa00-03f14749eb61"

$powerPlan = Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan | Where-Object {$_.IsActive}
$powerGuid = $powerPlan.InstanceID.Substring(21,36)
if($powerGuid -eq $powerSaver){
	Write-Host "Active Plan: Power Saver: " $powerGuid
} elseif ($powerGuid -eq $balanced){
	Write-Host "Active Plan: Balanced: " $powerGuid
} elseif ($powerGuid -eq $highPerformance){
	Write-Host "Active Plan: High Performance: " $powerGuid
} elseif ($powerGuid -eq $ultimatePerformance) {
	Write-Host "Active Plan: Ultimate Performance " $powerGuid
} else {
	Write-Host "Not sure what you have but it must be awesome or really bad"
}
Get-CimInstance -Query 'SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE "USB\\%"' -Namespace root/WMI
Get-WmiObject -Namespace root\cimv2\power -Class win32_PowerPlan | Select-Object ElementName, IsActive
powercfg /L
powercfg /query <GUID>
Get-PowerPlan
$activeMenu = powercfg /getactivescheme
$activeGUID = ($activeMenu | Select-String -Pattern "GUID" | ForEach-Object {$_.Matches} | ForEach-Object {$_.Value} | Select-String -Pattern "{[a-f0-9-]*}" | ForEach-Object {$_.Matches} | ForEach-Object {$_.Value})
Write-Host "Active Power Plan GUID: $activeGUID"
#Here's how to retrieve the Product ID (PID) of a USB device using PowerShell:
#List Connected USB Devices: Use the Get-PnpDevice cmdlet to retrieve a list of all Plug and Play devices currently connected to the system. Filter the results to show only USB devices using the Where-Object cmdlet and the -match operator to find devices with "USB" in their InstanceId.
#Code

#    Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' }
#Extract PID from InstanceId: The InstanceId property of each USB device contains the Vendor ID (VID) and PID. To extract the PID, use the -match operator again with a regular expression to capture the PID value.
#Code

#    $usbDevices = Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' }
#    foreach ($device in $usbDevices) {
#        if ($device.InstanceId -match 'VID_(?<vid>[0-9A-F]{4})&PID_(?<pid>[0-9A-F]{4})') {
#            Write-Host "Device: $($device.FriendlyName), PID: $($Matches.pid)"
#        }
#    }
# This script retrieves all present USB devices and then iterates through them. For each device, it checks if the InstanceId matches the pattern VID_XXXX&PID_XXXX, where XXXX represents hexadecimal values. If it matches, it extracts the PID using the named capture group (?<pid>...) and prints the device name along with its PID.
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USB" -Name "DisableSelectiveSuspend" -Value 1 -Type DWord
	Get-CimInstance -Query 'SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE "USB\\%"' -Namespace root/WMI -Property @{Enable = $false}
	foreach ($entry in $powerMgmt){ Write-Host $entry.Enable " " $entry.InstanceName}

# Need to install for certain commands to work #
Function Get-Ready{ 
	Install-PackageProvider NuGet -Force
	Install-Module PSWindowsUpdate -Force
	Get-Package -Name PSWindowsUpdate
} Get-Ready

# Checking the Active Powerplan #
function Get-SetPowerPlan{
	# Available Power Plans #
	$powerSaver = "a1841308-3541-4fab-bc81-f71556f20b4a"
	$balanced = "381b4222-f694-41f0-9685-ff5bb260df2e"
	$highPerformance = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
	$ultimatePerformance = "e9a42b02-d5df-448d-aa00-03f14749eb61"
	# Checking the current set power plan #
	$powerPlan = Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan | Where-Object {$_.IsActive}
	$powerGuid = $powerPlan.InstanceID.Substring(21,36)
	# Displays the active Power Plan #
	if($powerGuid -eq $powerSaver){
		Write-Host "Active Plan: Power Saver: "
	} elseif ($powerGuid -eq $balanced){
		Write-Host "Active Plan: Balanced: "
	} elseif ($powerGuid -eq $highPerformance){
		Write-Host "Active Plan: High Performance: "
	} elseif ($powerGuid -eq $ultimatePerformance) {
		Write-Host "Active Plan: Ultimate Performance "
	} else {
		Write-Host "Not sure what power plan you have but it must be awesome or really bad " $powerGuid
	}
} Get-SetPowerPlan

# Checking the Power management settings #
function Get-PowerMgmt {
	$status = (Get-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power").GetValue("HiberbootEnabled")
	if ($status -eq 1) {
		Write-Host "----Fast Boot is Enabled"
	}
	$powerMgmt = Get-CimInstance -Query 'SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE "USB\\%"' -Namespace root/WMI
	Write-Host "Active -- Enable -- InstanceName" 
	foreach ($entry in $powerMgmt){ 
		if($entry.Enable -eq "True"){
			Write-Host "Active PowerMgmt---"$entry.Enable"--"$entry.InstanceName
		} else {
			Write-Host "No Active PowerMgmt--"$entry.Enable"--"$entry.InstanceName
		}
	}
} Get-PowerMgmt
	
# Checking USBStor to see if enabled #
function Get-USBRegistryStatus {
	$keyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR"
	$valueName = "Start"
	try {
		$valueData = Get-ItemProperty -Path $keyPath -Name $valueName -ErrorAction Stop
		if($valueData.$valueName -eq 3){
			Write-Host "USB ports are set to automatic start"
		} else {
			Write-Host "USB Automatic Start is disabled" 
		}
	} catch {
		Write-Host "Value does not exist"
	}
} Get-USBRegistryStatus

# Checking PNP devices connected to PORTS #
function Get-PNPConnectedDevices {
	$results = Get-PnpDevice -PresentOnly -Class 'Ports', 'USB', 'Biometric'
	foreach ( $result in $results) {
		Write-Host $result.Status " " $result.FriendlyName 
	}
} Get-PNPConnectedDevices	





foreach( $result in $results) {if($result.Status -eq'OK'){Write-Host "Device " $result.FriendlyName " should be working"}};


# Windows Version Build Number #

$osVersion = Get-CimInstance -ClassName Win32_OperatingSystem | fl Caption
$osBuild = Get-CimInstance -ClassName Win32_OperatingSystem | fl Caption,BuildNumber

# To get properties of a file or directory, use Get-Item or Get-ChildItem followed by the path. For example, to check the properties of an executable file:
$appPath = "C:\Program Files (x86)\Turnkey Corrections\Three Square Meals\TSMKiosk.exe"
$appInfo = Get-Item $appPath
$appInfo | Format-List * # Displays all properties

# Retrieving Specific File Version Information
# To retrieve version details, access the VersionInfo property:
$appPath = "C:\Program Files (x86)\Turnkey Corrections\Three Square Meals\TSMKiosk.exe"
$versionInfo = (Get-Item "C:\Program Files (x86)\Turnkey Corrections\Three Square Meals\TSMKiosk.exe").VersionInfo;$versionInfo | Format-List -Property ProductVersion;

# To check registry properties, use Get-ItemProperty with the registry path:
$regPath = "HKLM:\SOFTWARE\TSMKiosk"
Get-ItemProperty $regPath

# List installed apps 
Get-AppxPackage | Format-Table Name, PackageFullName, Version
# Filter by Name 
Get-AppxPackage TSMKiosk.exe | Format-List

# Net Adapter Scripts
## Get the names of the Net Adapters 
Get-NetAdapter

## Get Usage of Net Adapters 
Get-NetAdapterStatistics -Name "Ethernet 3"

## Display all statistics for the specified adapter 
Get-NetAdapterStatistics -Name "Ethernet 4" | Format-List -Property "*"

## Get data usage for specific network adapter, filtered by name 
Get-NetAdapterStatistics | Where-Object {$_.Name -eq "Ethernet 2"} | Select-Object Name, {$_.SentBytes / 1GB}, {$_.ReceivedBytes /1GB}

# Query performance data for processes
Get-WmiObject -Query "SELECT * FROM Win32_PerfFormattedData_PerfProc_Process" | Select-Object Name, IODataBytesPersec, IOOtherBytesPerSec

# Get network adapter statistics
$netStats = Get-NetAdapterStatistics

# Get process network usage
$processes = Get-Process | Select-Object Id, ProcessName, @{Name="RecievedBytes";Expression={(Get-NetAdapterStatistics).ReceivedBytes}}, @{Name="SentBytes";Expression={(Get-NetAdapterStatistics).SentBytes}}
# ReceivedUnicastPackets
# SentUnicastPackets
# Display processes using large amounts of network data
$processes | Sort-Object -Property ReceivedBytes -Descending | Select-Object -First 10

## Get Data Usage for All Network Adapters 
Get-NetAdapterStatistics | Select-Object Name, SentBytes, ReceivedBytes


# Windows Performance Monitor 
Get-Counter 
(Get-Counter -ListSet 'Network Interface').PathsWithInstances
	# \network interface(realtek gaming gbe family controller)\bytes total/sec
Get-Counter -Counter "\Network Interface(Intel[R] I211 Gigabit Network Connection)\Bytes Total/sec" -MaxSamples 10

Start-Job -Name NetworkJob -ScriptBlock {
    Get-Counter -Counter "\Network Interface(Intel[R] I211 Gigabit Network Connection)\Bytes Total/sec" -SampleInterval 1800 -MaxSamples 2
}
$output = Receive-Job -Name NetworkJob
$output | Out-File -FilePath "$env:DESKTOP\output.txt" -Append
## Or 
Receive-Job -Name NetworkJob > "$env:DESKTOP\output.txt"


Get-Counter -ListSet *Network*

(Get-WinEvent -ListLog Application).ProviderNames

Get-WinEvent -ListLog Application | Format-List -Property *

Get-WinEvent -ListProvider *32m*

(Get-WinEvent -ListProvider *32m*).Events | Format-Table Id, Description

<# \Network Interface(Realtek Gaming GbE Family Controller)\Bytes Total/sec
\Network Interface(Realtek Gaming GbE Family Controller)\Packets/sec
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Received/sec
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Sent/sec
\Network Interface(Realtek Gaming GbE Family Controller)\Current Bandwidth
\Network Interface(Realtek Gaming GbE Family Controller)\Bytes Received/sec
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Received Unicast/sec
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Received Non-Unicast/sec
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Received Discarded
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Received Errors
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Received Unknown
\Network Interface(Realtek Gaming GbE Family Controller)\Bytes Sent/sec
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Sent Unicast/sec
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Sent Non-Unicast/sec
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Outbound Discarded
\Network Interface(Realtek Gaming GbE Family Controller)\Packets Outbound Errors
\Network Interface(Realtek Gaming GbE Family Controller)\Output Queue Length
\Network Interface(Realtek Gaming GbE Family Controller)\Offloaded Connections
\Network Interface(Realtek Gaming GbE Family Controller)\TCP Active RSC Connections
\Network Interface(Realtek Gaming GbE Family Controller)\TCP RSC Coalesced Packets/sec
\Network Interface(Realtek Gaming GbE Family Controller)\TCP RSC Exceptions/sec
\Network Interface(Realtek Gaming GbE Family Controller)\TCP RSC Average Packet Size #>
#\Network Interface(Intel(R) I211 Gigabit Network Connection)\Bytes Total/sec
#\Network Interface(Intel[R] Ethernet Connection [11] I219-V)\Bytes Total/sec
#\Network Interface(Intel[R] Wireless-AC 9260 160MHz _3)\Bytes Total/sec

Get-Counter -ListSet * |
  Sort-Object -Property CounterSetName |
    Format-Table CounterSetName, CounterSetType -AutoSize

# To get all IP addresses in use on the local computer, use the following command:
Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true |
    Select-Object -ExpandProperty IPAddress
	
Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true

# Get Device Power Data
Get-PnpDevice | ForEach-Object {$device = $_;
$properties = Get-PnpDevice -PresentOnly  | Where-Object { $_.FriendlyName -match 'MEI Inc. Series 2000 Bill Acceptor' };
if ($properties) {[PSCustomObject]@{FriendlyName = $device.Name }}}
	

[Environment]::SetEnvironmentVariable("devmgr_show_nonpresent_devices", "1", "Machine")
$lptAndComClassGuid = '{4d36e978-e325-11ce-bfc1-08002be10318}'
Get-WmiObject -Class Win32_PnPEntity | Where-Object ClassGuid -eq $lptAndComClassGuid | Select-Object Name, DeviceID, Status    



$device = Get-PnpDevice -PresentOnly | Where-Object { $_.FriendlyName -match 'MEI Inc. Series 2000 Bill Acceptor' }
if ($device) {
	$properties = Get-PnpDeviceProperty -InstanceId $device.InstanceId -KeyName DEVPKEY_Device_PowerData
	if ($properties) {
		Write-Host "Device Name: $($device.Name)"
		Write-Host "Instance ID: $($device.InstanceId)"
		Write-Host "Current Power State: $($properties.Data[4])"
	} else {
		Write-Host "Power data not found for device: $($device.Name)"
	}
} else {
	Write-Host "Device not found: $deviceName"
}

$loel = Get-PnpDevice -PresentOnly | Where-Object { $_.FriendlyName -match 'MEI Inc. Series 2000 Bill Acceptor' }

Get-PnpDevice -PresentOnly | Select-Object -FriendlyName | Where-Object { $_.FriendlyName -match 'MEI Inc. Series 2000 Bill Acceptor' }
Get-PnpDevice | Select-Object -FriendlyName | Where-Object { $_.FriendlyName -match 'MEI Inc. Series 2000 Bill Acceptor' }

$device = $_;$properties = Get-PnpDevice -PresentOnly  | Where-Object { $_.FriendlyName -match 'MEI Inc. Series 2000 Bill Acceptor' };if ($properties) {[PSCustomObject]@{FriendlyName = $device.Name }};


$myDevice = [pscustomobject]@{Name = Get-PnpDevice -PresentOnly | Select-Object -FriendlyName | Where-Object { $_.FriendlyName -match 'MEI Inc. Series 2000 Bill Acceptor' }}

$myDevice = [pscustomobject]@{Name = Get-PnpDevice -PresentOnly | Where-Object { $_.FriendlyName -match 'MEI Inc. Series 2000 Bill Acceptor' }}


Enable-PnpDevice -InstanceId "USB\VID_0BED&PID_1101\12380178378"


Install-Module -Name SpeedTest-CLI -Force

# speedtest

Install-PSResource SpeedTest-CLI -Repository PSGallery


﻿# This a simple demo Powershell script on how perform a Network Capture (similar to netsh trace start capture=yes) 
# saving ETL file using computername and adding timestamp to the output file on this format
# c:\computername-netcap-yyyy-MM-dd_HH-mm-ss.etl
# This ouput capture can be opened in Network Monitor 3.4 or Message Analyzer
#
# It works on Windows 8.1/Windows Server 2012 R2 and after.
#
################################################################################# 
#  
# This script is not officially supported by Microsoft, use it at your own risk.  
# Microsoft has no liability, obligations, warranty, or responsibility regarding  
# any result produced by use of this file. 
# 
################################################################################# 
# 
#Create new session redirecting ETL with timestamp and maximum 512MB of size
$timestamp = Get-Date -f yyyy-MM-dd_HH-mm-ss
New-NetEventSession -Name Session1 -LocalFilePath c:\$env:computername-netcap-$timestamp.etl  -MaxFileSize 512
#Adding provider "Microsoft-Windows-NDIS-PacketCapture" provider {2ED6006E-4729-4609-B423-3EE7BCD678EF} similar to netsh trace capture=yes 
# Previous version we had: Add-NetEventProvider -Name "{2ED6006E-4729-4609-B423-3EE7BCD678EF}" -SessionName Session1
# UPDATE v1.1.2: There's a specific PS command to add Microsoft-Windows-NDIS-PacketCapture which als you can incorporate some filters
# On ethernet or ip layer - userful when want to restrict capture traffic.
Add-NetEventPacketCaptureProvider -SessionName Session1 
#Start a Capture Session
Start-NetEventSession -Name Session1 
#Check Status of capture
Get-NetEventSession
#Stop a Capture Session 
Stop-NetEventSession -Name Session1
#Remove Capture Session
Remove-NetEventSession -Name Session1 

# Adding Tshark to the system variables 
[System.Environment]::SetEnvironmentVariable("Path",[System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\Program Files\Wireshark","Machine")

# Testing it was set correctly 
[System.Environment]::GetEnvironmentVariable("Path", "Machine") -split ";" | Select-String "Wireshark"

# Forcing path to reload 
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

C:\"Program Files"\Wireshark

Install-Module -Name TShark -Scope CurrentUser

# First Find the Interface Name
tshark -D

# The -w flag skips the normal txt output from tshark and would make it not useable when wrote to text file.
# Start-Job -Name TsharkCapture -ScriptBlock { & "C:\Program Files\Wireshark\tshark.exe" -i "Ethernet 2" -w "capture.pcap" }
#better approach would be 
# Start-Job -Name TsharkCapture -ScriptBlock {& "C:\Program Files\Wireshark\tshark.exe" -i "Ethernet 2"}
# 2. When ready to stop:
# Stop-Job -Name TsharkCapture
# 3. Collect the text output and write to Desktop
# Receive-Job -Name TsharkCapture | Out-File "C:\Users\Three Square Market\Desktop\output.txt"
# 4. Clean up
# Remove-Job -Name TsharkCapture


#### Tshark Captures 
# lists the connections
tshark -D  
## Gives the IP of the connected ips
# 169.254.x.x APIPA addresses (Automatic Private IP Addressing) Meaning Not Live IP
# IP 192.168.255.194 is your active interface as it is the only live IP
Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress 

# See the actual active Network - Shown by LinkSpeed - Does not give interface 
Get-NetAdapter

# To Verify Captures are working 
# captures and displays the first 10 captures
tshark -i 5 -c 10  

# Checking how many retransmissions are occurring overall - This does not stop 
tshark -i 5 -f "net 52.144.54.0/24" -Y "tcp.analysis.retransmission" -T fields -e frame.number -e ip.src -e ip.dst -e tcp.analysis.retransmission

# Filter only retransmissions to quantify the problem: This does not stop 
tshark -r C:\captures\52_144_54_capture.pcap -Y "tcp.analysis.retransmission"

# Check for any TCP errors or flags: This does not stop 
tshark -i 5 -f "net 52.144.54.0/24" -Y "tcp.analysis.flags" -T fields -e frame.number -e ip.src -e ip.dst -e tcp.analysis.flags

# Create Capture Folder
New-Item -ItemType Directory -Path C:\captures -Force

# This captures everything for the IP range for 5 minutes:
tshark -i 5 -f "net 52.144.54.0/24" -a duration:300 -w C:\captures\pulseway_capture.pcap

# TCP Errors & Flags (Retransmissions, Resets, Duplicate ACKs):
tshark -r C:\captures\pulseway_capture.pcap -Y "tcp.analysis.flags" -T fields -e frame.number -e frame.time -e ip.src -e ip.dst -e tcp.flags -e tcp.analysis.retransmission -e tcp.analysis.duplicate_ack -e tcp.analysis.reset_cause -E header=y -E separator=, | Out-File C:\captures\pulseway_tcp_issues.txt

# TCP Resets specifically (strong indicator of a block):
tshark -r C:\captures\pulseway_capture.pcap -Y "tcp.flags.reset == 1" -T fields -e frame.number -e frame.time -e ip.src -e ip.dst -e tcp.flags -E header=y -E separator=, | Out-File C:\captures\pulseway_resets.txt

# Full readable summary of all traffic:
tshark -r C:\captures\pulseway_capture.pcap -Y "ip.addr >= 52.144.54.0 and ip.addr <= 52.144.54.255" -T fields -e frame.number -e frame.time -e ip.src -e ip.dst -e _ws.col.Protocol -e _ws.col.Info -E header=y -E separator=, | Out-File C:\captures\pulseway_full_summary.txt

# Step 1 — Start the capture
Start-Job -Name TsharkCapture -ScriptBlock {& "C:\Program Files\Wireshark\tshark.exe" -i "Ethernet 2" -w "C:\Users\Three Square Market\Desktop\capture.pcap"}

# Step 2 — When you're ready to stop, run these three lines:
Stop-Job -Name TsharkCapture

# Step 3 — Convert the pcap to a readable text file on the Desktop
& "C:\Program Files\Wireshark\tshark.exe" -r "C:\Users\Three Square Market\Desktop\capture.pcap" `
  -Y "ip.addr == 52.144.54.0/24" `
  > "C:\Users\Three Square Market\Desktop\output9404.txt"

Get-Content -Path "C:\Users\Three Square Market\Desktop\output9404.txt"

& "C:\Program Files\Wireshark\tshark.exe" -r "C:\Users\Three Square Market\Desktop\capture.pcap" ` -Y "ip.addr == 52.144.54.0/24" `| Tee-Object -FilePath"C:\Users\Three Square Market\Desktop\round1.txt"

Remove-Job -Name TsharkCapture

  & "C:\Program Files\Wireshark\tshark.exe" -r "C:\Users\Three Square Market\Desktop\capture.pcap" ` -Y "ip.addr == 52.144.54.0/24" `| Tee-Object -FilePath "C:\Users\Three Square Market\Desktop\round1.txt"

# Receive-Job -Name TsharkCapture > "C:\Users\Three Square Market\Desktop\output.txt"

# Capture 200 packets on Wi-Fi, verbose output
tshark -i en0 -c 200 -V > ~/Desktop/capture.txt

# Capture only HTTP traffic for 60 seconds
tshark -i eth0 -a duration:60 -f "port 80" > ~/Desktop/http_capture.txt

# Capture specific fields: timestamp, source IP, dest IP, protocol
tshark -i eth0 -c 500 -T fields \
  -e frame.time -e ip.src -e ip.dst -e _ws.col.Protocol \
  > ~/Desktop/capture.txt

# See output in terminal AND save to file simultaneously
tshark -i "Ethernet 2" -c 500 | tee "C:\Users\Three Square Market\Desktop\9404.txt"

nslookup 32market.pulseway.com

# Adding path to System Variable 
# $newPath = "C:\Program Files\Wireshark"
# $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
# if ($currentPath -notlike "*$newPath*") {
    # [Environment]::SetEnvironmentVariable("Path", "$currentPath;$newPath", "Machine")
    # Write-Host "Path added successfully."
# } else {
    # Write-Host "Path already exists."
# }
# $path = "C:\Program Files\Wireshark"
# Get-Item -Path Env:$path

# [Environment]::SetEnvironmentVariable('Wireshark','C:\Program Files\Wireshark', 'Machine')
# [Environment]::GetEnvironmentVariable('Wireshark')

#Get all environment variables 
Get-ChildItem Env:

set Wireshark=C:\"Program Files"\Wireshark


$PATH = [Environment]::GetEnvironmentVariable("PATH")
$wireshark_path = "C:\Program Files\Wireshark"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$wireshark_path")
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$wireshark_path", "Machine")

$PATH = [Environment]::GetEnvironmentVariable("PATH", "Machine")
$wireshark_path = "C:\Program Files\Wireshark"
if( $PATH -notlike "*"+$wireshark_path+"*" ){
    [Environment]::SetEnvironmentVariable("PATH", "$PATH;$wireshark_path", "Machine")
}

set PATH=%PATH%;%CD%

$Env:PATHEXT
$Env:PATH
The first few we’re going to be interested in are as follows

<# -n: Disable network object name resolution (such as hostname, TCP and UDP port names)
-l: Flush the standard output after the information for each packet is printed
-T: Set the format of the output when viewing decoded packet data.
The -T option needs to be followed by an output format. All formats are documented in the linked docs, but we’re going to be using ek which is for newline delimited JSON. Let’s see what that looks like: #>
Start-Job -Name TsharkCapture -ScriptBlock { & "C:\Program Files\Wireshark\tshark.exe" -i 2 -w "capture.pcap" }

# Get interface index
(Get-NetAdapter -Name "Ethernet 3").ifIndex

Receive-Job TsharkCapture

& 'C:\Program Files\Wireshark\tshark.exe' -n -l -T ek
& 'C:\Program Files\Wireshark\tshark.exe'

Start-TShark -SetInterface "Ethernet" -Path C:\DnsOutput.pcapng -LogPath C:\DnsOutput.txt

#Shows Installed Modules 
Get-InstalledModule

# Script for TCP Packet Capture TShark
function MapTCPStreams {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$false)]
        [ValidateScript({Test-Path $_})]
        [string]$TsharkPath = "C:\Program Files\Wireshark\tshark.exe",

        [Parameter(Mandatory)]
        [ValidateScript({Test-Path $_})]
        [ValidateScript({(Get-Item $_).Extension -match "\.pcap$|\.pcapng$"})]
        [string]$ClientPCAP,

        [Parameter(Mandatory)]
        [ValidateScript({Test-Path $_})]
        [ValidateScript({(Get-Item $_).Extension -match "\.pcap$|\.pcapng$"})]
        [string]$ServerPCAP
    )

    $ClientSYNPackets = & $TsharkPath -r $ClientPCAP -T ek -e _ws.col.Protocol -e ip.proto -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport -e tcp.flags -e tcp.seq_raw -e tcp.stream -Y "tcp.flags==0x0002 or tcp.flags==0x00c2" | % {($_| ConvertFrom-Json).layers | ? {$null -ne $_}}
    $ServerSYNPackets = & $TsharkPath -r $ServerPCAP -T ek -e _ws.col.Protocol -e ip.proto -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport -e tcp.flags -e tcp.seq_raw -e tcp.stream -Y "tcp.flags==0x0002 or tcp.flags==0x00c2" | % {($_| ConvertFrom-Json).layers | ? {$null -ne $_}}

    $ClientSYNPackets | % {
        $Client = $_
        $ServerSYNPackets | ? tcp_seq_raw -eq $Client.tcp_seq_raw | Select @{L="ClientTCPStream"; E={($Client.tcp_stream)[0] -as [int]}}, @{L="ServerTCPStream"; E={($_.tcp_stream)[0] -as [int]}}, @{L="ClientTCPSeq";E={$Client.tcp_seq_raw}}, @{L="ServerTCPSeq";E={$_.tcp_seq_raw}}
    } | Sort-Object -Unique -Property ClientTCPStream
}


# Netsh to obtain network statistics
netsh interface ipv4 show ipstats
# TCP statistics
netsh interface ipv4 show tcpstats

Get-NetAdapter -ifAlias "Ethernet 2" | Get-NetAdapterStatistics | format-list *

# Restart the specified network adapter
Restart-NetAdapter -Name "Ethernet 2"

Get-NetAdapterStatistics | Where-Object {$_.Name -eq "Ethernet 2"} | Select-Object Name, {$_.SentBytes / 1GB}, {$_.ReceivedBytes /1GB},{$_.SentUnicastPackets / 1GB},{$_.ReceivedUnicastPackets / 1GB}

$stats = Get-NetAdapterStatistics -Name "Ethernet 4"
# Write-Host "Bytes Received: " (Get-NetAdapterStatistics -Name "Ethernet 4").RecievedBytes
# Write-Host "Bytes Received: " Get-NetAdapterStatistics -Name "Ethernet 4" -Property RecievedBytes| Select-Property RecievedBytes
Write-Host "Bytes Received: $($stats.ReceivedBytes)"
Write-Host "Bytes Sent: $($stats.SentBytes)"

Get-NetEventNetworkAdapter
Get-NetEventProvider
Get-NetEventSession

Get-Counter -ListSet * | Sort-Object CounterSetName | Select-Object CounterSetName

Get-NetAdapterStatistics | Select-Object Name, {$_.SentBytes / 1GB}, {$_.ReceivedBytes /1GB}

Test-NetConnection -ComputerName "google.com"

Get-AppXPackage -AllUsers -Name windows.immersivecontrolpanel | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register “$($_.InstallLocation)\AppXManifest.xml” -Verbose}

Get-AppXPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

Get-Service | Where-Object {$_.Status -eq "Running"}

Get-Service -DisplayName "*network*"
# Status   Name               DisplayName                           
# ------   ----               -----------                           
# Stopped  NcaSvc             Network Connectivity Assistant        
# Running  NcbService         Network Connection Broker             
# Stopped  NcdAutoSetup       Network Connected Devices Auto-Setup  
# Stopped  Netman             Network Connections                   
# Running  netprofm           Network List Service                  
# Stopped  NetSetupSvc        Network Setup Service                 
# Running  NlaSvc             Network Location Awareness            
# Running  nsi                Network Store Interface Service       
# Stopped  p2pimsvc           Peer Networking Identity Manager      
# Stopped  p2psvc             Peer Networking Grouping              
# Running  WdNisSvc           Microsoft Defender Antivirus Networ...
# Stopped  WMPNetworkSvc      Windows Media Player Network Sharin...
# Stopped  XboxNetApiSvc      Xbox Live Networking Service  

# WhatIf Operator pretends to start the service and reports the results 
Start-Service -DisplayName "Network Connections" -WhatIf

$log = Get-WinEvent -ListLog 'Microsoft-Windows*'
$log.IsEnabled = $true
$log.SaveChanges()


`
$interface = 2
$filePath = "C:\users\Three Square Market\Desktop\capture.pcap"
$tshark_path = "C:\Program Files\Wireshark\tshark.exe"

Start-Job -ScriptBlock Start-Job -Name TsharkCapture -ScriptBlock { & $using:tshark_path -i $using:interface -w $using:filePath }
	
Start-Job -Name TsharkCapture -ScriptBlock { & $using:tshark_path -i 2 -w "capture.pcap" }



# Forcing a time update
Push-Location
Set-Location HKLM:\\SYSTEM\\CurrentControlSet\\services\\W32Time\\Parameters
Set-ItemProperty . NtpServer "ntp.pool.ntp.org"
Pop-Location
w32tm /config /manualpeerlist:ntp.pool.ntp.org /syncfromflags:manual /update
Stop-Service w32time
Start-Service w32time


# Resolving Data usage
# HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost
# Ethernet DWORD 1 Non Metered 2 Metered 4 Metered 
Set-CMClientSettingMeteredInternetConnection -MeteredNetworkUsage Allow -DefaultSetting
# First, identify the profile name using:
netsh wlan show profiles
# netsh wlan show profiles
netsh wlan set profileparameter name="" cost=Fixed


Get-Service -DisplayName "*GlassWire*"

# Glasswire Installation Guide CMD
	# Here is what I ended up finding. Hope this helps someone else -

# 1. Run install as you usually would
	#  a) For me that means 
	 GlassWireSetup.exe /S /NOQUICKLAUNCH /NODESKTOP
# 2. Update “C:\ProgramData\glasswire\service-full\glasswire.conf” to the settings you desire
	# a) CloudDetectUploadPermissions is the variable I set. 0 means disable both “App Info” and “Traffic Counters” from being processed by GlassWire servers.
# 3. Set this registry to disable the initial prompt about “Advanced features” on first startup of GlassWire:
	# [HKEY_CURRENT_USER\SOFTWARE\GlassWire] “UserSelectedProfile”=dword:00000001

# Network Trace without installing
netsh trace start persistent=yes capture=yes tracefile="C:\Users\Three Square Market\Desktop\netsh_Log_File.etl"
# Run the process or task that needs tracking 
netsh trace stop

# Network Trace 
# Available scenarios 
netsh trace>show scenarios
# Troubleshoot wired LAN related issues
netsh trace>show scenario lan
# Show Providers
netsh trace>show providers



(Install-WindowsFeature Containers).RestartNeeded


$startExe = New-Object System.Diagnostics.ProcessStartInfo -Args CLEANMGR.exe
$startExe.Verbs

# If you are running an external executable using Start-Process, and want to capture its standard output or error streams, use the -RedirectStandardOutput and -RedirectStandardError parameters, redirecting to a file, and then use Get-Content to read the file.
Start-Process -FilePath "MyProgram.exe" -RedirectStandardOutput "output.txt" -Wait -PassThru


# The last command gets all of the processes on the computer that were running but that are now stopped. It uses Get-Process to get all of the processes on the computer. The pipeline operator (|) passes the results to the Where-Object cmdlet, which selects the ones where the value of the HasExited property is $true. HasExited is just one property of process objects. To find all the properties, type Get-Process | Get-Member.
Get-Process | Where-Object {$_.HasExited}

Get-Process -Name cleanmgr | Where-Object {$_.TotalProcessorTime}
$process.starttime

$process = Get-Process -Name cleanmgr
$StartTime = $process.StartTime
$ElapsedTime = New-TimeSpan -Start $StartTime -End (Get-Date)
$ElapsedTime.hours

$regPathClean = get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" -Name StateFlags1307
if($regPathClean.StateFlags1307 -eq 2){
	Get-Cleanup
}else{Write-Host "Nothing to see here"}

Code

# Define the path to the executable you want to run
$ExecutablePath = "C:\Windows\System32\notepad.exe" 

# Define the duration in seconds for which the process should run
$RunDurationSeconds = 10

# Start the process and capture its process object
$Process = Start-Process -FilePath $ExecutablePath -PassThru

# Wait for the specified duration
Start-Sleep -Seconds $RunDurationSeconds

# Check if the process is still running and then stop it
if ($Process -and -not $Process.HasExited) {
    Stop-Process -Id $Process.Id -Force
    Write-Host "Process '$($Process.ProcessName)' with ID $($Process.Id) terminated after $($RunDurationSeconds) seconds."
} else {
    Write-Host "Process '$($Process.ProcessName)' with ID $($Process.Id) already terminated or was not found."
}

get-ItemProperty -Path "HKLM:\Software\WOW6432Node\StokedKiosk" -Name QuickConnectPassword

New-ItemProperty -Path 'HKLM:\Software\WOW6432Node\StokedKiosk' -Name 'QuickConnectPassword' -Value " 42932729" -PropertyType String -Force

# Looking for a specific Event Log windows
Get-EventLog -LogName System | Where-Object {$_.Message -match "error"}

Get-PnpDevice -PresentOnly -Class Camera |Format-Table -AutoSize

Disable-PnpDevice -InstanceId 'USB\VID_2CE3&PID_C670&MI_00\8&83B3474&0&0000' -Confirm:$false
Disable-PnpDevice -FriendlyName 'USB Composite Device' -Confirm:$false

Enable-PnpDevice -InstanceId 'USB\VID_2CE3&PID_C670&MI_00\8&83B3474&0&0000' -Confirm:$false

# Identify the USB device (replace with your device's FriendlyName or InstanceID)
$usbDevice = Get-PnpDevice -PresentOnly -Class 'Camera'

# Check if the device was found
if ($usbDevice) {
    Write-Host "Disabling $($usbDevice.FriendlyName)..."
    Disable-PnpDevice -InputObject $usbDevice -Confirm:$false

    # Optional: Add a delay before re-enabling
    Start-Sleep -Seconds 2

    Write-Host "Enabling $($usbDevice.FriendlyName)..."
    Enable-PnpDevice -InputObject $usbDevice -Confirm:$false

    Write-Host "Device re-enabled."
} else {
    Write-Host "USB device not found."
}
dism.exe /online /cleanup-image /scanhealth

dism.exe /online /cleanup-image /restorehealth

dism.exe /online /cleanup-image /startcomponentcleanup

sfc /scannow

$keyPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR"
# Checking Value of Registry Key 
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR"

# Checking Registry Sub Keys 
Get-ChildItem Registry::HKEY_CURRENT_USER

#Checking if Key exists
Test-Path "Registry::HKCU\Software\MyApp"


Get-PnpDevice -InstanceId 'USB\VID_05E3&PID_0610\5&22402D2C&0&3'

Set-TimeZone -Id "US Mountain Standard Time_dstoff"

## Privacy Background Applications 
HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications
$backgroundApps = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name Value
if ($backgroundApps -eq "Allow") {
	Write-Host "Status Microphone: " 
	Write-Host "Enabled"
}
elseif ($backgroundApps -eq "Deny") {
	Write-Host "Status Microphone: "
	Write-Host "Disabled"
}
Test-Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"

## Checking if Specific Updates installed 
Get-WindowsUpdate -KBArticleID KB5063709 -IsInstalled
# Or
Get-Hotfix -Id KB957095

4689734

VID=2CE3
PID=C670
MI=00


$url = "https://example.com"
$output = "$PSScriptRoot\software.exe"

$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($url, $output)

$url = "https://example.com"
$output = "$PSScriptRoot\software.exe" # Saves to the script's directory, change as needed

Invoke-WebRequest -Uri $url -OutFile $output

$url = "https://example.com"
$output = "$PSScriptRoot\software.exe"

Start-BitsTransfer -Source $url -Destination $output


Start-Process -FilePath $output -Wait

https://32market.pulseway.com/app/ondemand/89_944fb768-3fc9-4986-b168-c2cd35b4f923
# Define the URL of the dynamic file download link
$url = "https://example.com"
# Define the destination folder (using the system's temp directory for convenience)
$destinationFolder = $env:TEMP

try {
    # 1. Download the file using Invoke-WebRequest and capture the response object
    Write-Host "Downloading file from $url..."
    $response = Invoke-WebRequest -Uri $url -Method Get

    # 2. Extract the filename from the 'Content-Disposition' header if available
    $fileName = $null
    if ($response.Headers["Content-Disposition"]) {
        $contentDisposition = [System.Net.Mime.ContentDisposition]::new($response.Headers["Content-Disposition"])
        $fileName = $contentDisposition.FileName
    }

    # 3. If the filename wasn't in the header, try to extract it from the final ResponseUri
    if (-not $fileName) {
        $fileName = ($response.BaseResponse.ResponseUri.LocalPath -split '\\/|\\\\\')[-1]
    }

    # 4. Define the full local path for the downloaded file
    $filePath = Join-Path -Path $destinationFolder -ChildPath $fileName

    # 5. Save the downloaded content to the determined file path
    Write-Host "Saving file to $filePath"
    $response.Content | Out-File -FilePath $filePath -Encoding Byte

    # Ensure the file is an executable type before attempting to run (optional, but good practice)
    if ($filePath.EndsWith(".exe", [System.StringComparison]::OrdinalIgnoreCase)) {
        # 6. Run the downloaded executable using the call operator (&)
        Write-Host "Running the executable: $filePath"
        & $filePath
    } else {
        Write-Host "Downloaded file is not an executable (.exe). Not running."
    }
}
catch {
    Write-Error "An error occurred during download or execution: $_"
}


$Password = Cantaloupe9911
$adminName = Get-LocalGroupMember -Group "Administrators" | Select-Object Name | Where-Object { ($_.name -split "\\")  -like "Three*" -or ($_.name -split "\\")  -like "3*"};$adminName = ($adminName -split "\\")[1] -replace '[^a-zA-Z0-9]', ' ';
$adminName = $adminName.trim();
$UserAccount = Get-LocalUser -Name $adminName
$UserAccount | Set-LocalUser -Password $Password


## Finding Application Install Date
$directoryPath = "C:\Program Files (x86)\GlassWire"
$glassWireInstalled = Get-Item $directoryPath | Select-Object -Property CreationTime
#Write-host "Glasswire installed on $($glassWireInstalled)"
$creationDate = [datetime]$glassWireInstalled

# PowerShell 
Get-ItemProperty  hklm:\software\wow6432node\microsoft\windows\currentversion\uninstall\* | select-object DisplayName, InstallDate
# Terminal
wmic product get name,InstallDate

Get-Item "C:\Program Files (x86)\GlassWire" | Select-Object -Property CreationTime
[datetime]::parseexact($creationTime, 'MM-dd-yy', $null)
# GlassWire
# C:\Program Files (x86)\GlassWire 
$glasswireInformation = "unknown"
$directoryPath = "C:\Program Files (x86)\GlassWire\glasswire.exe"
$exeFiles = Get-ChildItem -Path $directoryPath -Filter *.exe
foreach ($file in $exeFiles) {$glasswireInformation = [System.Diagnostics.CreationTime]::GetVersionInfo($file.FullName);Write-Host "File Version: $($glasswireInformation)"};

Lorem ipsum dolo

Get-Item $directoryPath

Get-ChildItem $path_to_directory *.zip | Where-Object {$_.CreationTime -gt $lastBuildDeployedTimestamp} | Select-Object -Property FullName, CreationTime

$builds = Get-ChildItem $directoryPath | Where-Object {$_.CreationTime -gt $lastBuildDeployedTimestamp} 
foreach($file in $exeFiles)
{
    $path_to_directory
    $build.CreationTime
}

Get-ChildItem $directoryPath | Select-Object -Property FullName, CreationTime.Date


CreationTime.Date

nslookup -debug [https://cantaloupego.com/#/dashboard]

nslookup -debug [https://cantaloupe.paxstore.us/admin/#/welcome]



# 1. Convert plain text to a SecureString
$SecureString = "MySecretPassword" | ConvertTo-SecureString -AsPlainText -Force

# 2. Encrypt the SecureString into a standard string
$EncryptedString = $SecureString | ConvertFrom-SecureString

# 3. Save to a file (optional)
$EncryptedString | Out-File "C:\path\to\encrypted.txt"




 42932729 
 

try {
	$fixIt = (Get-PnpDevice -PresentOnly -Class "Biometric").instanceId
	} catch { 
	Write-Host "You Suck"
	}
if($fixIt){Write-Host "Over the rainbow"} else {Write-Host "Nothing To See Here"}




$usbDevice = Get-PnpDevice | Where-Object { $_.Name -match $deviceCheck }
Get-PnpDevice | Where-Object { $_.Name -match 'MEI ' }


$deviceCheck = "*MEI*"
function Get-Fixed {
	Get-PnpDevice -InstanceId $fixIt | Disable-PnpDevice -Confirm:$false
	Start-Sleep -Duration (New-TimeSpan -Seconds 60)
    Restart-Computer -Force
}
try {
	$fixIt = (Get-PnpDevice | Where-Object { $_.Name -match $deviceCheck }).instanceId
	} catch { 
	Write-Host "These are not the Droids you Seek"
	}
if($fixIt) {
	Get-Fixed
    } else {
    Write-Host "Nothing To See Here"
    }

$prop = Get-PnpDeviceProperty -InstanceId "USB\VID_05BA&PID_000A\{66E53FCA-39BD-C94B-842D-016E69EC8A88}" -KeyName "DEVPKEY_Device_PowerData";$bytes = $prop.Data;$size    = [BitConverter]::ToUInt32($bytes, 0);$stat = [BitConverter]::ToUInt32($bytes, 4);$caps = [BitConverter]::ToUInt32($bytes, 8);$d1lat = [BitConverter]::ToUInt32($bytes, 12);$d2lat = [BitConverter]::ToUInt32($bytes, 16);$d3lat = [BitConverter]::ToUInt32($bytes, 20);Write-Host "Size: $size";Write-Host "Most Recent State:  D$($state - 1)";Write-Host "Capabilities:    0x$($caps.ToString('X8'))";Write-Host "D1 Latency (100µs): $d1lat";Write-Host "D2 Latency (100µs): $d2lat";Write-Host "D3 Latency (100µs): $d3lat";



# Outputs
$cleanupCounter = 0
$supportNeeded = $False
$thresh = $True
$RegPath = 'HKLM:\SOFTWARE\Tier2\Maintenance'
$RegName = 'diskCleanCounter'

# Ensure registry key exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Get current count (default 0)
$current = (Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue).$RegName
if ($null -eq $current) { $current = 0 }

# Check free disk space percentage (free / total * 100)
$drive     = Get-PSDrive C;$freeGB    = $drive.Free  / 1GB;$totalGB   = ($drive.Free + $drive.Used) / 1GB;$freePct   = ($freeGB / $totalGB) * 100;$thresh    = $freePct -gt 10;   # $true if above 10% free

# Reset counter if storage is healthy and counter is above 0
if ($thresh -and $current -gt 0) {
    New-ItemProperty -Path $RegPath -Name $RegName -Value 0 -PropertyType DWord -Force | Out-Null;
    $current = 0;
	$cleanupCounter = $current;
};

# Only increment if disk space is still low
if (-not $thresh) {
    $newCount = $current + 1;
    New-ItemProperty -Path $RegPath -Name $RegName -Value $newCount -PropertyType DWord -Force | Out-Null;
	$cleanupCounter = $newCount;
    # Flag for Support if count exceeds 5
    if ($newCount -gt 5) { $supportNeeded = $True };
};
#This call performs an implicit string conversion. To see what is actually set in
#the variable, uncomment the following line and look at the script output
"$thresh"
Start-Process -FilePath "$env:PWY_HOME\CLI.exe" -ArgumentList ("setVariable thresh ""$thresh""") -Wait

#This call performs an implicit string conversion. To see what is actually set in
#the variable, uncomment the following line and look at the script output
"$supportNeeded"
Start-Process -FilePath "$env:PWY_HOME\CLI.exe" -ArgumentList ("setVariable supportNeeded ""$supportNeeded""") -Wait

#This call performs an implicit string conversion. To see what is actually set in
#the variable, uncomment the following line and look at the script output
"$cleanupCounter"
Start-Process -FilePath "$env:PWY_HOME\CLI.exe" -ArgumentList ("setVariable cleanupCounter ""$cleanupCounter""") -Wait

(Get-HotFix | Sort-Object -Property InstalledOn)[-1]


Disable-NetAdapterPowerManagement -Name "Wi-Fi" -NoRestart

$netAdapter = Get-NetAdapter -Name "Wi-Fi"
Disable-NetAdapterPowerManagement -InputObject $netAdapter # -DeviceSleepOnDisconnect

Get-NetAdapterPowerManagement


shutdown /r /t 300 /c "System will restart in 5 mins"

$tokenId = '4ca945f20da24ee09f7e5aee07e209ad';$tokenSecret = '3cb6d43e3faa4010a9a12277d2eb9423e04f6af7c7b44016b3e06f8c57464cc6';$base64Encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($tokenId):$($tokenSecret)"));$headers=@{};$headers.Add("Content-Type", "application/json");$headers.Add("Accept", "*/*");$headers.Add("Authorization", "Basic $($base64Encoded)");$response = Invoke-WebRequest -Uri 'https://32market.pulseway.com/api/v3/automation/scripts?$top=100&$skip=0' -Headers $headers -Method GET -UseBasicParsing;


# Find the program first
Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Apache Couch*" } | Select-Object Name, Version

# Uninstall it
Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Apache Couch*" } | ForEach-Object { $_.Uninstall() }



# Find the program first
Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Three Square Market*" } | Select-Object Name, Version

# Uninstall it
Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Three Square Market*" } | ForEach-Object { $_.Uninstall() }


### Uninstall Tsm and Couch
$couchDB = "Apache Couch"  
$turnkey = "Three Square Market"
$couchPath  = "C:\Program Files (x86)\Apache Software Foundation"   
$32mPath = "C:\Program Files (x86)\Turnkey Corrections" 

# Step 1: Find and uninstall
$app = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
       Where-Object { $_.DisplayName -like "*$programName*" }

if ($app) {
    Write-Host "Uninstalling: $($app.DisplayName)"
    Start-Process cmd -ArgumentList "/c $($app.UninstallString)" -Wait
    Write-Host "Uninstall complete."
} else {
    Write-Host "Program not found in registry."
}

# Step 2: Remove the folder
if (Test-Path $folderPath) {
    Remove-Item -Path $folderPath -Recurse -Force
    Write-Host "Folder removed: $folderPath"
} else {
    Write-Host "Folder already gone or path incorrect."
}


### Example To Get the OneDrive files for the currently logged in user 
$scriptblock = {
$IniFiles = Get-ChildItem "$ENV:LOCALAPPDATA\Microsoft\OneDrive\settings\Business1" -Filter 'ClientPolicy*' -ErrorAction SilentlyContinue

if (!$IniFiles) {
    write-host 'No Onedrive configuration files found. Stopping script.'
    exit 1
}

$SyncedLibraries = foreach ($inifile in $IniFiles) {
    $IniContent = get-content $inifile.fullname -Encoding Unicode
    [PSCustomObject]@{
        'Item Count' = ($IniContent | Where-Object { $_ -like 'ItemCount*' }) -split '= ' | Select-Object -last 1
        'Site Name'  = ($IniContent | Where-Object { $_ -like 'SiteTitle*' }) -split '= ' | Select-Object -last 1
        'Site URL'   = ($IniContent | Where-Object { $_ -like 'DavUrlNamespace*' }) -split '= ' | Select-Object -last 1
    }
}
$SyncedLibraries | ConvertTo-Json | Out-File 'C:\programdata\Microsoft OneDrive\OneDriveLibraries.txt'
}
Invoke-ascurrentuser -scriptblock $scriptblock
$SyncedLibraries = (get-content "C:\programdata\Microsoft OneDrive\OneDriveLibraries.txt" | convertfrom-json)
if (($SyncedLibraries.'Item count' | Measure-Object -Sum).sum -gt '280000') {
write-host "Unhealthy - Currently syncing more than 280k files. Please investigate."
$SyncedLibraries
}
else {
write-host "Healthy - Syncing less than 280k files."
}



Get-WinEvent -LogName System -FilterXPath "*[System[Provider[@Name='Microsoft-Windows-Resource-Exhaustion-Detector'] and EventID=2004]]" | Select-Object TimeCreated, Message
HKEY_LOCAL_MACHINE\SOFTWARE\Tier2\Maintenance


#Full path to currents users home directory
$HOME

#Finds the exact location of the Windows user profile folder
$env:USERPROFILE

#Returns the full Domain\Username layout. This is the most secure method because environment variables can be manipulated by users within a session
[System.Security.Principal.WindowsIdentity]::GetCurrent().Name

#Best for a quick Windows-only username string
$env:USERNAME

Get-CimInstance Win32_ComputerSystem | Select-Object UserName

quser | Select-String "Active"

quser

# Get-CimInstance -Class Win32_Process -Filter "Name = 'explorer.exe'" | ForEach-Object { $_.GetOwner().User }

Get-CimInstance -Class Win32_Process -Filter "Name = 'TsmKiosk.exe'" | Invoke-CimMethod -MethodName GetOwner | Select-Object -ExpandProperty User

if($isTSMRunning) {$usrName = Get-CimInstance -Class Win32_Process -Filter "Name = 'TsmKiosk.exe'" | Invoke-CimMethod -MethodName GetOwner | Select-Object -ExpandProperty User;}else{$usrName = Get-CimInstance -Class Win32_Process -Filter "Name = 'explorer.exe'" | Invoke-CimMethod -MethodName GetOwner | Select-Object -ExpandProperty User;};


# List all connected cameras
Get-PnpDevice -Class Camera | Select-Object Status, FriendlyName, InstanceId

# Or check via DirectShow/Media Foundation device enumeration
Get-CimInstance -ClassName Win32_PnPEntity | Where-Object { $_.PNPClass -eq "Camera" }

# Requires PowerShell 5+ on a machine with Windows SDK WinRT types available
Add-Type -AssemblyName System.Runtime.WindowsRuntime

$deviceInfo = [Windows.Devices.Enumeration.DeviceInformation]
$selector   = [Windows.Media.Capture.MediaCapture]::GetDeviceSelector()
$devices    = $deviceInfo::FindAllAsync($selector).GetAwaiter().GetResult()

$devices | ForEach-Object { Write-Host "Camera: $($_.Name) | ID: $($_.Id)" }


# List available video devices
ffmpeg -list_devices true -f dshow -i dummy

# Capture 5 seconds of video to verify the feed works
ffmpeg -f dshow -i video="USB2.0 Camera" -t 5 test_output.mp4

# List available video devices
ffmpeg -list_devices true -f dshow -i dummy

# Capture 5 seconds of video to verify the feed works
ffmpeg -f dshow -i video="8M AF" -t 5 test_output.mp4

# Enable camera access at the system level (overrides the privacy block)
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name "LetAppsAccessCamera" -Value 1 -Type DWord

# Also clear any user-level block
$userRegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam"
if (Test-Path $userRegPath) {
    Set-ItemProperty -Path $userRegPath -Name "Value" -Value "Allow" -Type String
}

Write-Host "Camera access registry updated. A reboot or gpupdate may be required."


# Check what's currently set
Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera" -ErrorAction SilentlyContinue

# Check MDM enrollment
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Privacy" -ErrorAction SilentlyContinue

# Fix the system-wide webcam consent store
$camPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam";Set-ItemProperty -Path $camPath -Name "Value" -Value "Allow" -Type String;

# Also fix it for the current user profile if needed
$userCamPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam";if (Test-Path $userCamPath) {Set-ItemProperty -Path $userCamPath -Name "Value" -Value "Allow" -Type String};

# Verify
Write-Host "HKLM webcam consent: $((Get-ItemProperty $camPath).Value)"
Write-Host "HKCU webcam consent: $((Get-ItemProperty $userCamPath -ErrorAction SilentlyContinue).Value)"

# Get the logged-on user's SID and fix their hive directly
$loggedOnUser = (Get-CimInstance Win32_ComputerSystem).UserName
$sid = (New-Object System.Security.Principal.NTAccount($loggedOnUser)).Translate([System.Security.Principal.SecurityIdentifier]).Value

$userHivePath = "REGISTRY::HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam"
if (Test-Path $userHivePath) {
    Set-ItemProperty -Path $userHivePath -Name "Value" -Value "Allow"
    Write-Host "Fixed for user: $loggedOnUser ($sid)"
} else {
    Write-Host "Path not found for SID: $sid - may need to create it"
    New-Item -Path $userHivePath -Force | Out-Null
    Set-ItemProperty -Path $userHivePath -Name "Value" -Value "Allow"
}



##### FFMPEG Self Contained Test for the Camera Functionality #############
##### Runs on System Level and Not User Level
$workDir = "C:\ProgramData\MMSOFT Design\Pulseway\working\ffmpeg_test"
$ffmpegZip = "$workDir\ffmpeg.zip"
$ffmpegExe = "$workDir\ffmpeg\bin\ffmpeg.exe"

# Create working directory
New-Item -Path $workDir -ItemType Directory -Force | Out-Null

function Test-Camera {
    param(
        [string]$CameraName,
        [string]$OutputPath,
        [string]$ffmpegExe
    )
    
    Write-Host "`n--- Testing: $CameraName ---"
    $captureResult = & $ffmpegExe -y -f dshow -i "video=$CameraName" -t 1 -vframes 1 $OutputPath 2>&1

    if (Test-Path $OutputPath) {
        $size = (Get-Item $OutputPath).Length
        if ($size -gt 0) {
            Write-Host "PASS - Snapshot captured successfully ($size bytes)"
            return $true
        } else {
            Write-Host "FAIL - Output file is empty (0 bytes)"
            Write-Host "ffmpeg output:"
            $captureResult | Select-Object -Last 10 | ForEach-Object { Write-Host "  $_" }
            return $false
        }
    } else {
        Write-Host "FAIL - No output file produced"
        Write-Host "ffmpeg output:"
        $captureResult | Select-Object -Last 10 | ForEach-Object { Write-Host "  $_" }
        return $false
    }
}

try {
    # Download ffmpeg static build
    Write-Host "Downloading ffmpeg..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri "https://github.com/BtbN/ffmpeg-builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip" -OutFile $ffmpegZip -UseBasicParsing

    # Extract just ffmpeg.exe
    Write-Host "Extracting..."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $zip = [System.IO.Compression.ZipFile]::OpenRead($ffmpegZip)
    $zip.Entries | Where-Object { $_.FullName -match "bin/ffmpeg\.exe$" } | ForEach-Object {
        $destPath = "$workDir\ffmpeg\bin\ffmpeg.exe"
        New-Item -Path "$workDir\ffmpeg\bin" -ItemType Directory -Force | Out-Null
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $destPath, $true)
    }
    $zip.Dispose()

    # List all DirectShow video devices
    Write-Host "`n=== Enumerating Camera Devices ==="
    $deviceList = & $ffmpegExe -list_devices true -f dshow -i dummy 2>&1
    
    # Extract all camera names
    $cameraNames = @()
    foreach ($line in $deviceList) {
        if ($line -match '"([^"]+)"') {
            $name = $matches[1]
            # Filter out audio devices by checking next lines aren't audio-only
            if ($line -notmatch "Microphone|microphone|Audio|audio|Speaker|speaker") {
                $cameraNames += $name
                Write-Host "Found device: $name"
            }
        }
    }

    if ($cameraNames.Count -eq 0) {
        Write-Host "No camera devices found in DirectShow enumeration"
        Write-Host "Raw device output:"
        $deviceList | ForEach-Object { Write-Host "  $_" }
        exit
    }

    # Run capture test on each camera
    Write-Host "`n=== Camera Capture Tests ==="
    $results = @{}
    
    foreach ($cam in $cameraNames) {
        $safeName = $cam -replace '[\\/:*?"<>|]', '_'
        $outputPath = "$workDir\snapshot_$safeName.jpg"
        $passed = Test-Camera -CameraName $cam -OutputPath $outputPath -ffmpegExe $ffmpegExe
        $results[$cam] = $passed
    }

    # Summary
    Write-Host "`n=== SUMMARY ==="
    $passCount = 0
    $failCount = 0
    foreach ($cam in $results.Keys) {
        $status = if ($results[$cam]) { "PASS"; $passCount++ } else { "FAIL"; $failCount++ }
        Write-Host "$status - $cam"
    }
    Write-Host "`n$passCount of $($results.Count) cameras passed"

} catch {
    Write-Host "Error: $_"
} finally {
    Write-Host "`nCleaning up..."
    Remove-Item -Path $workDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Done"
}




##### Camera Test that runs on the User Level 
$workDir = "C:\ProgramData\MMSOFT Design\Pulseway\working\ffmpeg_test"
$ffmpegExe = "$workDir\ffmpeg\bin\ffmpeg.exe"
$psexecUrl = "https://live.sysinternals.com/PsExec64.exe"
$psexecExe = "$workDir\PsExec64.exe"
$snapshotPath = "$workDir\snapshot.jpg"
$logPath = "$workDir\ffmpeg_log.txt"

New-Item -Path $workDir -ItemType Directory -Force | Out-Null

try {
    # Download PsExec
    Write-Host "Downloading PsExec..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $psexecUrl -OutFile $psexecExe -UseBasicParsing

    # Download ffmpeg if not already present
    if (-not (Test-Path $ffmpegExe)) {
        Write-Host "Downloading ffmpeg..."
        $ffmpegZip = "$workDir\ffmpeg.zip"
        Invoke-WebRequest -Uri "https://github.com/BtbN/ffmpeg-builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip" -OutFile $ffmpegZip -UseBasicParsing
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $zip = [System.IO.Compression.ZipFile]::OpenRead($ffmpegZip)
        $zip.Entries | Where-Object { $_.FullName -match "bin/ffmpeg\.exe$" } | ForEach-Object {
            New-Item -Path "$workDir\ffmpeg\bin" -ItemType Directory -Force | Out-Null
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $ffmpegExe, $true)
        }
        $zip.Dispose()
    }

    # Get the active console session ID
    $sessionId = (Get-CimInstance Win32_ComputerSystem).UserName
    Write-Host "Logged on user: $sessionId"

    # Accept PsExec EULA silently via registry
    $null = New-Item -Path "HKCU:\SOFTWARE\Sysinternals\PsExec" -Force
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Sysinternals\PsExec" -Name "EulaAccepted" -Value 1 -Type DWord

    # Run ffmpeg in the user's session - list devices first
    Write-Host "Enumerating devices in user session..."
    $listCmd = "`"$ffmpegExe`" -list_devices true -f dshow -i dummy 2>`"$workDir\devices.txt`""
    & $psexecExe -accepteula -i 1 -s cmd /c $listCmd 2>&1 | Out-Null
    Start-Sleep -Seconds 3

    if (Test-Path "$workDir\devices.txt") {
        Write-Host "=== Devices in User Session ==="
        Get-Content "$workDir\devices.txt" | Where-Object { $_ -match "DirectShow|camera|Camera|8M|USB2" } | ForEach-Object {
            Write-Host $_
        }
    }

    # Capture snapshot from 8M AF camera in user session
    Write-Host "`nCapturing snapshot from 8M AF camera..."
    $captureCmd = "`"$ffmpegExe`" -y -f dshow -i `"video=8M AF camera`" -vframes 1 `"$snapshotPath`" 2>`"$logPath`""
    & $psexecExe -accepteula -i 1 -s cmd /c $captureCmd 2>&1 | Out-Null
    Start-Sleep -Seconds 5

    if (Test-Path $snapshotPath) {
        $size = (Get-Item $snapshotPath).Length
        if ($size -gt 0) {
            Write-Host "PASS - 8M AF camera captured ($size bytes)"
        } else {
            Write-Host "FAIL - Snapshot file empty"
        }
    } else {
        Write-Host "FAIL - No snapshot produced"
        if (Test-Path $logPath) {
            Get-Content $logPath | Select-Object -Last 10 | ForEach-Object { Write-Host "  $_" }
        }
    }

    # Capture snapshot from USB2.0 Camera in user session
    Write-Host "`nCapturing snapshot from USB2.0 Camera..."
    $snapshot2Path = "$workDir\snapshot_usb2.jpg"
    $log2Path = "$workDir\ffmpeg_log2.txt"
    $captureCmd2 = "`"$ffmpegExe`" -y -f dshow -i `"video=USB2.0 Camera`" -vframes 1 `"$snapshot2Path`" 2>`"$log2Path`""
    & $psexecExe -accepteula -i 1 -s cmd /c $captureCmd2 2>&1 | Out-Null
    Start-Sleep -Seconds 5

    if (Test-Path $snapshot2Path) {
        $size = (Get-Item $snapshot2Path).Length
        if ($size -gt 0) {
            Write-Host "PASS - USB2.0 Camera captured ($size bytes)"
        } else {
            Write-Host "FAIL - Snapshot file empty"
        }
    } else {
        Write-Host "FAIL - No snapshot produced"
        if (Test-Path $log2Path) {
            Get-Content $log2Path | Select-Object -Last 10 | ForEach-Object { Write-Host "  $_" }
        }
    }

} catch {
    Write-Host "Error: $_"
} finally {
    Write-Host "`nCleaning up..."
    Remove-Item -Path $workDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Done"
}

### User Level Test As a Scheduled Task instead of a script ####
$workDir = "C:\ProgramData\MMSOFT Design\Pulseway\working\ffmpeg_test"
$ffmpegExe = "$workDir\ffmpeg\bin\ffmpeg.exe"
$snapshotPath = "$workDir\snapshot.jpg"
$loggedOnUser = (Get-CimInstance Win32_ComputerSystem).UserName

# Register and run a scheduled task as the logged-on user
$action = New-ScheduledTaskAction -Execute $ffmpegExe `
    -Argument "-y -f dshow -i `"video=8M AF camera`" -vframes 1 `"$snapshotPath`""
$principal = New-ScheduledTaskPrincipal -UserId $loggedOnUser -LogonType Interactive
$task = Register-ScheduledTask -TaskName "CamTest" -Action $action -Principal $principal -Force
Start-ScheduledTask -TaskName "CamTest"
Start-Sleep -Seconds 8

if (Test-Path $snapshotPath) {
    Write-Host "PASS - $((Get-Item $snapshotPath).Length) bytes"
} else {
    Write-Host "FAIL - No output"
}

Unregister-ScheduledTask -TaskName "CamTest" -Confirm:$false


# Within a catch block, the current error can be accessed using the $_ or $PSItem automatic variable. The object is of type ErrorRecord.
try { NonsenseString }
catch {
    Write-Host "An error occurred:"
    Write-Host $_
}

# There are additional properties that can be accessed, such as ScriptStackTrace, Exception, and ErrorDetails. For example, if we change the script to the following:
try { NonsenseString }
catch {
    Write-Host "An error occurred:"
    Write-Host $_.ScriptStackTrace
}

# A finally block runs even if you use CTRL+C to stop the script. A finally block also runs if an exit keyword stops the script from within a catch block.

# In the following example, the try block attempts to download a file to the C:\temp folder. The catch blocks handle errors that occur during the download. The finally block disposes of the WebClient object and removes the temporary file if it exists.
try {
    $wc = New-Object System.Net.WebClient
    $tempFile = "C:\temp\MyDoc.doc"
    $wc.DownloadFile("https://httpbin.org/MyDoc.doc",$tempFile)
} catch [System.Net.WebException],[System.IO.IOException] {
    "Unable to download MyDoc.doc from https://httpbin.org."
} catch {
    "An error occurred that could not be resolved."
} finally {
    $wc.Dispose()
    if (Test-Path $tempFile) { Remove-Item $tempFile }
}






Apache CouchDB 1.6.1
Three Square Market Kiosk

Get-Package -Name "Apache CouchDB 1.6.1" | Uninstall-Package
Get-Package -Name "Three Square Market Kiosk" | Uninstall-Package

Remove-Item -Path "${env:ProgramFiles(x86)}\Apache Software Foundation" -Recurse -Force
Remove-Item -Path "${env:ProgramFiles(x86)}\Turnkey Corrections" -Recurse -Force


$billAcceptor = Get-PnpDevice | Where-Object { $_.Name -match 'MEI ' } #| Format-Table -Autosize | Out-String

if($billAcceptor){$meiResults = $True}

$results = Get-Pnpdevice -PresentOnly -Class "Ports" | Where-Object {$_.Name -match 'MEI'}


[System.Management.Automation.ItemNotFoundException]


try {
    # Replace with your cmdlet and parameters
    $results = Get-Pnpdevice -PresentOnly -Class "Ports" | Where-Object {$_.Name -match 'MEI'}
	if($results) {
		return $True
	} else { 
		return $False
	}
}
catch [System.Management.Automation.ItemNotFoundException] {
    Write-Warning "This device does not have Ports"
    # Access exact error details via $_
    Write-Host "Error details: $($_.Exception.Message)"
}
catch {
    # Catches all other terminating errors
    Write-Error "An unexpected error occurred: $($_.Exception.Message)"
}
CmdletizationQuery_NotFound


Get-WmiObject Win32_PnPEntity -Filter "Name LIKE '%MEI%'"

$adminPath = (Get-CimInstance -Class Win32_Process -Filter "Name = 'TsmKiosk.exe'" | Invoke-CimMethod -MethodName GetOwner | Select-Object -ExpandProperty User).trim()
$output = "c:\Users\Three Square Market\Desktop\ndp48-x86-x64-allos-enu (1).exe"

Start-Process -FilePath $output -ArgumentList "/q /norestart /ChainingPackage ADMINDEPLOYMENT" -Wait

DISM.exe /Online /Cleanup-Image /StartComponentCleanup



## Logging information 
if ($Count -eq 1 -and (Test-Path $LogFile)) {
    Remove-Item $LogFile -Force
}

$SummaryFile = "C:\Scripts\RebootSummary.txt"

@"
Reboot Test Results
===================
Computer: $env:COMPUTERNAME
Completed Cycles: $MaxReboots
Completion Time: $(Get-Date)
Status: $(if($IssuesFound){"FAIL"}else{"PASS"})
Log File: $LogFile
"@ | Set-Content $SummaryFile






# Planned Reboots
Get-WinEvent -FilterHashtable @{LogName='System'; Id=1074} | Select-TimeCreated, Id, Message | Format-Table -Wrap

# Not Planned Reboots
Get-WinEvent -FilterHashtable @{LogName='System'; Id=41, 6008} | Select-TimeCreated, Id, Message | Format-Table -Wrap

# Query Additional Reboot Related Event IDs 
Get-WinEvent -FilterHashtable @{LogName='System'; Id=1074,6005,6006,6008} -MaxEvents 6 | Format-Table -Wrap


# Define the time window and relevant event IDs
$StartTime = (Get-Date).AddDays(-30)
$EventIDs = @(1074, 41, 6005, 6006, 6008)

# Query the log
$Filter = @{
    LogName   = 'System'
    Id        = $EventIDs
    StartTime = $StartTime
}

Get-WinEvent -FilterHashtable $Filter -ErrorAction SilentlyContinue | ForEach-Object {
    [PSCustomObject]@{
        Timestamp = $_.TimeCreated
        EventID   = $_.Id
        Provider  = $_.ProviderName
        Message   = $_.Message -replace "`r`n", " "
    }
} | Out-GridView -Title "System Reboot History"



Get-Process | Select-Object Name, Id, CPU | Export-Csv -Path "C:\path\to\output.csv" -NoTypeInformation

#### Scheduling Reboots and Diplaying a Dynamic Message.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Scheduled Maintenance"
$form.Size = New-Object System.Drawing.Size(700,250)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.FormBorderStyle = "FixedDialog"

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(20,20)
$label.Size = New-Object System.Drawing.Size(650,100)
$label.Font = New-Object System.Drawing.Font("Segoe UI",14)
$label.Text = "This kiosk will restart in 5 minutes to install Windows updates and perform routine maintenance.`n`nPlease complete any current transactions."

$form.Controls.Add($label)

$countdown = New-Object System.Windows.Forms.Label
$countdown.Location = New-Object System.Drawing.Point(20,140)
$countdown.Size = New-Object System.Drawing.Size(500,50)
$countdown.Font = New-Object System.Drawing.Font("Segoe UI",24,[System.Drawing.FontStyle]::Bold)

$form.Controls.Add($countdown)

$timer = New-Object System.Windows.Forms.Timer
$remaining = 300

$timer.Add_Tick({
    $script:remaining--

    $mins = [math]:: / 60)
    $secs = $script:remaining % 60

    $countdown.Text = "Restart in: {0:D2}:{1:D2}" -f $mins,$secs

    if($script:remaining -le 60){
        $countdown.ForeColor = "Red"
    }
    elseif($script:remaining -le 180){
        $countdown.ForeColor = "DarkOrange"
    }

    if($script:remaining -le 0){
        $timer.Stop()
        shutdown.exe /r /f /t 0
    }
})

$timer.Interval = 1000
$timer.Start()

$form.ShowDialog()

### Windows Native Toast features
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null

$Template = @"
<toast>
    <visual>
        <binding template="ToastGeneric">
            <text>Scheduled Maintenance</text>
            <text>This kiosk will restart in 5 minutes. Please complete any transactions.</text>
        </binding>
    </visual>
</toast>
"@

$Xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$Xml.LoadXml($Template)

$Toast = [Windows.UI.Notifications.ToastNotification]::new($Xml)

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Kiosk Maintenance").Show($Toast)



Get-Process svchost |
    Sort-Object CPU -Descending |
    Select-Object -First 10 Name,Id,CPU,WS
	
	6776
	2552
	1916
	2836
	4892
	3376
	1060
	1528
	784
	1120