[CmdletBinding()]
param(
    [Parameter()]
    [string] 
    $SharePointCmdletModule = (Join-Path -Path $PSScriptRoot `
                                         -ChildPath "..\Stubs\SharePoint\15.0.4805.1000\Microsoft.SharePoint.PowerShell.psm1" `
                                         -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\UnitTestHelper.psm1" `
                                -Resolve)

$Global:SPDscHelper = New-SPDscUnitTestHelper -SharePointStubModule $SharePointCmdletModule `
                                              -DscResource "SPProjectServerPermissionMode"

Describe -Name $Global:SPDscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:SPDscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:SPDscHelper.InitializeScript -NoNewScope

        switch ($Global:SPDscHelper.CurrentStubBuildNumber.Major) 
        {
            15 {
                Context -Name "All methods throw exceptions as Project Server support in SharePointDsc is only for 2016" -Fixture {
                    It "Should throw on the get method" {
                        { Get-TargetResource @testParams } | Should Throw
                    }

                    It "Should throw on the test method" {
                        { Test-TargetResource @testParams } | Should Throw
                    }

                    It "Should throw on the set method" {
                        { Set-TargetResource @testParams } | Should Throw
                    }
                }
            }
            16 {
                Mock -CommandName Set-SPProjectPermissionMode -MockWith { }

                Context -Name "Permissions are in SharePoint mode, and should be" -Fixture {
                    $testParams = @{
                        Url = "http://projects.contoso.com"
                        PermissionMode = "SharePoint"
                    }

                    Mock -CommandName Get-SPProjectPermissionMode -MockWith { return "SharePoint" }
                    It "should return the correct value for its current mode in the get method" {
                        (Get-TargetResource @testParams).PermissionMode | Should Be "SharePoint"
                    }

                    It "should return true in the test method" {
                        Test-TargetResource @testParams | Should Be $true
                    }
                }

                Context -Name "Permissions are in ProjectServer mode, and should be" -Fixture {
                    $testParams = @{
                        Url = "http://projects.contoso.com"
                        PermissionMode = "ProjectServer"
                    }

                    Mock -CommandName Get-SPProjectPermissionMode -MockWith { return "ProjectServer" }

                    It "should return the correct value for its current mode in the get method" {
                        (Get-TargetResource @testParams).PermissionMode | Should Be "ProjectServer"
                    }

                    It "should return true in the test method" {
                        Test-TargetResource @testParams | Should Be $true
                    }
                }

                Context -Name "Permissions are in SharePoint mode, and shouldn't be" -Fixture {
                    $testParams = @{
                        Url = "http://projects.contoso.com"
                        PermissionMode = "ProjectServer"
                    }

                    Mock -CommandName Get-SPProjectPermissionMode -MockWith { return "SharePoint" }

                    It "should return the correct value for its current mode in the get method" {
                        (Get-TargetResource @testParams).PermissionMode | Should Be "SharePoint"
                    }

                    It "should return false in the test method" {
                        Test-TargetResource @testParams | Should Be $false
                    }

                    It "should update the value in the set method" {
                        Set-TargetResource @testParams
                        Assert-MockCalled -CommandName Set-SPProjectPermissionMode
                    }
                }

                Context -Name "Permissions are in ProjectServer mode, and shouldn't be" -Fixture {
                    $testParams = @{
                        Url = "http://projects.contoso.com"
                        PermissionMode = "SharePoint"
                    }

                    Mock -CommandName Get-SPProjectPermissionMode -MockWith { return "ProjectServer" }

                    It "should return the correct value for its current mode in the get method" {
                        (Get-TargetResource @testParams).PermissionMode | Should Be "ProjectServer"
                    }

                    It "should return false in the test method" {
                        Test-TargetResource @testParams | Should Be $false
                    }

                    It "should update the value in the set method" {
                        Set-TargetResource @testParams
                        Assert-MockCalled -CommandName Set-SPProjectPermissionMode
                    }
                }

                Context -Name "Unable to determine permissions mode" -Fixture {
                    $testParams = @{
                        Url = "http://projects.contoso.com"
                        PermissionMode = "SharePoint"
                    }

                    Mock -CommandName Get-SPProjectPermissionMode -MockWith { throw "Unkown error" }

                    It "should return 'unkonwn' in the get method" {
                        (Get-TargetResource @testParams).PermissionMode | Should Be "unknown"
                    }
                }

                
            }
            Default {
                throw [Exception] "A supported version of SharePoint was not used in testing"
            }
        }
    }
}
