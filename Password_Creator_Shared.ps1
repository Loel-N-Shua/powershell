function Get-PassOption {
	Write-Host ""
	Write-Host "Password Strength Options"
	Write-Host "[1] Standard (16 characters)"
	Write-Host "[2] Strong   (20 characters)"
	Write-Host "[3] Very Strong (24 characters)"
	Write-Host "[4] Custom (12-64 characters)"

	$Choice = Read-Host "Select option"

	switch ($Choice) {
		"1" { $PasswordLength = 16 }
		"2" { $PasswordLength = 20 }
		"3" { $PasswordLength = 24 }
		"4" { 
			do {
				$PasswordLength = Read-Host "Enter desired length (12-64)" 
			} until ( $PasswordLength -as [int] -and [int]$PasswordLength -ge 12 -and [int]$PasswordLength -le 64 )
		}
		default { $PasswordLength = 20 }
	}
	$PasswordLength = [int] $PasswordLength
	$WordLength = $PasswordLength - 2
	return $WordLength
}

function Get-Pass {

    param(
        [string]$PasswordFile
    )

    if ([string]::IsNullOrWhiteSpace($PasswordFile)) {
        $PasswordFile = Read-Host "Enter path for password file"
    }

    # Create file if it doesn't exist
    if (!(Test-Path $PasswordFile)) {
        New-Item -Path $PasswordFile -ItemType File -Force | Out-Null
    }

    $WordLength = Get-PassOption

    do {

        do {

			$Word1Length = Get-Random -Minimum 3 -Maximum ($WordLength - 2)
			$Word2Length = $WordLength - $Word1Length

			$uri = "https://random-word-api.herokuapp.com/word?length=$Word1Length"
			$word1 = Invoke-RestMethod -Uri $uri
			$word1 = (Get-Culture).TextInfo.ToTitleCase($word1)

			$uri = "https://random-word-api.herokuapp.com/word?length=$Word2Length"
			$word2 = Invoke-RestMethod -Uri $uri
			$word2 = (Get-Culture).TextInfo.ToTitleCase($word2)

		} until (($word1.Length + $word2.Length) -eq $WordLength)

        $symbol = @('.','!','@',':',',','?','+','=','-','_','%','$','#','^','&','*')
        $symbolIndex = Get-Random -Minimum 0 -Maximum $symbol.Count

        $password = (Get-Random -Maximum 10).ToString() +
                    $word1 +
                    $symbol[$symbolIndex] +
                    $word2

        Write-Host ""
        Write-Host "Generated Password:" -ForegroundColor Cyan
        Write-Host "$password ($($password.Length) chars)" -ForegroundColor Yellow
        Write-Host ""

        do {
            $choice = (Read-Host "Accept this password? [Y] Save [N] Regenerate [Q] Quit").ToUpper()

            if ($choice -eq "Q") {
                Write-Host "Password generation cancelled." -ForegroundColor Yellow
                return
            }

        } until ($choice -in @('Y','N'))

    } while ($choice -eq 'N')

    $accountName = Read-Host "What is this password for"

    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $entry = "$date | $accountName | $password"

    Add-Content -Path $PasswordFile -Value $entry

    Write-Host ""
    Write-Host "Saved to $PasswordFile" -ForegroundColor Green
}