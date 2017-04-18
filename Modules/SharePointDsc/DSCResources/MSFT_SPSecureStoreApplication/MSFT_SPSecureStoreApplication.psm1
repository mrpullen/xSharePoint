function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
		param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$SecureStoreServiceApp,

		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[parameter(Mandatory = $true)]
		[System.String]
		$ContactEmail,

		[parameter(Mandatory = $true)]
		[ValidateSet("Individual","Group","IndividualWithTicketing","GroupWithTicketing","RestrictedIndividual","RestrictedGroup")]
		[System.String]
		$TargetAppType,

		[System.String]
		$UrlType,

		[parameter(Mandatory = $false)] 
        [Microsoft.Management.Infrastructure.CimInstance[]] 
        $Fields,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure = "Present",

		[System.Management.Automation.PSCredential]
		$InstallAccount
	)

		Write-Verbose "Get Secure Store Application '$Name'."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	<#
	$returnValue = @{
		SecureStoreServiceApp = [System.String]
		Name = [System.String]
		DisplayName = [System.String]
		ContactEmail = [System.String]
		TargetAppType = [System.String]
		UrlType = [System.String]
		Ensure = [System.String]
		InstallAccount = [System.Management.Automation.PSCredential]
	}

	$returnValue
	#>
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$SecureStoreServiceApp,

		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[parameter(Mandatory = $true)]
		[System.String]
		$ContactEmail,

		[parameter(Mandatory = $true)]
		[ValidateSet("Individual","Group","IndividualWithTicketing","GroupWithTicketing","RestrictedIndividual","RestrictedGroup")]
		[System.String]
		$TargetAppType,

		[System.String]
		$UrlType,

		[parameter(Mandatory = $false)] 
        [Microsoft.Management.Infrastructure.CimInstance[]] 
        $Fields,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure = "Present",

		[System.Management.Automation.PSCredential]
		$InstallAccount
	)

	Write-Verbose "Set Secure Store Application '$Name'."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

	#Include this line if the resource requires a system reboot.
	#$global:DSCMachineStatus = 1


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$SecureStoreServiceApp,

		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[parameter(Mandatory = $true)]
		[System.String]
		$ContactEmail,

		[parameter(Mandatory = $true)]
		[ValidateSet("Individual","Group","IndividualWithTicketing","GroupWithTicketing","RestrictedIndividual","RestrictedGroup")]
		[System.String]
		$TargetAppType,

		[System.String]
		$UrlType,

		[parameter(Mandatory = $false)] 
        [Microsoft.Management.Infrastructure.CimInstance[]] 
        $Fields,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure = "Present",

		[System.Management.Automation.PSCredential]
		$InstallAccount
	)

	Write-Verbose "Test Secure Store Application '$Name'."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	<#
	$result = [System.Boolean]
	
	$result
	#>
}


Export-ModuleMember -Function *-TargetResource

