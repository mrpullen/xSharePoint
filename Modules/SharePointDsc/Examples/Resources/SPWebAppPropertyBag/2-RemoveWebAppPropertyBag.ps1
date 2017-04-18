<#
.EXAMPLE
    This example shows how to remove a property bag entry from a Web Application.
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
            Ensure = "Absent"
            PsDscRunAsCredential = $SetupAccount
        }
    }
}
