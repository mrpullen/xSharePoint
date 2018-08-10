# Change log for SharePointDsc

## 2.4

* SPCacheAccounts
  * Fixed issue where the Test method would fail if SetWebAppPolicy was set to
    false.
* SPDistributedCacheService
  * Updated resource to allow updating the cache size
* SPFarm
  * Implemented ability to deploy Central Administration site to a server at a
    later point in time
* SPInfoPathFormsServiceConfig
  * Fixed issue with trying to set the MaxSizeOfUserFormState parameter
* SPProductUpdate
  * Fixed an issue where the resource failed when the search was already paused
* SPProjectServerLicense
  * Fixed issue with incorrect detection of the license
* SPSearchContentSource
  * Fixed issue where the Get method returned a conversion error when the content
    source contained just one address
  * Fixed issue 840 where the parameter StartHour was never taken into account
* SPSearchServiceApp
  * Fixed issue where the service account was not set correctly when the service
    application was first created
  * Fixed issue where the Get method throws an error when the service app wasn't
    created properly
* SPSearchTopology
  * Fixed issue where Get method threw an error when the specified service
    application didn't exist yet.
* SPServiceAppSecurity
  * Fixed issue where error was thrown when no permissions were set on the
    service application
* SPShellAdmins
  * Updated documentation to specify required permissions for successfully using
    this resource
* SPTrustedIdentityTokenIssuerProviderRealms
  * Fixed code styling issues
* SPUserProfileServiceApp
  * Fixed code styling issues

## 2.3

* Changes to SharePointDsc
  * Added a Branches section to the README.md with Codecov and build badges for
    both master and dev branch.
* All Resources
  * Added information about the Resource Type in each ReadMe.md files.
* SPFarm
  * Fixed issue where the resource throws an exception if the farm already
    exists and the server has been joined using the FQDN (issue 795)
* SPTimerJobState
  * Fixed issue where the Set method for timerjobs deployed to multiple web
    applications failed.
* SPTrustedIdentityTokenIssuerProviderRealms
  * Added the resource.
* SPUserProfileServiceApp
  * Now supported specifying the host Managed path, and properly sets the host.
  * Changed error for running with Farm Account into being a warning
* SPUserProfileSyncConnection
  * Added support for filtering disabled users
  * Fixed issue where UseSSL was set to true resulted in an error
  * Fixed issue where the connection was recreated when the name contained a
    dot (SP2016)

## 2.2

* SPAlternateURL
  * If resource specifies Central Admin webapp and Default Zone, the existing
    AAM will be updated instead of adding a new one.
* SPContentDatabase
  * Fixed issue where mounting a content database which had to be upgraded
    resulted in a reboot.
* SPDistributedCacheClientSettings
  * Added the new resource
* SPFarmAdministrators
  * Fixed issue where member comparisons was case sensitive. This had
    to be case insensitive.
* SPManagedMetadataServiceApp
  * Fixed issue with creating the Content Type Hub on an existing MMS
    service app without Content Type Hub.
* SPManagedMetadataServiceAppDefault
  * Fixed issue where .GetType().FullName and TypeName were not used
    properly.
* SPTimerJobState
  * Updated description of WebAppUrl parameter to make it clear that
    "N/A" has to be used to specify a global timer job.
* SPUserProfileServiceApp
  * Fixed issue introduced in v2.0, where the Farm Account had to have
    local Administrator permissions for the resource to function properly.
  * Updated resource to retrieve the Farm account from the Managed Accounts
    instead of requiring it as a parameter.
* SPUserProfileSyncService
  * Fixed issue introduced in v2.0, where the Farm Account had to have
    local Administrator permissions for the resource to function properly.
  * Updated resource to retrieve the Farm account from the Managed Accounts
    instead of requiring it as a parameter.
  * The FarmAccount parameter is deprecated and no longer required. Is ignored
    in the code and will be removed in v3.0.
* SPVisioServiceApp
  * Fixed an issue where the proxy is not properly getting created

## 2.1

* General
  * Updated the integration tests for building the Azure environment
    * Works in any Azure environment.
    * Updated the SqlServer configuration to use SqlServerDsc version 10.0.0.0.
* SPAlternateURL
  * Added the ability to manage the Central Administration AAMs
* SPDiagnosticsProvider
  * Added the resource
