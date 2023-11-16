<#

    .PURPOSE
        The purpose of the script is to configure Azure RMS on an M365 tenant for use with DLP and other functions.
    .NOTES
        Created by JeDuDi

#>

#Connect to Azure Information Protection Service
Connect-AipService

#Get current status of Azure Information Protection Service
Get-AipService

#Enable the Azure Information Protection Service
Enable-AipService

#Connect to Exchange Online
Connect-ExchangeOnline

#Get Rights Management Configuration
Get-IRMConfiguration

#Set the Licensing Location for RMS
$RMSConfig = Get-AipServiceConfiguration
$LicenseUri = $RMSConfig.LicensingIntranetDistributionPointUrl
Set-IRMConfiguration -LicensingLocation $LicenseUri
Set-IRMConfiguration -InternalLicensingEnabled $true
#Enable Azure Rights Management
Set-IRMConfiguration -AzureRMSLicensingEnabled $True
#Allow Outlook/OWA to show Encrypt button
Set-IRMConfiguration -SimplifiedClientAccessEnabled $true

#Test the IRM Config for pass/fail conditions - update with valid email to and from
Test-IRMConfiguration -Sender name@domain.com  -Recipient name@domain.com

