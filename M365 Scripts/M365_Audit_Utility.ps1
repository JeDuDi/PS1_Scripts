<#

    .PURPOSE
        A collection of commands used to gather DLP and Trnasport Rule information from M36.
    .NOTES
        Created by JeDuDi

#>

#Connect to Services
Connect-AzureAD

Connect-AipService

Connect-ExchangeOnline

Connect-IPPSsession

Connect-MsolService

#Get current status of Azure Information Protection Service
Get-AipService

#Get list of DLP policies
Get-DlpCompliancePolicy

#Get list of mailflow rules
Get-TransportRule

#Get Outlook external sender warning status
Get-ExternalInOutlook

#Review all SKUs in tenant
Get-MsolAccountSku

#Get total number of licensed users
(Get-MsolUser -All | Where { $_.isLicensed -eq $true }).count

#Get total number of licensed users with CA available license
(Get-MsolUser -All | Where { $_.Licenses.AccountSkuId -like "*SPE_E3*" }).count

Get-MsolUser | Where { $_.DisplayName -eq "Client Name" } | Format-List

#Disconnect from all services
Disconnect-AipService
Disconnect-ExchangeOnline
Disconnect-AzureAD