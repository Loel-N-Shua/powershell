function qc {
	# Input the device serial number and qc passcode as parameters to this script.
	[CmdletBinding()]
	param (
		[ValidatePattern('^D?E?TSMX?\d{0,2}-\d{4,5}|CGO\d{0,2}-\d{4,5}|RR\d{0,2}-\d{4,5}$')][string]$serial,
		[ValidatePattern('^\d{8}$')][string]$passcode
	)

	# dot source the functions script
	#. .\functions.ps1

	# Pulseway authentication and Headers
	$headers = Get-Headers

	# GET all systems from Pulseway
	$targetSystem = Get-Identifier $serial

	# Using the device identifier, run the script with the passcode parameter as input variable

	$scriptID = "0cae2116-7530-42d2-827d-0191a4276d95"

	# POST Body as per Pulseway's API Spec, converted to JSON. Value of single variable is set to inputted passcode.
	$identifier = 245
	$Body = @{
				DeviceIdentifier = $targetSystem
				Variables = @(@{
								Id = $identifier
								Value = $passcode
				})
	} | ConvertTo-Json -Depth 10

	# POST request to pulseway to run the script
	$response = $null
	$maxRetries = 10

	for ($attempt = 1; $attempt -le $maxRetries; $attempt++) {

		try {
			Write-Host "Attempt $attempt of $maxRetries..."

			$response = Invoke-RestMethod `
				-Uri "https://32market.pulseway.com/api/v3/automation/scripts/$scriptID/run" `
				-Headers $headers `
				-Method POST `
				-ContentType 'application/json' `
				-Body $Body `
				-ErrorAction Stop

			break
		}
		catch {
			$responseBody = ""

			try {
				$reader = New-Object System.IO.StreamReader(
					$_.Exception.Response.GetResponseStream()
				)
				$responseBody = $reader.ReadToEnd()
			}
			catch {}

			if (
				$_.Exception.Response.StatusCode.value__ -eq 400 -and
				$responseBody -match "already being executed."
			) {
				if ($attempt -eq $maxRetries) {
					throw "Script is still executing after $maxRetries attempts."
				}

				Write-Warning "Script already executing. Waiting 30 seconds before retry..."
				Start-Sleep -Seconds 30
				continue
			}

			throw
		}
	}

	if ($response.Meta.ResponseCode -eq 200) {
		Write-Host "Success setting passcode $passcode on device $serial."
	}
}

#Export the functions

Export-ModuleMember -Function qc