# .ExternalHelp psPAS-help.xml
function Get-PASGroup {
	[CmdletBinding(DefaultParameterSetName = 'groupType')]
	param(
		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'groupType'
		)]
		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'includeMembers'
		)]
		[ValidateSet('Directory', 'Vault')]
		[string]$groupType,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'filter'
		)]
		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'includeMembers'
		)]
		[ValidateSet('groupType eq Directory', 'groupType eq Vault')]
		[string]$filter,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[string]$search,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'groupType'
		)]
		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'filter'
		)]
		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'includeMembers'
		)]
		[boolean]$includeMembers
	)

	BEGIN {
		Assert-VersionRequirement -RequiredVersion 10.5
	}#begin

	PROCESS {

		switch ($PSCmdlet.ParameterSetName) {

			'includeMembers' {

				Assert-VersionRequirement -RequiredVersion 12.0

			}

			default {

				#Create URL for request
				$URI = "$Script:BaseURI/API/UserGroups"

				#Get Parameters to include in request
				$boundParameters = $PSBoundParameters | Get-PASParameter -ParametersToRemove groupType
				$filterProperties = $PSBoundParameters | Get-PASParameter -ParametersToKeep groupType
				$FilterString = $filterProperties | ConvertTo-FilterString

				If ($null -ne $FilterString) {

					$boundParameters = $boundParameters + $FilterString

				}

				#Create Query String, escaped for inclusion in request URL
				$queryString = $boundParameters | ConvertTo-QueryString

				if ($null -ne $queryString) {

					#Build URL from base URL
					$URI = "$URI`?$queryString"

				}

				#send request to web service
				$result = Invoke-PASRestMethod -Uri $URI -Method GET -WebSession $Script:WebSession

				If ($null -ne $result) {

					$result.value | Add-ObjectDetail -typename psPAS.CyberArk.Vault.Group

				}

			}

		}

	}#process

	END { }#end

}