* SPFarm
  * Corrected issue where ServerRole parameter is returned in SP2013
* SPInfoPathFormsServiceConfig
  * Added the resource
* SPInstallPrereqs
  * Fixed two typos in to be installed Windows features for SharePoint 2016
* SPSearchAutoritativePage
  * Added missing readme.md
* SPSearchCrawlerImpactRule
  * Fixed issue where an error was thrown when retrieving Crawl Impact rules
  * Added missing readme.md
* SPSearchCrawlMapping
  * Added missing readme.md
* SPSecureStoreServiceApp
  * Fixed issue in Get-TargetResource to return AuditingEnabled property
* SPSecurityTokenServiceConfig
  * Added the resource
* SPServiceIdentity
  * Fixed issue with correctly retrieving the process identity for the
    Search instance
  * Added support for LocalSystem, LocalService and NetworkService
* SPUserProfileProperty
  * Fixed issues with the User Profile properties for 2016
* SPUserProfileServiceAppPermissions
  * Removed the mandatory requirement from secondary parameters
* SPUserProfileSyncConnection
  * Fixed issues with the User Profile Sync connection for SharePoint
    2016
* SPUserProfileSyncService
  * Added returning the FarmAccount to the Get method
* SPWebAppAuthentication
  * Corrected issue where parameter validation wasn't performed correctly
* SPWebApplicationExtension
  * Fixed issue with test always failing when Ensure was set to Absent
* SPWorkManagementServiceApp
  * Added check for SharePoint 2016, since this functionality has been
    removed in SharePoint 2016

## 2.0

* General
  * Added VSCode workspace settings to meet coding guidelines
  * Corrected comment in CodeCov.yml
  * Fixed several PSScriptAnalyzer warnings
* SPAppManagementServiceApp
  * Fixed an issue where the instance name wasn't detected correctly
* SPBCSServiceApp
  * Added custom Proxy Name support
  * Fixed an issue where the instance name wasn't detected correctly
* SPBlobCacheSettings
  * Update to set non-default or missing blob cache properties
* SPContentDatabase
  * Fixed localized issue
* SPDesignerSettings
  * Fixed issue where URL with capitals were not accepted correctly
* SPDistributedCacheService
  * Fixed issue where reprovisioning the Distributed Cache
    did not work
* SPFarm
  * Implemented ToDo to return Central Admin Auth mode
  * Fixed an issue where the instance name wasn't detected correctly
* SPInstall
  * Updated to document the requirements for an English ISO
* SPInstallPrereqs
  * Updated to document which parameter is required for which
    version of SharePoint
  * Added SharePoint 2016 example
* SPLogLevel
  * New resource
* SPMachineTranslationServiceApp
  * Added custom Proxy Name support
  * Fixed an issue where the instance name wasn't detected correctly
* SPManagedMetadataAppDefault
  * New resource
* SPManagedMetadataServiceApp
  * Update to allow the configuration of the default and
    working language
  * Fixed issue where the termstore could not be retrieved if the
    MMS service instance was stopped
  * Fixed an issue where the instance name wasn't detected correctly
* SPMinRoleCompliance
  * New resource
* SPPerformancePointServiceApp
  * Fixed an issue where the instance name wasn't detected correctly
* SPProjectServer
  * New resources to add Project Server 2016 support:
  SPProjectServerLicense, SPProjectServerAdditionalSettings,
  SPProjectServerADResourcePoolSync, SPProjectServerGlobalPermissions,
  SPProjectServerGroup, SPProjectServerTimeSheetSettings,
  SPProjectServerUserSyncSettings, SPProjectServerWssSettings
* SPSearchContentSource
  * Fixed examples
* SPSearchIndexPartition
  * Fixed to return the RootFolder parameter
* SPSearchServiceApp
  * Fixed an issue where the instance name wasn't detected correctly
* SPSearchTopology
  * Updated to better document how the resource works
  * Fixed issue to only return first index partition to prevent
    conflicts with SPSearchIndexPartition
* SPSecureStoreServiceApp
  * Fixed issue with not returning AuditEnabled parameter in Get method
  * Fixed an issue where the instance name wasn't detected correctly
* SPServiceAppSecurity
  * Fixed issue with NullException when no accounts are configured
    in SharePoint
