# Import functions and get headers before running tests
BeforeAll {
	. ./functions.ps1
	$headers = Get-Headers
}

Describe "Get-Identifier Unit Tests" {
	# Each expected value acquired directly through Pulseway by running query script on the device
	$TestData = @(
		@{ Name = "TSM23-8551"; Expected = "f5426da1-b207-433d-b333-42bbdfa1c457" }
		@{ Name = "CGO25-12404"; Expected = "6ea143ea-f17d-49ae-a049-77631402f95d" }
		@{ Name = "ETSMX19-5516"; Expected = "7f2ebd7e-4d60-4ddb-85d8-b2787b5bd553" }
		@{ Name = "DTSM20-5455"; Expected = "855e3504-6fc6-465e-a22f-fc8241fe61ce" }
		@{ Name = "TSM24-9446"; Expected = "b97912c0-1a83-42da-a8b1-29ef08b20d75" }
		@{ Name = "TSM-2085"; Expected = "311edae3-2029-489e-bec8-9247959a22e7" }
		@{ Name = "CGO25-12085"; Expected = "d22ad3d1-446d-47c0-8dcf-5a46f7b75ce1" }
		@{ Name = "TSM-2102"; Expected = "1aafaee7-8850-41b3-be3f-32dea3469689" }
		@{ Name = "CGO25-12102"; Expected = "4fc4ade1-e291-4471-8e30-def99b0cf200" }
		@{ Name = "TSM-2307"; Expected = "a6f7b57a-3746-469f-8d8e-09380f1909e1" }
		@{ Name = "CGO25-12307"; Expected = "2c6d0ab0-1cb2-4339-bb14-8a6277cd3eec" }
		@{ Name = "CGO24-10014"; Expected = "754c2f96-b15f-4ae8-922a-fcaaaa483ad3" }
		@{ Name = "CGO24-9393"; Expected = "b7979054-7bae-4c68-b69d-249e6ef38f69" }
		@{ Name = "DTSM21-6215"; Expected = "8815225f-a70f-46a6-812e-e570820848e3" }
		@{ Name = "ETSM21-5912"; Expected = "1bae2569-0d32-43c1-87a7-67cda5e88ad6" }
		@{ Name = "DTSM21-6213"; Expected = "f6df8d90-3fd0-4b84-856a-e59d9c8c8e0d" }
		@{ Name = "TSMX19-3326"; Expected = "f3d9f475-2863-4a9f-a123-2c28ed5a4adc" }
		@{ Name = "DTSM22-4933"; Expected = "a2bfd9fb-78d7-45e2-9636-c2eff859d0ad" }
		@{ Name = "TSM24-8180"; Expected = "1eb3a9aa-f730-4f1e-87f5-894636d9f393" }
		@{ Name = "CGO26-12449"; Expected = "451453ae-17b5-4c88-82ef-1b4ca848bd32" }
	)
	
	It "Correctly returns the identifier of <Name> to be <Expected>" -ForEach $TestData {
		# Run Get-Identifiers for each device
		$Result = Get-Identifier $Name $headers
		
		# Assert the outcome
		$Result | Should -Be $Expected
	}
		
}