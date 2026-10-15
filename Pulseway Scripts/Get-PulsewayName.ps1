function Get-PulsewayName {
	param(
		[string]$identifier
		)
		
	. ./functions

	$headers = Get-Headers
	$encodedID = [System.Uri]::EscapeDataString($identifier)
	$path = "https://32market.pulseway.com/api/v3/devices/"
	try {
		$response = Invoke-RestMethod -Uri "https://32market.pulseway.com/api/v3/devices/$identifier" `
			-Headers $headers `
			-Method GET 
	} catch {
		Write-Error "Unable to locate device $identifier."
	}
	
	Write-Host $response.Data.Name

}