* SPStateServiceApp
  * Added custom Proxy Name support
  * Fixed an issue where the instance name wasn't detected correctly
* SPSubscriptionSettings
  * Fixed an issue where the instance name wasn't detected correctly
* SPTrustedRootAuthority
  * Updated to enable using private key certificates.
* SPUsageApplication
  * Fixed an issue where the instance name wasn't detected correctly
* SPUserProfileProperty
  * Fixed two NullException issues
* SPUserProfileServiceApp
  * Fixed an issue where the instance name wasn't detected correctly
* SPUserProfileSynConnection
  * Fix an issue with ADImportConnection
* SPWeb
  * Update to allow the management of the access requests settings
* SPWebAppGeneralSettings
  * Added DefaultQuotaTemplate parameter
* SPWebApplicationExtension
  * Update to fix how property AllowAnonymous is returned in the
    hashtable
* SPWebAppPeoplePickerSettings
  * New resource
* SPWebAppPolicy
  * Fixed issue where the SPWebPolicyPermissions couldn't be used
    twice with the exact same values
* SPWebAppSuiteBar
  * New resource
* SPWebApplication.Throttling
  * Fixed issue with where the RequestThrottling parameter was
    not applied
* SPWordAutomationServiceApp
  * Fixed an issue where the instance name wasn't detected correctly
* SPWorkflowService
  * New resource

The following changes will break 1.x configurations that use these resources:

* SPAlternateUrl
  * Added the Internal parameter, which implied a change to the key parameters
* SPCreateFarm
  * Removed resource, please update your configurations to use SPFarm.
    See http://aka.ms/SPDsc-SPFarm for details.
* SPJoinFarm
  * Removed resource, please update your configurations to use SPFarm.
    See http://aka.ms/SPDsc-SPFarm for details.
* SPManagedMetadataServiceApp
  * Changed implementation of resource. This resource will not set any defaults
    for the keyword and site collection term store. The new resource
    SPManagedMetadataServiceAppDefault has to be used for this setting.
* SPShellAdmin
  * Updated so it also works for non-content databases
* SPTimerJobState
  * Updated to make the WebAppUrl parameter a key parameter.
    The resource can now be used to configure the same job for multiple
    web applications. Also changed the Name parameter to TypeName, due to
    a limitation with the SPTimerJob cmdlets
* SPUserProfileProperty
  * Fixed an issue where string properties were not created properly
* SPUSerProfileServiceApp
  * Updated to remove the requirement for CredSSP
* SPUserProfileSyncService
  * Updated to remove the requirement for CredSSP
* SPWebAppAuthentication
  * New resource
* SPWebApplication
  * Changed implementation of the Web Application authentication configuration.
    A new resource has been added and existing properties have been removed
* SPWebApplicationExtension
  * Updated so it infers the UseSSL value from the URL
  * Changed implementation of the Web Application authentication configuration.
    A new resource has been added and existing properties have been removed

## 1.9

* New resource: SPServiceIdentity

## 1.8

* Fixed issue in SPServiceAppProxyGroup causing some service names to return as null
* Added TLS and SMTP port support for SharePoint 2016
* Fixed issue in SPWebApplication where the Get method didn't return Classic
  web applications properly
* Fixed issue in SPSubscriptionSettingsServiceApp not returning database values
* Updated Readme of SPInstall to include SharePoint Foundation is not supported
* Fixed issue with Access Denied in SPDesignerSettings
* Fixed missing brackets in error message in SPExcelServiceApp
* Removed the requirement for the ConfigWizard in SPInstallLanguagePack
* Fixed Language Pack detection issue in SPInstallLanguagePack
* Added support to set Windows service accounts for search related services to
  SPSearchServiceApp resource
* Fixed issue in SPCreateFarm and SPJoinFarm where an exception was not handled
  correctly
* Fixed issue in SPSessionStateService not returning correct database server
  and name
* Fixed missing Ensure property default in SPRemoteFarmTrust
* Fixed issue in SPWebAppGeneralSettings where -1 was returned for the TimeZone
* Fixed incorrect UsagePoint check in SPQuotaTemplate
* Fixed issue in SPWebAppPolicy module where verbose messages are causing errors
* Fixed incorrect parameter naming in Get method of SPUserProfilePropery
* Fixed issue in SPBlobCacheSettings when trying to declare same URL with
  different zone
