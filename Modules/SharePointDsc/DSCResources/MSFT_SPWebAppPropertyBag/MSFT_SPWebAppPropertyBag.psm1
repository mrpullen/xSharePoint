function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$WebAppUrl,

		[parameter(Mandatory = $true)]
		[System.String]
		$Key,
		
		[parameter(Mandatory = $false)]
		[System.String]
		$Value = [System.String]::Empty,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure = "Present",

		[System.Management.Automation.PSCredential]
		$InstallAccount

	)

	Write-Verbose -Message "Looking for SPWebApplication property '$Key'"

	$result = Invoke-SPDSCCommand -Credential $InstallAccount `
                                  -Arguments $PSBoundParameters `
                                  -ScriptBlock {
        	$params = $args[0]

			try {
				$spWebApp = Get-SPWebApplication -Identity $params.WebAppUrl
				if($null -ne $spWebApp)
				{
					if($spWebApp.Properties) 
					{
						if($spWebApp.Properties[$params.Key])
						{
							return @{
								WebAppUrl = $params.WebAppUrl
								Key       = $params.Key
								Value     = $spWebApp.Properties[$params.Key]
								Ensure    = "Present"
							}
						}
						
					}	
				}
				return @{
					WebAppUrl = $params.WebAppUrl
					Key       = $params.Key
					Value     = [System.String]::Empty
					Ensure    = "Absent"
				}
			}
			catch
			{
				Write-Verbose -Message "The SPWebApplication was not found"
				return @{
					WebAppUrl = $params.WebAppUrl
					Key       = $params.Key
					Value     = [System.String]::Empty
					Ensure    = "Absent"
				}
			}		
		}
		
		return $result
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$WebAppUrl,

		[parameter(Mandatory = $true)]
		[System.String]
		$Key,

		[parameter(Mandatory = $false)]
		[System.String]
		$Value = [System.String]::Empty,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure = "Present",

		[System.Management.Automation.PSCredential]
		$InstallAccount
	)

	Write-Verbose -Message "Setting SPWebApplication property '$Key'"

	Invoke-SPDSCCommand -Credential $InstallAccount `
                        -Arguments $PSBoundParameters `
                        -ScriptBlock {
        	$params = $args[0]

			$spWebApp = Get-SPWebApplication -Identity $params.WebAppUrl `
			                                 -ErrorAction SilentlyContinue
											 
			if($null -eq $spWebApp)
			{
				throw "Web Application '$($params.WebAppUrl)' was not found."
			}
			else 
			{
				if($params.Ensure -eq "Present")
				{
					if($params.Value)
					{
						Write-Verbose -Message "Adding property '$params.Key'='$params.Value' to SPWebApplication.Properties"
						$spWebApp.Properties[$params.Key] = $params.Value
						$spWebApp.Update()
					}
					else 
					{
						Write-Warning -Message "Ensure = 'Present', value parameter cannot be null"
						throw "Value parameter cannot be null or empty"						
					}
				}	
				else 
				{
					if($spWebApp.Properties[$params.Key])
					{
						Write-Verbose -Message "Removing property '$params.Key' from SPWebApplication.Properties"	
						$spWebApp.Properties.Remove($params.Key)
						$spWebApp.Update()
					}
					else 
					{
						Write-Verbose -Message "The property '$params.Key' was not found in the SPWebApplication.Properties Property Bag"
					}
					
				}
			}			
	}
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$WebAppUrl,

		[parameter(Mandatory = $true)]
		[System.String]
		$Key,

		[parameter(Mandatory = $false)]
		[System.String]
		$Value = [System.String]::Empty,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure = "Present",

		[System.Management.Automation.PSCredential]
		$InstallAccount
	)

	Write-Verbose -Message "Testing the SPWebApplication property '$Key'"

	 $CurrentValues = Get-TargetResource @PSBoundParameters

	 return Test-SPDscParameterState -CurrentValues $CurrentValues `
                                    -DesiredValues $PSBoundParameters `
                                    -ValuesToCheck @('Ensure','Key','Value')

}


Export-ModuleMember -Function *-TargetResource

