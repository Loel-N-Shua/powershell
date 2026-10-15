# 2nd install step.
# Run this first: 
# $queryUser = (Get-CimInstance Win32_Process -Filter "name='explorer.exe'" | Invoke-CimMethod -MethodName GetOwner).User
# $userName = ($queryUser -split "\\")[1]
# OR $userName = "ENTER USERNAME"
# Unblock-File -Path "C:\Users\$userName\Pulseway Scripts\Install Scripts.ps1"
# takeown /f "C:\Users\$userName\Pulseway Scripts\Install Scripts.ps1"
# icacls "C:\Users\$userName\Pulseway Scripts\Install Scripts.ps1" /grant administrators:F /t /c /q

$queryUser = (Get-CimInstance Win32_Process -Filter "name='explorer.exe'" | Invoke-CimMethod -MethodName GetOwner).User
$userName = ($queryUser -split "\\")[1]

# Take admin ownership of the install files
takeown /f "C:\Users\$userName\Pulseway Scripts\functions" /r /d y
takeown /f "C:\Users\$userName\Pulseway Scripts\qc" /r /d y
icacls "C:\Users\$userName\Pulseway Scripts\functions" /grant administrators:F /t /c /q
icacls "C:\Users\$userName\Pulseway Scripts\qc" /grant administrators:F /t /c /q

# Copy the files into the PowerShell Modules directory
Copy-Item -Path "C:\Users\$userName\Pulseway Scripts\functions\*" -Destination "C:\Program Files\WindowsPowershell\Modules" -Recurse -Force
Copy-Item -Path "C:\Users\$userName\Pulseway Scripts\qc\*" -Destination "C:\Program Files\WindowsPowershell\Modules" -Recurse -Force

# Unblock the new modules from execution
Get-ChildItem -Path "C:\Program Files\WindowsPowershell\Modules\functions" -Recurse | Unblock-File 
Get-ChildItem -Path "C:\Program Files\WindowsPowershell\Modules\qc" -Recurse | Unblock-File