* Improve documentation on SPProductUpdate to specify the need to unblock downloaded
  files
* Added check if file is blocked in SPProductUpdate to prevent endless wait
* Enhance SPUserProfileServiceApp to allow for NoILM to be enabled
* Fixed issue in SPUserProfileProperty where PropertyMapping was Null

## 1.7

* Update SPSearchIndexPartition made ServiceAppName as a Key
* New resouce: SPTrustedRootAuthority
* Update SPFarmSolution to eject from loop after 30m.
* New resource: SPMachineTranslationServiceApp
* New resource: SPPowerPointAutomationServiceApp
* Bugfix in SPSearchFileType  made ServiceAppName a key property.
* New resource: SPWebApplicationExtension
* Added new resource SPAccessServices2010
* Added MSFT_SPSearchCrawlMapping Resource to manage Crawl Mappings for
  Search Service Application
* Added new resource SPSearchAuthoritativePage
* Bugfix in SPWebAppThrottlingSettings for setting large list window time.
* Fix typo in method Get-TargetResource of SPFeature
* Fix bug in SPManagedAccount not returning the correct account name value
* Fix typo in method Get-TargetResource of SPSearchIndexPartition
* Update documentation of SPInstallLanguagePack to add guidance on package
  change in SP2016
* Added returning the required RunCentralAdmin parameter to
  Get-TargetResource in SPFarm
* Added web role check for SPBlobCacheSettings
* Improved error message when rule could not be found in
  SPHealthAnalyzerRuleState
* Extended the documentation to specify that the default value of Ensure
  is Present
* Added documentation about the user of Host Header Site Collections and
  the HostHeader parameter in SPWebApplication
* Fixed missing brackets in SPWebAppPolicy module file
* Fixed issue with SPSecureStoreServiceApp not returning database information
* Fixed issue with SPManagedMetadataServiceApp not returning ContentTypeHubUrl
  in SP2016
* Updated SPTrustedIdentityTokenIssuer to allow to specify the signing
  certificate from file path as an alternative to the certificate store
* New resource: SPSearchCrawlerImpactRule
* Fixed issue in SPSite where the used template wasn't returned properly
* Fixed issue in SPWebApplicationGeneralSettings which didn't return the
  security validation timeout properly
* Fixed bug in SPCreateFarm and SPJoinFarm when a SharePoint Server is already
  joined to a farm
* Bugfix in SPContentDatabase for setting WarningSiteCount as 0.
* Fixing verbose message that identifies SP2016 as 2013 in MSFT_SPFarm
* Fixed SPProductUpdate looking for OSearch15 in SP2016 when stopping services
* Added TermStoreAdministrators property to SPManagedMetadataServiceApp
* Fixed an issue in SPSearchTopology that would leave a corrupt topology in
  place if a server was removed and re-added to a farm
* Fixed bug in SPFarm that caused issues with database names that have dashes
  in the names

## 1.6

* Updated SPWebApplication to allow Claims Authentication configuration
* Updated documentation in regards to guidance on installing binaries from
  network locations instead of locally
* New resources: SPFarmPropertyBag
* Bugfix in SPSite, which wasn't returing the quota template name in a correct way
* Bugfix in SPAppManagementServiceApp which wasn't returning the correct database
  name
* Bugfix in SPAccessServiceApp which did not return the database server
* Bugfix in SPDesignerSettings which filtered site collections with an incorrect
  parameter
* Updated the parameters in SPFarmSolution to use the full namespace
* Bugfix in SPFarmsolution where it returned non declared parameters
* Corrected typo in parameter name in Get method of SPFeature
* Added check in SPHealAnalyzerRuleState for incorrect default rule schedule of
  one rule
* Improved check for CloudSSA in SPSearchServiceApp
* Bugfix in SPSearchServiceApp in which the database and dbserver were not
  returned correctly
* Improved runtime of SPSearchTopology by streamlining wait processes
* Fixed bug with SPSearchServiceApp that would throw an error about SDDL string
* Improved output of test results for AppVeyor and VS Code based test runs
* Fixed issue with SPWebAppPolicy if OS language is not En-Us
* Added SPFarm resource, set SPCreateFarm and SPJoinFarm as deprecated to be
  removed in version 2.0

