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
 		$result = Invoke-SPDSCCommand -Credential $InstallAccount `
                                  -Arguments $PSBoundParameters `
                                  -ScriptBlock {
        	$params = $args[0]
			
			$ssa = Get-SPSecureStoreApplication -ServiceContext $params.WebAppUrl -Name $params.Name -ErrorAction SilentlyContinue
			if($null -eq $ssa)
			{
				return @{
					WebAppUrl     = $params.WebAppUrl
					Name          = $params.Name
					DisplayName   = $params.DisplayName
					ContactEmail  = $params.ContactEmail
					TargetAppType = $params.TargetAppType
					Fields        = $null
					Ensure        = "Absent"
				}
			}
			else {
				$appFields = $ssa.TargetApplicationFields;
				$fields = @()
				foreach($appField in $appFields)
				{
					$field = @{}
					$field.Name = $appField.Name
					$field.Type = $appField.CredentialType
					$field.Masked = $appField.IsMasked
					$fields.Add($field)
				}

				return @{
					WebAppUrl     = $params.WebAppUrl
					Name          = $params.Name
					DisplayName   = $ssa.TargetApplication.FriendlyName
					ContactEmail  = $ssa.TargetApplication.ContactEmail
					TargetAppType = $ssa.TargetApplication.Type
					Fields        = $fields
					Ensure        = "Present"
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
	$CurrentValue = Get-TargetResource @PSBoundParameters
	if($Ensure -eq "Present" -and $CurrentValue.Ensure -eq "Absent")
	{
		Write-Verbose "New Secure Store Application '$Name'."
		
		Invoke-SPDSCCommand -Credential $InstallAccount `
                                  -Arguments $PSBoundParameters `
                                  -ScriptBlock {
        	$params = $args[0]
			
			Write-Verbose "Creating Secure Store Target Application '$Name'."
 			$ssta = New-SPSecureStoreTargetApplication -Name $params.Name -FriendlyName $params.DisplayName -ContactEmail $params.ContactEmail -ApplicationType $params.TargetAppType

			Write-Verbose "Adding Secure Store Application Fields."
			$appFields = @()
			$credentialValues = @()
			$fields = $params.Fields
			foreach($field in $fields)
			{
				$appField = New-SPSecureStoreApplicationField -Name $field.Name -Type $field.Type -Masked:$($field.Masked)
				$appFields.Add($appField)
				$credentialValues.Add($field.Credential.Password)
			}

			Write-Verbose "Creating a Secure Store Application"

			$ssa = New-SPSecureStoreApplication -ServiceContext $params.WebAppUrl `
										 -TargetApplication $ssta `
										 -Fields $appFields `
										 -Administrator $adminClaims `
										 -CredentialsOwnerGroup $ownerClaims

			if($params.TargetAppType -eq "Group")
			{
				Write-Verbose "Adding Credential Mapping to Secure Store Application for Groups"
				Update-SPSecureStoreGroupCredentialMapping -Identity $ssa -Values $credentialValues
			}
		}
	} 
	if($Ensure -eq "Present" -and $CurrentValue.Ensure -eq "Present")
	{
		Write-Verbose "Update Secure Store Application '$Name'."
		Invoke-SPDSCCommand -Credential $InstallAccount `
                                  -Arguments $PSBoundParameters `
                                  -ScriptBlock {
        	$params = $args[0]

			$ssa = Get-SPSecureStoreApplication -ServiceContext $params.WebAppUrl -Name $params.Name -ErrorAction SilentlyContinue
			if($null -eq $ssa)
			{
				throw "Secure Store Application '$params.Name' was not found."
			}

			


		}

	}
	if($Ensure -eq "Absent")
	{
		Write-Verbose "Removing Secure Store Application '$Name'."
		Invoke-SPDSCCommand -Credential $InstallAccount `
                                  -Arguments $PSBoundParameters `
                                  -ScriptBlock {
        	$params = $args[0]
		
			$ssa = Get-SPSecureStoreApplication -ServiceContext $params.WebAppUrl -Name $params.Name -ErrorAction SilentlyContinue
			if($null -ne $ssa)
			{
				Remove-SPSecureStoreApplication -Identity $ssa 
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

	$CurrentValues = Get-TargetResource @PSBoundParameters

	$result = Test-SPDscParameterState -CurrentValues $CurrentValues `
                                    -DesiredValues $PSBoundParameters `
                                    -ValuesToCheck @("DisplayName", "ContactEmail", "TargetAppType", "Ensure")
	if($result)
	{
		
		if($CurrentValues.Fields.Count -eq $Fields.Count)
		{
			$curFields = $CurrentValues.Fields;
			#Evaluate Fields
			for($i = 0; i -lt $Fields.Count; $i++)
			{
				$curField = $curFields[$i]
				$field = $Fields[$i]

				$result = Test-SPDscParameterState -CurrentValues $curField `
												   -DesiredValues $field	
												   -ValuesToCheck @("Name", "Type", "Masked")
			   if(-not ($result))
			   {
				   return $false
			   }
			}
			

			return $true
		}
		else {
			return $false
		}
	}
	
}


Export-ModuleMember -Function *-TargetResource

