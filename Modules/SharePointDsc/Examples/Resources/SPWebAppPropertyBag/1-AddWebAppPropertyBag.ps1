<#
.EXAMPLE
    This example shows how add property bag entry to a Web Application.
#>

Configuration Example 
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $SetupAccount
    )

    Import-DscResource -ModuleName SharePointDsc

    node localhost 
    {
        SPWebAppPropertyBag TenantSite_WebAppProperty
        {
            WebAppUrl = "http://sharepoint.contoso.com"
            Key = "TenantUrl"
            Value = "http://sharepoint.contoso.com/tenantadmin"
            Ensure = "Present"
            PsDscRunAsCredential = $SetupAccount
        }
    }
}