## 1.5

* Fixed issue with SPManagedMetaDataServiceApp if ContentTypeHubUrl parameter is
  null
* Added minimum PowerShell version to module manifest
* Added testing for valid markdown syntax to unit tests
* Added support for MinRole enhancements added in SP2016 Feature Pack 1
* Fixed bug with search topology that caused issues with names of servers needing
  to all be the same case
* Fixed bug in SPInstallLanguagePack where language packs could not be installed
  on SharePoint 2016
* Added new resource SPSearchFileType
* Updated SPDatabaseAAG to allow database name patterns
* Fixed a bug were PerformancePoint and Excel Services Service Application
  proxies would not be added to the default proxy group when they are
  provisioned
* Added an error catch to provide more detail about running SPAppCatalog with
  accounts other than the farm account

## 1.4

* Set-TargetResource of Service Application now also removes all associated
  proxies
* Fixed issue with all SPServiceApplication for OS not in En-Us language,
  add GetType().FullName method in:
  * SPAccessServiceApp
  * SPAppManagementServiceApp
  * SPBCSServiceApp
  * SPExcelServiceApp
  * SPManagedMetaDataServiceApp
  * SPPerformancePointServiceApp
  * SPSearchServiceApp
  * SPSearchCrawlRule
  * SPSecureStoreServiceApp
  * SPSubscriptionSettingsServiceApp
  * SPUsageApplication
  * SPUserProfileServiceApp
  * SPVisioServiceApp
  * SPWordAutomationServiceApp
  * SPWorkManagementServiceApp
* Fixed issue with SPServiceInstance for OS not in En-Us language, add
  GetType().Name method in:
  * SPDistributedCacheService
  * SPUserProfileSyncService
* Fixed issue with SPInstallLanguagePack to install before farm creation
* Fixed issue with mounting SPContentDatabase
* Fixed issue with SPShellAdmin and Content Database method
* Fixed issue with SPServiceInstance (Set-TargetResource) for OS not in
  En-Us language
* Added .Net 4.6 support check to SPInstall and SPInstallPrereqs
* Improved code styling
* SPVisioServiceapplication now creates proxy and lets you specify a name for
  it
* New resources: SPAppStoreSettings
* Fixed bug with SPInstallPrereqs to allow minor version changes to prereqs for
  SP2016
* Refactored unit tests to consolidate and streamline test approaches
* Updated SPExcelServiceApp resource to add support for trusted file locations
  and most other properties of the service app
* Added support to SPMetadataServiceApp to allow changing content type hub URL
  on existing service apps
* Fixed a bug that would cause SPSearchResultSource to throw exceptions when
  the enterprise search centre URL has not been set
* Updated documentation of SPProductUpdate to reflect the required install
  order of product updates

## 1.3

* Fixed typo on return value in SPServiceAppProxyGroup
* Fixed SPJoinFarm to not write output during successful farm join
* Fixed issue with SPSearchTopology to keep array of strings in the hashtable
  returned by Get-Target
* Fixed issue with SPSearchTopology that prevented topology from updating where
  ServerName was not returned on each component
* Added ProxyName parameter to all service application resources
* Changed SPServiceInstance to look for object type names instead of the display
  name to ensure consistency with language packs
* Fixed typos in documentation for InstallAccount parameter on most resources
* Fixed a bug where SPQuotaTemplate would not allow warning and limit values to
  be equal
* New resources: SPConfigWizard, SPProductUpdate and SPPublishServiceApplication
* Updated style of all script in module to align with PowerShell team standards
* Changed parameter ClaimsMappings in SPTrustedIdentityTokenIssuer to consume an
  array of custom object MSFT_SPClaimTypeMapping
* Changed SPTrustedIdentityTokenIssuer to throw an exception if certificate
  specified has a private key, since SharePoint doesn't accept it
* Fixed issue with SPTrustedIdentityTokenIssuer to stop if cmdlet
  New-SPTrustedIdentityTokenIssuer returns null
* Fixed issue with SPTrustedIdentityTokenIssuer to correctly get parameters
  ClaimProviderName and ProviderSignOutUri
* Fixed issue with SPTrustedIdentityTokenIssuer to effectively remove the
  SPTrustedAuthenticationProvider from all zones before deleting the
  SPTrustedIdentityTokenIssuer

