function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserProfileService,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Rules,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $InstallAccount
    )

    Write-Verbose -Message "Getting the audience $Name from Audience Manager from site: $MySiteHostUrl"



    $result = Invoke-SPDSCCommand -Credential $InstallAccount `
                                  -Arguments $PSBoundParameters `
                                  -ScriptBlock {
        $params = $args[0]
        $site = Get-SPSite -Identity $params.SiteUrl `
                           -ErrorAction SilentlyContinue

        $upsa = Get-SPServiceApplication -Name $params.UserProfileService `
                                         -ErrorAction SilentlyContinue
        $nullReturn = @{
            UserProfileService = $params.UserProfileService
            Name = $params.Name
            Description = ""
            Rules = ""
            Ensure = "Absent"
        }
        if ($null -eq $upsa)
        {
            return $nullReturn
        }


        if ($null -eq $site)
        {
            return @{
                SiteUrl = ""
                Name = ""
                Description = ""
                Rules = ""
                Ensure = "Absent"
                InstallAccount = $params.InstallAccount
            }
        }

        $ctx = [Microsoft.Office.Server.ServerContext]::GetContext($site)
        $audienceManager = New-Object Microsoft.OFfice.Server.Audience.AudienceManager($ctx)
        if($audienceManager.Audiences.AudienceExist($params.Name)) {
            $audience = $audienceManager.Audiences[$params.Name]
            $audienceRules = $audience.AudienceRules
            $rules = @()
            foreach($audRule in $audienceRules) {
                $newRule = @{
                    LeftContent = if($null -ne $audRule.LeftContent) { $audRule.LeftContent } else { "" }
                    Operator = $audRule.Operator
                    RightContent = if($null -ne $audRule.RightContent) { $audRule.RightContent } else { "" }
                }
                $rules.Add($newRule)
            }
            return @{
                SiteUrl = $params.SiteUrl
                Name = $params.Name
                Description = $audience.AudienceDescription
                Rules = $rules
                Ensure = "Present"
                InstallAccount = $params.InstallAccount
            }
        }
        else {

            return @{
                SiteUrl = $params.SiteUrl
                Name = $params.Name
                Description = ""
                Rules = @()
                Ensure = "Absent"
                InstallAccount = $params.InstallAccount
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Rules,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $InstallAccount
    )

    Write-Verbose -Message "Setting the audience $Name in Audience Manager from site: $SiteUrl"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ([System.String]::IsNullOrEmpty($CurrentValues.SiteUrl) -eq $true)
    {
        throw "Unable to locate site url $SiteUrl"
    }

    Invoke-SPDSCCommand -Credential $InstallAccount `
                        -Arguments @($PSBoundParameters, $CurrentValues) `
                        -ScriptBlock {
        $params = $args[0]
        $CurrentValues = $args[1]

        $site = Get-SPSite -Identity $params.SiteUrl
        $ctx = [Microsoft.Office.Server.ServerContext]::GetContext($site)
        $audienceManager = New-Object Microsoft.OFfice.Server.Audience.AudienceManager($ctx)

        if($params.Ensure -eq "Absent" -and $CurrentValues.Ensure -eq "Present") {
            ## Try to Delete Audience
            if($audienceManager.Audiences.AudienceExist($params.Name)) {
                $audienceManager.Remove($params.Name)
            }
        }
        if($params.Ensure -eq "Present" -and $CurrentValues.Ensure -eq "Absent") {
            ## Try to Create Audience
            $audienceRules = @()
            foreach($rule in $params.Rules) {
                $audienceRules += New-Object Microsoft.Office.Server.Audience.AudienceRuleComponent($rule.LeftContent, $rule.Operator, $rule.RightContent)
            }

            $aud = $audienceManager.Audiences.Create($Name, $Description)
            $aud.AudienceRules = New-Object System.Collections.ArrayList
            $audienceRules | ForEach-Object { $aud.AudienceRules.Add($_) }
            #Save the new Audience
            $aud.Commit()
            # Compile the new Audience
            # $upa = Get-SPServiceApplication | Where-Object {$_.DisplayName -eq "User Profile Service Application"}
            # $audJob = [Microsoft.Office.Server.Audience.AudienceJob]::RunAudienceJob(($upa.Id.Guid.ToString(), "1", "1", $aud.AudienceName))
        }
        if($params.Ensure -eq "Present" -and $CurrentValues.Ensure -eq "Present") {

           if($params.Description -ne $CurrentValues.Description)
           {
                $audience = $audienceManager.Audiences[$params.Name]
                $audience.AudienceDescription = $params.Description
                $audince.Commit()
           }

           $replaceRules = $false
           if($params.Rules.length -gt 0 -and $CurrentValues.Rules.length -gt 0)
           {
                if($params.Rules.length -ne $CurrentValues.Rules.length) {
                    $replaceRules = $true
                }
                else {
                    for($i = 0; $i -lt $params.Rules.length; $i++) {
                        if($params.Rules[$i].LeftContent -ne $CurrentValues.Rules[$i].LeftContent -or
                        $params.Rules[$i].Operator -ne $CurrentValues.Rules[$i].Operator -or
                        $params.Rules[$i].RightContent -ne $CurrentValues.Rules[$i].RightContent) {
                            $replaceRules = $true
                        }

                    }
                }

                if($replaceRules) {
                    ##delete the rule and recreate - the rules have changed!!
                    if($audienceManager.Audiences.AudienceExist($params.Name)) {
                        $audienceManager.Remove($params.Name)
                    }

                    $audienceRules = @()
                    foreach($rule in $params.Rules) {
                        $audienceRules += New-Object Microsoft.Office.Server.Audience.AudienceRuleComponent($rule.LeftContent, $rule.Operator, $rule.RightContent)
                    }

                    $aud = $audienceManager.Audiences.Create($Name, $Description)
                    $aud.AudienceRules = New-Object System.Collections.ArrayList
                    $audienceRules | ForEach-Object { $aud.AudienceRules.Add($_) }
                    #Save the new Audience
                    $aud.Commit()
                    # Compile the new Audience
                    # $upa = Get-SPServiceApplication | Where-Object {$_.DisplayName -eq "User Profile Service Application"}
                    # $audJob = [Microsoft.Office.Server.Audience.AudienceJob]::RunAudienceJob(($upa.Id.Guid.ToString(), "1", "1", $aud.AudienceName))
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Rules,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $InstallAccount
    )

    Write-Verbose -Message "Testing all audience parameters"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if([System.String]::IsNullOrEmpty($CurrentValues.SiteUrl) -eq $true)
    {
        return $false
    }

    if($Description -ne $CurrentValues.Description) {
        return $false
    }
    if($Rules.Length -eq $CurrentValues.Rules.Length) {
        for($i = 0; $i -lt $Rules.Length; $i++) {
            if($Rules[$i].LeftContent -ne $CurrentValues.Rules[$i].LeftContent -or
            $Rules[$i].Operator -ne $CurrentValues.Rules[$i].Operator -or
            $Rules[$i].RightContent -ne $CurrentValues.Rules[$i].RightContent) {
                return $false;
            }
        }
    }
    else {
        return $false
    }

    return ($Ensure -eq $CurrentValues.Ensure)


}

Export-ModuleMember -Function *-TargetResource
