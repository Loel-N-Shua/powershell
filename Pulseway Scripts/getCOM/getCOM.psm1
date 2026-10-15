function getCOM {
	# Input the device serial number as a parameter to this script.
	[CmdletBinding()]
	param (
		[ValidatePattern('^(D?E?TSMX?\d{0,2}-\d{4,5}|CGO\d{0,2}-\d{4,5}|RR\d{0,2}-\d{4,5})$')]
		[string]$serial
	)

	# dot source the functions script
	#. .\functions.ps1

	# Pulseway authentication and headers
	$headers = Get-Headers

	# GET all systems from Pulseway
	$targetSystem = Get-Identifier $serial

	$scriptID = "3c19b159-39fd-4508-9102-045e40f9884e"

	# POST body as per Pulseway's API spec, converted to JSON.
	$Body = @{
		DeviceIdentifier = $targetSystem
	} | ConvertTo-Json -Depth 10

	# POST request to Pulseway to run the script
	$response = $null
	$maxRetries = 5

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
				$stream = $_.Exception.Response.GetResponseStream()
				$stream.Position = 0
				$reader = New-Object System.IO.StreamReader($stream)
				$responseBody = $reader.ReadToEnd()
				$reader.Close()
				$stream.Close()
			}
			catch {}

			$statusCode = $_.Exception.Response.StatusCode.value__

			if (
				$statusCode -eq 400 -and
				$responseBody -match "already being executed."
			) {
				if ($attempt -eq $maxRetries) {
					throw "Script is still executing after $maxRetries attempts."
				}

				Write-Warning "Script already executing. Waiting 30 seconds before retry..."
				Start-Sleep -Seconds 3
				continue
			}

			throw "Request failed with status $statusCode. Response: $responseBody"
		}
	}

	# Extract the execution ID from the POST response
	$executionID = $response.Data.ExecutionID
	Write-Host "Script triggered. Execution ID: $executionID. Waiting for completion..."

	# Poll the execution status until it finishes
	$pollMaxRetries = 5
	$pollIntervalSeconds = 2
	$completed = $false

	for ($poll = 1; $poll -le $pollMaxRetries; $poll++) {

		try {
			$result = Invoke-RestMethod `
				-Uri "https://32market.pulseway.com/api/v3/automation/scripts/$scriptID/device/$targetSystem/executions/$executionID" `
				-Headers $headers `
				-Method GET `
				-ErrorAction Stop

			$status = $result.Data.State
			Write-Host "Poll $poll of $pollMaxRetries - Status: $status"

			if ($status -in @('Running', 'Failed', 'Successful', 'Stopped')) {
				$completed = $true
				break
			}

			Start-Sleep -Seconds $pollIntervalSeconds
		}
		catch {
			$pollError = ""
			try {
				$stream = $_.Exception.Response.GetResponseStream()
				$stream.Position = 0
				$reader = New-Object System.IO.StreamReader($stream)
				$pollError = $reader.ReadToEnd()
				$reader.Close()
				$stream.Close()
			}
			catch {}

			Write-Warning "Failed to poll execution status on attempt $poll ($pollError). Retrying..."
			Start-Sleep -Seconds $pollIntervalSeconds
		}
	}

	if (-not $completed) {
		throw "Execution did not complete after $pollMaxRetries polling attempts."
	}

	if ($result.Data.State -eq 'Successful') {
		Write-Output $result.Data.Output
	}
	else {
		$status = $result.Data.State
		$output = $result.Data.Output
		throw "Script execution ended with status: $status. Output: $output"
	}
}	
