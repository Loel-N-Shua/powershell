# input parameter is the search term on script names
param (
	[string]$script
	)
	
# call in functions 
. .\functions

$headers = Get-Headers

# get all scripts
$encodedTerm = [System.Uri]::EscapeDataString($script)
try { 
	$scriptsResponse = Invoke-RestMethod -Uri "https://32market.pulseway.com/api/v3/automation/scripts?`$filter=contains(Name, '$encodedTerm')&`$skip=0" -Headers $headers -Method GET 
} catch { 
	Write-Error "Failed to GET script: $_"
}

# match to script results
$scriptResult = $scriptsResponse.Data | Where-Object { $_.Name -like "*$script*" }

# output an error if matching script cannot be found
if (-not $scriptResult) {
	Write-Error "Could not find script matching $script."
}

# list the script name and the matching ID
Write-Host $scriptResult