## 1.2

* Fixed bugs SPWebAppPolicy and SPServiceApPSecurity that prevented the get
  methods from returning AD group names presented as claims tokens
* Minor tweaks to the PowerShell module manifest
* Modified all resources to ensure $null values are on the left of
  comparisson operations
* Added RunOnlyWhenWriteable property to SPUserProfileSyncService resource
* Added better logging to all test method output to make it clear what property
  is causing a test to fail
* Added support for NetBIOS domain names resolution to SPUserProfileServiceApp
* Removed chocolatey from the AppVeyor build process in favour of the
  PowerShell Gallery build of Pester
* Fixed the use of plural nouns in cmdlet names within the module
* Fixed a bug in SPContentDatabase that caused it to not function correctly.
* Fixed the use of plural nouns in cmdlet names within the module
* Removed dependency on Win32_Product from SPInstall
* Added SPTrustedIdentityTokenIssuer, SPRemoteFarmTrust and
  SPSearchResultSource resources
* Added HostHeader parameter in examples for Web Application, so subsequent web
  applications won't error out
* Prevented SPCreateFarm and SPJoinFarm from executing set methods where the
  local server is already a member of a farm

## 1.1

* Added SPBlobCacheSettings, SPOfficeOnlineServerBinding, SPWebAppPermissions,
  SPServiceAppProxyGroup, SPWebAppProxyGroup and
  SPUserProfileServiceAppPermissions resources
* SPUserProfileSyncService Remove Status field from Get-TargResource: not in
  MOF, redundant with Ensure
* Improvement with SPInstallPrereqs on SPS2013 to accept 2008 R2 or 2012 SQL
  native client not only 2008 R2
* Fixed a bug with SPTimerJobState that prevented a custom schedule being
  applied to a timer job
* Fixed a bug with the detection of group principals vs. user principals in
  SPServiceAppSecurity and SPWebAppPolicy
* Removed redundant value for KB2898850 from SPInstallPrereqs, also fixed old
  property name for DotNetFX
* Fixed a bug with SPAlternateUrl that prevented the test method from returning
  "true" when a URL was absent if the optional URL property was specified in
  the config
* Fixed bugs in SPAccessServiceApp and SPPerformancePointServiceApp with type
  names not being identified correctly
* Added support for custom database name and server to
  SPPerformancePointServiceApp
* Added solution level property to SPFarmSolution
* Fixed a bug with SPSearchServiceApp that prevents the default crawl account
  from being managed after it is initially set
* Removed dependency on Win32_Prouct from SPInstallPrereqs

## 1.0

* Renamed module from xSharePoint to SharePointDsc
* Fixed bug in managed account schedule get method
* Fixed incorrect output of server name in xSPOutgoingEmailSettings
* Added ensure properties to multiple resources to standardise schemas
* Added xSPSearchContentSource, xSPContentDatabase, xSPServiceAppSecurity,
  xSPAccessServiceApp, xSPExcelServiceApp, xSPPerformancePointServiceApp,
  xSPIrmSettings resources
* Fixed a bug in xSPInstallPrereqs that would cause an updated version of AD
  rights management to fail the test method for SharePoint 2013
* Fixed bug in xSPFarmAdministrators where testing for users was case sensitive
* Fixed a bug with reboot detection in xSPInstallPrereqs
* Added SearchCenterUrl property to xSPSearchServiceApp
* Fixed a bug in xSPAlternateUrl to account for a default zone URL being
  changed
* Added content type hub URL option to xSPManagedMetadataServiceApp for when
  it provisions a service app
* Updated xSPWebAppPolicy to allow addition and removal of accounts, including
  the Cache Accounts, to the web application policy.
* Fixed bug with claims accounts not being added to web app policy in
  xSPCacheAccounts
* Added option to not apply cache accounts policy to the web app in
  xSPCacheAccounts
* Farm Passphrase now uses a PSCredential object, in order to pass the value
  as a securestring on xSPCreateFarm and xSPJoinFarm
* xSPCreateFarm supports specifying Kerberos authentication for the Central
  Admin site with the CentralAdministrationAuth property
* Fixed nuget package format for development feed from AppVeyor
* Fixed bug with get output of xSPUSageApplication
* Added SXSpath parameter to xSPInstallPrereqs for installing Windows features
  in offline environments
