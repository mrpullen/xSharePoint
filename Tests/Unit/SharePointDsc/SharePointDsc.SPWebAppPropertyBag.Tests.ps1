[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string] 
    $SharePointCmdletModule = (Join-Path -Path $PSScriptRoot `
                                         -ChildPath "..\Stubs\SharePoint\15.0.4805.1000\Microsoft.SharePoint.PowerShell.psm1" `
                                         -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\UnitTestHelper.psm1" `
                                -Resolve)

$Global:SPDscHelper = New-SPDscUnitTestHelper -SharePointStubModule $SharePointCmdletModule `
                                              -DscResource "SPWebAppPropertyBag"

Describe -Name $Global:SPDscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:SPDscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:SPDscHelper.InitializeScript -NoNewScope

        # Test contexts
        Context -Name 'No SharePoint Web Application was detected' {
            $testParams = @{
                WebAppUrl = "http://sharepoint.contoso.com"
                Key       = 'PropertyKey'
                Value     = 'PropertyValue'
            }

            Mock -CommandName Get-SPWebApplication -MockWith { 
               return $null
            }

            $result = Get-TargetResource @testParams

            It 'Should return absent from the get method' {
                $result.Ensure | Should Be 'Absent'
            }

            It 'Should return the same values as passed as parameters' {
                $result.Key | Should Be $testParams.Key
            }

            It 'Should return null as the value used' {
                $result.value | Should Be ([System.String]::Empty)
            }           

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should throw an exception in the set method to say there is no Web Application' {
                { Set-TargetResource @testParams } | Should throw "Web Application '$($testParams.WebAppUrl)' was not found."
            }
        }

        Mock -CommandName Get-SPWebApplication -MockWith {
            $spWebApp = [pscustomobject]@{
                Properties = @{
                    "PropertyKey" = "PropertyValue"
                }
            }
            $spWebApp = $spWebApp | Add-Member ScriptMethod Update { 
                $Global:SPDscFarmPropertyUpdated = $true 
            } -PassThru
            $spWebApp = $spWebApp | Add-Member ScriptMethod Remove { 
                $Global:SPDscFarmPropertyRemoved = $true 
            } -PassThru
            return $spWebApp
        }

        Context -Name 'The Web Application property does not exist, but should be' -Fixture {
              $testParams = @{
                WebAppUrl = "http://sharepoint.contoso.com"
                Key       = 'PropertyKey'
                Value     = 'NewPropertyValue'
            }
            
            $result = Get-TargetResource @testParams

            It 'Should return present from the get method' {
                $result.Ensure | Should Be 'present'
            }

            It 'Should return the same key value as passed as parameter' {
                $result.Key | Should Be $testParams.Key
            }      

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should not throw an exception in the set method' {
                { Set-TargetResource @testParams } | Should not throw
            }

            $Global:SPDscFarmPropertyUpdated = $false
            It 'Calls Get-SPFarm and update farm property bag from the set method' { 
                Set-TargetResource @testParams 

                $Global:SPDscFarmPropertyUpdated | Should Be $true
            }
        }

        Context -Name 'The Web Application property exists, and should be' -Fixture {
             $testParams = @{
                WebAppUrl = "http://sharepoint.contoso.com"
                Key       = 'PropertyKey'
                Value     = 'PropertyValue'
                Ensure    = 'Present'
            }
            
            $result = Get-TargetResource @testParams

            It 'Should return present from the get method' {
                $result.Ensure | Should Be 'present'
            }

            It 'Should return the same values as passed as parameters' {
                $result.Key | Should Be $testParams.Key
                $result.value | Should Be $testParams.value
            }          

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name 'The Web Application property does not exist, and should be' -Fixture {
              $testParams = @{
                WebAppUrl = "http://sharepoint.contoso.com"
                Key       = 'PropertyKeyD'
                Value     = [System.String]::Empty
                Ensure    = 'Absent'
            }
            
            $result = Get-TargetResource @testParams

            It 'Should return absent from the get method' {
                $result.Ensure | Should Be 'absent'
            }

            It 'Should return the same values as passed as parameters' {
                $result.Key | Should Be $testParams.Key
                $result.value | Should Be $testParams.value
            }          

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name 'The Web Application property exists, but should not be' -Fixture {
              $testParams = @{
                WebAppUrl = "http://sharepoint.contoso.com"
                Key       = 'PropertyKey'
                Value     = 'PropertyValue'
                Ensure    = 'Absent'
            }
            
            $result = Get-TargetResource @testParams

            It 'Should return Present from the get method' {
                $result.Ensure | Should Be 'Present'
            }

            It 'Should return the same values as passed as parameters' {
                $result.Key | Should Be $testParams.Key
                $result.value | Should Be $testParams.Value
            }           

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should not throw an exception in the set method' {
                { Set-TargetResource @testParams } | Should not throw
            }

            $Global:SPDscFarmPropertyUpdated = $false
            It 'Calls Get-SPFarm and remove farm property bag from the set method' { 
                Set-TargetResource @testParams 

                $Global:SPDscFarmPropertyUpdated | Should Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:SPDscHelper.CleanupScript -NoNewScope
