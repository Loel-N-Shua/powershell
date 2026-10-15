# Pulseway authentication and formatting
function Get-Headers {
	
	$userName = $env:USERNAME
	# Change to $Base64Token = Get-Content -Path "C:\Program Files\WindowsPowershell\Modules\functions\token.txt" -Raw
	$Base64Token = Get-Content -Path "C:\Users\$userName\Pulseway Scripts\functions\token.txt" -Raw
	# Decode Base64
	$EncryptedBytes = [Convert]::FromBase64String($Base64Token)
	$EncryptedString = [System.Text.Encoding]::UTF8.GetString($EncryptedBytes)

	# Decrypt using machine DPAPI
	$Secure = ConvertTo-SecureString $EncryptedString
	$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secure)
	$PlainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

	#authentication and other headers
	$headers=@{}
	$headers.Add("Content-Type", "application/json")
	$headers.Add("Accept", "*/*")
	$headers.Add("Authorization", "Basic $($plainToken)")
	return $headers
}

# Fetch all systems and find the one with name matching the serial number
function Get-Identifier {
	param(
	[ValidatePattern('^D?E?TSMX?\d{0,2}-\d{4,5}|CGO\d{0,2}-\d{4,5}|RR\d{0,2}-\d{4,5}$')][string]$serial
	)
	
	# Get the headers for the API request
	$headers = Get-Headers
	
	# Split the string to search only the last 4-5 numbers
	$cleanSerial = ($serial -split "-")[1]
	
	# Encode to make the odata filter behave
	$encodedTerm = [System.Uri]::EscapeDataString($cleanSerial)
	
	#GET all systems from Pulseway
	try {
		$systemsResponse = Invoke-RestMethod -Uri "https://32market.pulseway.com/api/v3/devices?`$filter=contains(tolower(Name), '$encodedTerm')&`$skip=0" -Headers $headers -Method GET 
	} catch { 
		Write-Error "Failed to get devices: $_"
	}

	# match to serial number and extract device identifier
	$targetSystem = ($systemsResponse.Data | Where-Object { $_.Name -match "^$serial(?!\w)" } | Select-Object -First 1).Identifier

	# Output an error if no matching serial number found
	if (-not $targetSystem) {
		Write-Error "Device $serial could not be found."
	}
	return $targetSystem
}