* Added additional parameters to xSPWebAppGeneralSettings for use in hardened
  environments
* Added timestamps to verbose logging for resources that pause for responses
  from SharePoint
* Added options to customise the installation directories used when installing
  SharePoint with xSPInstall
* Aligned testing to common DSC resource test module
* Fixed bug in the xSPWebApplication which prevented a web application from
  being created in an existing application pool
* Updated xSPInstallPrereqs to align with SharePoint 2016 RTM changes
* Added support for cloud search index to xSPSearchServiceApp
* Fixed bug in xSPWebAppGeneralSettings that prevented setting a security
  validation timeout value

## 0.12.0.0

* Removed Visual Studio project files, added VSCode PowerShell extensions
  launch file
* Added xSPDatabaseAAG, xSPFarmSolution and xSPAlternateUrl resources
* Fixed bug with xSPWorkManagementServiceApp schema
* Added support to xSPSearchServiceApp to configure the default content
  access account
* Added support for SSL web apps to xSPWebApplication
* Added support for xSPDistributedCacheService to allow provisioning across
  multiple servers in a specific sequence
* Added version as optional parameter for the xSPFeature resource to allow
  upgrading features to a specific version
* Fixed a bug with xSPUserProfileSyncConnection to ensure it gets the
  correct context
* Added MOF descriptions to all resources to improve editing experience
  in PowerShell ISE
* Added a check to warn about issue when installing SharePoint 2013 on a
  server with .NET 4.6 installed
* Updated examples to include installation resources
* Fixed issues with kerberos and anonymous access in xSPWebApplication
* Add support for SharePoint 2016 on Windows Server 2016 Technical Preview
  to xSPInstallPrereqs
* Fixed bug for provisioning of proxy for Usage app in xSPUsageApplication

## 0.10.0.0

* Added xSPWordAutomationServiceApp, xSPHealthAnalyzerRuleState,
  xSPUserProfileProperty, xSPWorkManagementApp, xSPUserProfileSyncConnection
  and xSPShellAdmin resources
* Fixed issue with MinRole support in xSPJoinFarm

## 0.9.0.0

* Added xSPAppCatalog, xSPAppDomain, xSPWebApplicationAppDomain,
  xSPSessionStateService, xSPDesignerSettings, xSPQuotaTemplate,
  xSPWebAppSiteUseAndDeletion, xSPSearchTopology, xSPSearchIndexPartition,
  xSPWebAppPolicy and xSPTimerJobState resources
* Fixed issue with wrong parameters in use for SP2016 beta 2 prerequisite
  installer

## 0.8.0.0

* Added xSPAntivirusSettings, xSPFarmAdministrators, xSPOutgoingEmailSettings,
  xSPPasswordChangeSettings, xSPWebAppBlockedFileTypes,
  xSPWebAppGeneralSettings, xSPWebAppThrottlingSettings and
  xSPWebAppWorkflowSettings
* Fixed issue with xSPInstallPrereqs using wrong parameters in offline install
  mode
* Fixed issue with xSPInstallPrereqs where it would not validate that installer
  paths exist
* Fixed xSPSecureStoreServiceApp and xSPUsageApplication to use PSCredentials
  instead of plain text username/password for database credentials
* Added built in PowerShell help (for calling "Get-Help about_[resource]",
  such as "Get-Help about_xSPCreateFarm")

## 0.7.0.0

* Support for MinRole options in SharePoint 2016
* Fix to distributed cache deployment of more than one server
* Additional bug fixes and stability improvements

## 0.6.0.0

* Added support for PsDscRunAsCredential in PowerShell 5 resource use
* Removed timeout loop in xSPJoinFarm in favour of WaitForAll resource in
  PowerShell 5

## 0.5.0.0

* Fixed bug with detection of version in create farm
* Minor fixes
* Added support for SharePoint 2016 installation
* xSPCreateFarm: Added CentraladministrationPort parameter
* Fixed issue with PowerShell session timeouts

## 0.4.0

* Fixed issue with nested modules cmdlets not being found

## 0.3.0

* Fixed issue with detection of Identity Extensions in xSPInstallPrereqs
  resource
* Changes to comply with PSScriptAnalyzer rules

## 0.2.0

* Initial public release of xSharePoint
