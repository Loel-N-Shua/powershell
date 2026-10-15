# 1st install step.
# Pulseway authentication Stuff. 

# Run this first: 
# Unblock-File -Path "C:\Users\$userName\Pulseway Scripts\encrypt.ps1"

# Run this locally to generate secure token

param([string]$TokenName, [string]$TokenSecret
)
# Get the username, token name, and token secret
$userName = (Get-CimInstance Win32_Process -Filter "Name = 'explorer.exe'" | Invoke-CimMethod -MethodName GetOwner).User

# Encode token as base64 string
$Token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($TokenName):$($TokenSecret)"))

# Begin encrypting string
$Secure = ConvertTo-SecureString $Token -AsPlainText -Force
$EncryptedString = ConvertFrom-SecureString $Secure

# Convert to Base64
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($EncryptedString)
$Base64Token = [Convert]::ToBase64String($Bytes)

# Write the encrypted token to a file used by the scripts
Set-Content -Path "C:\Users\$userName\Pulseway Scripts\functions\token.txt" -Value $Base64Token 