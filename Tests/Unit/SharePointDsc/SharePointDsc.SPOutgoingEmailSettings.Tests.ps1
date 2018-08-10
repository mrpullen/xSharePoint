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
                                              -DscResource "SPOutgoingEmailSettings"

Describe -Name $Global:SPDscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:SPDscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:SPDscHelper.InitializeScript -NoNewScope

        # Test contexts
        Context -Name "The Web Application isn't available" -Fixture {
            $testParams = @{
                WebAppUrl = "http://sharepoint.contoso.com"
                SMTPServer = "smtp.contoso.com"
                FromAddress = "from@email.com"
                ReplyToAddress = "reply@email.com"
                CharacterSet= "65001"
            }

            Mock -CommandName Get-SPWebApplication -MockWith  { 
                return $null
            }

            It "Should return null from the get method" {
                Get-TargetResource @testParams | Should BeNullOrEmpty 
            }

            It "Should return false from the test method" {
                Test-TargetResource @testParams | Should be $false
            }

            It "Should throw an exception in the set method" {
                { Set-TargetResource @testParams } | Should throw
            }
        }

        Context -Name "The web application exists and the properties match" -Fixture {
            $testParams = @{
                WebAppUrl = "http://sharepoint.contoso.com"
                SMTPServer = "smtp.contoso.com"
                FromAddress = "from@email.com"
                ReplyToAddress = "reply@email.com"
                CharacterSet= "65001"
            }
            
            Mock -CommandName Get-SPWebapplication -MockWith { 
                return @{
                    Url= "http://sharepoint.contoso.com"
                    OutboundMailServiceInstance= @{
                        Server = @{
                            Name = "smtp.contoso.com"
                        }
                    }
                    OutboundMailSenderAddress = "from@email.com"
                    OutboundMailReplyToAddress= "reply@email.com"
                    OutboundMailCodePage= "65001"
                }
            }
            
            It "Should return web app properties from the get method" {
                Get-TargetResource @testParams | Should Not BeNullOrEmpty 
            }

            It "Should return true from the test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        } 

        Context -Name "The web application exists and the properties don't match" -Fixture {
            $testParams = @{
                WebAppUrl = "http://sharepoint.contoso.com"
                SMTPServer = "smtp.contoso.com"
                FromAddress = "from@email.com"
                ReplyToAddress = "reply@email.com"
                CharacterSet= "65001"
            }
            
            Mock -CommandName Get-SPWebapplication -MockWith { 
                $result = @{
                    Url= "http://sharepoint.contoso.com"
                    OutboundMailServiceInstance= @{
                        Server = @{
                            Name = "smtp2.contoso.com"
                        }
                    }
                    OutboundMailSenderAddress = "from@email.com"
                    OutboundMailReplyToAddress= "reply@email.com"
                    OutboundMailCodePage= "65001"
                }
                $result = $result | Add-Member -MemberType ScriptMethod `
                                               -Name UpdateMailSettings `
                                               -Value {
                                                    param( 
                                                        [string]
                                                        $SMTPServer, 
                                                        
                                                        [string]
                                                        $FromAddress, 
                                                        
                                                        [string]
                                                        $ReplyToAddress, 
                                                        [string]
                                                        $CharacterSet
                                                    )
                                                    $Global:SPDscUpdateMailSettingsCalled = $true;
                                                } -PassThru
                return $result
            }

            It "Should return false from the get method" {
                Get-TargetResource @testParams | Should Not BeNullOrEmpty
            }

            It "Should return false from the test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should call the new and set methods from the set function" {
                $Global:SPDscUpdateMailSettingsCalled = $false
                Set-TargetResource @testParams
                $Global:SPDscUpdateMailSettingsCalled | Should Be $true
            }
        }

        if ($Global:SPDscHelper.CurrentStubBuildNumber.Major -eq 15)
        {
            Context -Name "UseTLS is using in SharePoint 2013" -Fixture {
                $testParams = @{
                    WebAppUrl = "http://sharepoint.contoso.com"
                    SMTPServer = "smtp.contoso.com"
                    FromAddress = "from@email.com"
                    ReplyToAddress = "reply@email.com"
                    UseTLS = $true
                    CharacterSet= "65001"
                }

                It "Should throw an exception in the get method" {
                    { Get-TargetResource @testParams } | Should Throw "UseTLS is only supported in SharePoint 2016." 
                }

                It "Should throw an exception in the test method" {
                    { Test-TargetResource @testParams } | Should Throw "UseTLS is only supported in SharePoint 2016."
                }

                It "Should throw an exception in the set method" {
                    { Set-TargetResource @testParams } | Should Throw "UseTLS is only supported in SharePoint 2016."
                }
            }

            Context -Name "SMTPPort is using in SharePoint 2013" -Fixture {
                $testParams = @{
                    WebAppUrl = "http://sharepoint.contoso.com"
                    SMTPServer = "smtp.contoso.com"
                    FromAddress = "from@email.com"
                    ReplyToAddress = "reply@email.com"
                    SMTPPort = 25
                    CharacterSet= "65001"
                }

                It "Should throw an exception in the get method" {
                    { Get-TargetResource @testParams } | Should Throw "SMTPPort is only supported in SharePoint 2016." 
                }

                It "Should throw an exception in the test method" {
                    { Test-TargetResource @testParams } | Should Throw "SMTPPort is only supported in SharePoint 2016."
                }

                It "Should throw an exception in the set method" {
                    { Set-TargetResource @testParams } | Should Throw "SMTPPort is only supported in SharePoint 2016."
                }
            }
        }

        if ($Global:SPDscHelper.CurrentStubBuildNumber.Major -eq 16)
        {
            Context -Name "The web application exists and the properties match - SharePoint 2016" -Fixture {
                $testParams = @{
                    WebAppUrl = "http://sharepoint.contoso.com"
                    SMTPServer = "smtp.contoso.com"
                    FromAddress = "from@email.com"
                    CharacterSet= "65001"
                    ReplyToAddress = "reply@email.com"
                    UseTLS = $false
                    SMTPPort = 25
                }
                
                Mock -CommandName Get-SPWebapplication -MockWith { 
                    return @{
                        Url= "http://sharepoint.contoso.com"
                        OutboundMailServiceInstance= @{
                            Server = @{
                                Name = "smtp.contoso.com"
                            }
                        }
                        OutboundMailSenderAddress = "from@email.com"
                        OutboundMailReplyToAddress= "reply@email.com"
                        OutboundMailCodePage= "65001"
                        OutboundMailEnableSsl = $false
                        OutboundMailPort = 25
                    }
                }
                
                It "Should return web app properties from the get method" {
                    Get-TargetResource @testParams | Should Not BeNullOrEmpty 
                }

                It "Should return true from the test method" {
                    Test-TargetResource @testParams | Should Be $true
                }
            } 

            Context -Name "The web application exists and the properties don't match - SharePoint 2016" -Fixture {
                $testParams = @{
                    WebAppUrl = "http://sharepoint.contoso.com"
                    SMTPServer = "smtp.contoso.com"
                    FromAddress = "from@email.com"
                    ReplyToAddress = "reply@email.com"
                    CharacterSet= "65001"
                    UseTLS = $true
                    SMTPPort = 25
                }
                
                Mock -CommandName Get-SPWebapplication -MockWith { 
                    $result = @{
                        Url= "http://sharepoint.contoso.com"
                        OutboundMailServiceInstance= @{
                            Server = @{
                                Name = "smtp.contoso.com"
                            }
                        }
                        OutboundMailSenderAddress = "from@email.com"
                        OutboundMailReplyToAddress= "reply@email.com"
                        OutboundMailCodePage= "65001"
                        OutboundMailEnableSsl = $false
                        OutboundMailPort = 25
                    }
                    $result = $result | Add-Member -MemberType ScriptMethod `
                                                -Name UpdateMailSettings `
                                                -Value {
                                                        param( 
                                                            [string]
                                                            $SMTPServer, 
                                                            
                                                            [string]
                                                            $FromAddress, 
                                                            
                                                            [string]
                                                            $ReplyToAddress,
                                                            
                                                            [string]
                                                            $CharacterSet,

                                                            [bool]
                                                            $EnableSsl,

                                                            [string]
                                                            $Port
                                                        )
                                                        $Global:SPDscUpdateMailSettingsCalled = $true;
                                                    } -PassThru
                    return $result
                }

                It "Should return false from the get method" {
                    (Get-TargetResource @testParams).SMTPPort | Should Be 25
                    (Get-TargetResource @testParams).UseTLS | Should Be $false
                }

                It "Should return false from the test method" {
                    Test-TargetResource @testParams | Should Be $false
                }

                It "Should call the new and set methods from the set function" {
                    $Global:SPDscUpdateMailSettingsCalled = $false
                    Set-TargetResource @testParams
                    $Global:SPDscUpdateMailSettingsCalled | Should Be $true
                }
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:SPDscHelper.CleanupScript -NoNewScope
