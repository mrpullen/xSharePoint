[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
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
                                              -DscResource "SPCreateFarm"

Describe -Name $Global:SPDscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:SPDscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:SPDscHelper.InitializeScript -NoNewScope

        # Initialize tests
        $mockPassword = ConvertTo-SecureString -String "password" -AsPlainText -Force
        $mockFarmAccount = New-Object -TypeName "System.Management.Automation.PSCredential" `
                                      -ArgumentList @("username", $mockPassword)
        $mockPassphrase = New-Object -TypeName "System.Management.Automation.PSCredential" `
                                     -ArgumentList @("PASSPHRASEUSER", $mockPassword)                                      

        $modulePath = "Modules\SharePointDsc\Modules\SharePointDsc.Farm\SPFarm.psm1"
        Import-Module -Name (Join-Path -Path $Global:SPDscHelper.RepoRoot -ChildPath $modulePath -Resolve)

        # Mocks for all contexts   
        Mock -CommandName New-SPConfigurationDatabase -MockWith {}
        Mock -CommandName Install-SPHelpCollection -MockWith {}
        Mock -CommandName Initialize-SPResourceSecurity -MockWith {}
        Mock -CommandName Install-SPService -MockWith {}
        Mock -CommandName Install-SPFeature -MockWith {}
        Mock -CommandName New-SPCentralAdministration -MockWith {}
        Mock -CommandName Install-SPApplicationContent -MockWith {}
        Mock -CommandName Get-SPDSCConfigDBStatus -MockWith {
            return @{
                Locked = $false
                ValidPermissions = $true
                DatabaseExists = $false
            }
        } -Verifiable

        # Test contexts
        Context -Name "no farm is configured locally and a supported version of SharePoint is installed" -Fixture {
            $testParams = @{
                FarmConfigDatabaseName = "SP_Config"
                DatabaseServer = "DatabaseServer\Instance"
                FarmAccount = $mockFarmAccount
                Passphrase =  $mockPassphrase
                AdminContentDatabaseName = "Admin_Content"
                CentralAdministrationAuth = "Kerberos"
                CentralAdministrationPort = 1234
            }            

            Mock -CommandName Get-SPDSCRegistryKey -MockWith {
                if ($Value -eq "dsn")
                {
                    return $null
                }
            }

            Mock -CommandName Get-SPFarm -MockWith { throw "Unable to detect local farm" }

            It "the get method returns null when the farm is not configured" {
                Get-TargetResource @testParams | Should BeNullOrEmpty
            }

            It "Should return false from the test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should call the new configuration database cmdlet in the set method" {
                Set-TargetResource @testParams
                switch ($Global:SPDscHelper.CurrentStubBuildNumber.Major)
                {
                    15 {
                        Assert-MockCalled New-SPConfigurationDatabase
                    }
                    16 {
                        Assert-MockCalled New-SPConfigurationDatabase -ParameterFilter { $ServerRoleOptional -eq $true }
                    }
                    Default {
                        throw [Exception] "A supported version of SharePoint was not used in testing"
                    }
                }
            }

            if ($Global:SPDscHelper.CurrentStubBuildNumber.Major -eq 16) 
            {
                $testParams.Add("ServerRole", "WebFrontEnd")
                It "Should create a farm with a specific server role" {
                    Set-TargetResource @testParams
                    Assert-MockCalled New-SPConfigurationDatabase -ParameterFilter { $LocalServerRole -eq "WebFrontEnd" }
                }
                $testParams.Remove("ServerRole")
            }
        }

        if ($Global:SPDscHelper.CurrentStubBuildNumber.Major -eq 15) 
        {
            Context -Name "only valid parameters for SharePoint 2013 are used" -Fixture {
                $testParams = @{
                    FarmConfigDatabaseName = "SP_Config"
                    DatabaseServer = "DatabaseServer\Instance"
                    FarmAccount = $mockFarmAccount
                    Passphrase =  $mockPassphrase
                    AdminContentDatabaseName = "Admin_Content"
                    CentralAdministrationAuth = "Kerberos"
                    CentralAdministrationPort = 1234
                    ServerRole = "WebFrontEnd"
                }

                It "Should throw if server role is used in the get method" {
                    { Get-TargetResource @testParams } | Should Throw
                }

                It "Should throw if server role is used in the test method" {
                    { Test-TargetResource @testParams } | Should Throw
                }

                It "Should throw if server role is used in the set method" {
                    { Set-TargetResource @testParams } | Should Throw
                }
            }
        }

        if ($Global:SPDscHelper.CurrentStubBuildNumber.Major -eq 16)
        {
            Context -Name "enhanced minrole options fail when Feature Pack 1 is not installed" -Fixture {
                $testParams = @{
                    FarmConfigDatabaseName = "SP_Config"
                    DatabaseServer = "DatabaseServer\Instance"
                    FarmAccount = $mockFarmAccount
                    Passphrase =  $mockPassphrase
                    AdminContentDatabaseName = "Admin_Content"
                    CentralAdministrationAuth = "Kerberos"
                    CentralAdministrationPort = 1234
                    ServerRole = "ApplicationWithSearch"
                }

                Mock -CommandName Get-SPDSCInstalledProductVersion -MockWith {
                    return @{
                        FileMajorPart = 16
                        FileBuildPart = 0
                    }
                }

                It "Should throw if an invalid server role is used in the get method" {
                    { Get-TargetResource @testParams } | Should Throw
                }

                It "Should throw if an invalid server role is used in the test method" {
                    { Test-TargetResource @testParams } | Should Throw
                }

                It "Should throw if an invalid server role is used in the set method" {
                    { Set-TargetResource @testParams } | Should Throw
                }
            }

            Context -Name "enhanced minrole options succeed when Feature Pack 1 is installed" -Fixture {
                $testParams = @{
                    FarmConfigDatabaseName = "SP_Config"
                    DatabaseServer = "DatabaseServer\Instance"
                    FarmAccount = $mockFarmAccount
                    Passphrase =  $mockPassphrase
                    AdminContentDatabaseName = "Admin_Content"
                    CentralAdministrationAuth = "Kerberos"
                    CentralAdministrationPort = 1234
                    ServerRole = "ApplicationWithSearch"
                }

                Mock -CommandName Get-SPDSCRegistryKey -MockWith {
                    if ($Value -eq "dsn")
                    {
                        return $null
                    }
                }

                Mock -CommandName Get-SPDSCInstalledProductVersion -MockWith {
                    return @{
                        FileMajorPart = 16
                        FileBuildPart = 4456
                    }
                }

                It "Should throw if an invalid server role is used in the get method" {
                    { Get-TargetResource @testParams } | Should Not Throw
                }

                It "Should throw if an invalid server role is used in the test method" {
                    { Test-TargetResource @testParams } | Should Not Throw
                }

                It "Should throw if an invalid server role is used in the set method" {
                    { Set-TargetResource @testParams } | Should Not Throw
                }
            }
        }

        Context -Name "no farm is configured locally and an unsupported version of SharePoint is installed on the server" -Fixture {
            $testParams = @{
                FarmConfigDatabaseName = "SP_Config"
                DatabaseServer = "DatabaseServer\Instance"
                FarmAccount = $mockFarmAccount
                Passphrase =  $mockPassphrase
                AdminContentDatabaseName = "Admin_Content"
                CentralAdministrationAuth = "Kerberos"
                CentralAdministrationPort = 1234
            }
            
            Mock -CommandName Get-SPDSCInstalledProductVersion -MockWith { return @{ FileMajorPart = 14 } }

            It "Should throw when an unsupported version is installed and set is called" {
                { Set-TargetResource @testParams } | Should throw
            }
        }

        Context -Name "a farm exists locally and is the correct farm" -Fixture {
            $testParams = @{
                FarmConfigDatabaseName = "SP_Config"
                DatabaseServer = "DatabaseServer\Instance"
                FarmAccount = $mockFarmAccount
                Passphrase =  $mockPassphrase
                AdminContentDatabaseName = "Admin_Content"
                CentralAdministrationAuth = "Kerberos"
                CentralAdministrationPort = 1234
            }

            Mock -CommandName Get-SPDSCRegistryKey -MockWith {
                if ($Value -eq "dsn")
                {
                    return $testParams.FarmConfigDatabaseName
                }
            }
            
            Mock -CommandName Get-SPFarm -MockWith { 
                return @{ 
                    DefaultServiceAccount = @{ 
                        Name = $testParams.FarmAccount.UserName 
                    }
                    Name = $testParams.FarmConfigDatabaseName
                }
            }
            
            Mock -CommandName Get-SPDatabase -MockWith { 
                return @(@{ 
                    Name = $testParams.FarmConfigDatabaseName
                    Type = "Configuration Database"
                    Server = @{ 
                        Name = $testParams.DatabaseServer 
                    }
                })
            } 
            
            Mock -CommandName Get-SPWebApplication -MockWith { 
                return @(@{
                    IsAdministrationWebApplication = $true
                    ContentDatabases = @(@{ 
                        Name = $testParams.AdminContentDatabaseName 
                    })
                    Url = "http://$($env:ComputerName):$($testParams.CentralAdministrationPort)"
                })
            }

            It "the get method returns values when the farm is configured" {
                Get-TargetResource @testParams | Should Not BeNullOrEmpty
            }

            It "Should return true from the test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "a farm exists locally, is the correct farm but SPFarm is not reachable" -Fixture {
            $testParams = @{
                FarmConfigDatabaseName = "SP_Config"
                DatabaseServer = "DatabaseServer\Instance"
                FarmAccount = $mockFarmAccount
                Passphrase =  $mockPassphrase
                AdminContentDatabaseName = "Admin_Content"
                CentralAdministrationAuth = "Kerberos"
                CentralAdministrationPort = 1234
            }

            Mock -CommandName Get-SPDSCRegistryKey -MockWith {
                if ($Value -eq "dsn")
                {
                    return $testParams.FarmConfigDatabaseName
                }
            }
            
            Mock -CommandName Get-SPFarm -MockWith { return $null }
            
            Mock -CommandName Get-SPDatabase -MockWith { 
                return @(@{ 
                    Name = $testParams.FarmConfigDatabaseName
                    Type = "Configuration Database"
                    Server = @{ 
                        Name = $testParams.DatabaseServer 
                    }
                })
            } 
            
            Mock -CommandName Get-SPWebApplication -MockWith { 
                return @(@{
                    IsAdministrationWebApplication = $true
                    ContentDatabases = @(@{ 
                        Name = $testParams.AdminContentDatabaseName 
                    })
                    Url = "http://$($env:ComputerName):$($testParams.CentralAdministrationPort)"
                })
            }

            Mock -CommandName Get-SPDSCConfigDBStatus -MockWith {
                return @{
                    Locked = $true
                    ValidPermissions = $false
                    DatabaseExists = $true
                }
            }

            It "Should throw when server already joined to farm but SPFarm not reachable" {
                { Get-TargetResource @testParams } | Should Throw
            }

            It "Should throw when the current user does not have sufficient permissions to SQL Server" {
                { Set-TargetResource @testParams } | Should Throw
            }
        }

        Context -Name "a farm exists locally and is not the correct farm" -Fixture {
            $testParams = @{
                FarmConfigDatabaseName = "SP_Config"
                DatabaseServer = "DatabaseServer\Instance"
                FarmAccount = $mockFarmAccount
                Passphrase =  $mockPassphrase
                AdminContentDatabaseName = "Admin_Content"
                CentralAdministrationAuth = "Kerberos"
                CentralAdministrationPort = 1234
            }

            Mock -CommandName Get-SPDSCRegistryKey -MockWith {
                if ($Value -eq "dsn")
                {
                    return "WrongDBName"
                }
            }

            Mock -CommandName Get-SPFarm -MockWith { 
                return @{ 
                    DefaultServiceAccount = @{ Name = $testParams.FarmAccount.UserName }
                    Name = "WrongDBName"
                }
            }
            
            Mock -CommandName Get-SPDatabase -MockWith { 
                return @(@{ 
                    Name = "WrongDBName"
                    Type = "Configuration Database"
                    Server = @{ 
                        Name = $testParams.DatabaseServer 
                    }
                })
            } 
            
            Mock -CommandName Get-SPWebApplication -MockWith { 
                return @(@{
                    IsAdministrationWebApplication = $true
                    ContentDatabases = @(@{ 
                        Name = $testParams.AdminContentDatabaseName 
                    })
                    Url = "http://$($env:ComputerName):$($testParams.CentralAdministrationPort)"
                })
            }

            It "Should throw an error in the set method" {
                { Set-TargetResource @testParams } | Should throw
            }
        }

        Context -Name "a farm exists locally with the wrong farm account" -Fixture {
            $testParams = @{
                FarmConfigDatabaseName = "SP_Config"
                DatabaseServer = "DatabaseServer\Instance"
                FarmAccount = $mockFarmAccount
                Passphrase =  $mockPassphrase
                AdminContentDatabaseName = "Admin_Content"
                CentralAdministrationAuth = "Kerberos"
                CentralAdministrationPort = 1234
            }
            
            Mock -CommandName Get-SPDSCRegistryKey -MockWith {
                if ($Value -eq "dsn")
                {
                    return $testParams.FarmConfigDatabaseName
                }
            }

            Mock -CommandName Get-SPFarm -MockWith { 
                return @{ 
                    DefaultServiceAccount = @{ Name = "WRONG\account" }
                    Name = $testParams.FarmConfigDatabaseName
                }
            }
            
            Mock -CommandName Get-SPDatabase -MockWith { 
                return @(@{ 
                    Name = $testParams.FarmConfigDatabaseName
                    Type = "Configuration Database"
                    Server = @{ Name = $testParams.DatabaseServer }
                })
            } 
            
            Mock -CommandName Get-SPWebApplication -MockWith { 
                return @(@{
                    IsAdministrationWebApplication = $true
                    ContentDatabases = @(@{ 
                        Name = $testParams.AdminContentDatabaseName 
                    })
                    Url = "http://$($env:ComputerName):$($testParams.CentralAdministrationPort)"
                })
            }

            It "the get method returns current values" {
                Get-TargetResource @testParams | Should Not BeNullOrEmpty
            }

            It "Should return true from the test method as changing the farm account isn't supported so set shouldn't be called" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "no farm is configured locally, a supported version is installed and no central admin port is specified" -Fixture {
            $testParams = @{
                FarmConfigDatabaseName = "SP_Config"
                DatabaseServer = "DatabaseServer\Instance"
                FarmAccount = $mockFarmAccount
                Passphrase =  $mockPassphrase
                AdminContentDatabaseName = "Admin_Content"
                CentralAdministrationAuth = "Kerberos"
            }

            Mock -CommandName Get-SPDSCRegistryKey -MockWith {
                if ($Value -eq "dsn")
                {
                    return $null
                }
            }

            It "uses a default value for the central admin port" {
                Set-TargetResource @testParams
                Assert-MockCalled New-SPCentralAdministration -ParameterFilter { $Port -eq 9999 }
            }
        }
        
        Context -Name "no farm is configured locally, a supported version is installed and no central admin auth is specified" -Fixture {
            $testParams = @{
                FarmConfigDatabaseName = "SP_Config"
                DatabaseServer = "DatabaseServer\Instance"
                FarmAccount = $mockFarmAccount
                Passphrase =  $mockPassphrase
                AdminContentDatabaseName = "Admin_Content"
            }

            Mock -CommandName Get-SPDSCRegistryKey -MockWith {
                if ($Value -eq "dsn")
                {
                    return $null
                }
            }

            It "uses NTLM for the Central Admin web application authentication" {
                Set-TargetResource @testParams
                Assert-MockCalled New-SPCentralAdministration -ParameterFilter { $WindowsAuthProvider -eq "NTLM" }
            }
        }

    }
}

Invoke-Command -ScriptBlock $Global:SPDscHelper.CleanupScript -NoNewScope
