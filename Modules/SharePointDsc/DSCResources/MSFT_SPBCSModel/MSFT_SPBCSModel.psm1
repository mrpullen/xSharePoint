function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory=$true)]
        [System.String]
        $Url,

        [parameter(Mandatory = $true)]
        [System.String]
        $ModelFile,

        [ValidateSet("BdcCatalog","Model","LobSystem","LobSystemInstance","Entity")]
        [parameter(Mandatory = $true)]
        [System.String]
        $BDCObjectType,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [System.Management.Automation.PSCredential]
        $InstallAccount
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    <#
    $returnValue = @{
    Name = [System.String]
    ModelFile = [System.String]
    BDCObjectType = [System.String]
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
        $Name,

        [Parameter(Mandatory=$true)]
        [System.String]
        $Url,

        [parameter(Mandatory = $true)]
        [System.String]
        $ModelFile,

        [ValidateSet("BdcCatalog","Model","LobSystem","LobSystemInstance","Entity")]
        [parameter(Mandatory = $true)]
        [System.String]
        $BDCObjectType,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [System.Management.Automation.PSCredential]
        $InstallAccount
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

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
        $Name,

        [Parameter(Mandatory=$true)]
        [System.String]
        $Url,

        [parameter(Mandatory = $true)]
        [System.String]
        $ModelFile,

        [ValidateSet("BdcCatalog","Model","LobSystem","LobSystemInstance","Entity")]
        [parameter(Mandatory = $true)]
        [System.String]
        $BDCObjectType,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [System.Management.Automation.PSCredential]
        $InstallAccount
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    <#
    $result = [System.Boolean]
    
    $result
    #>
}


Export-ModuleMember -Function *-TargetResource

