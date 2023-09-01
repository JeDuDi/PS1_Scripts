<#

    .PURPOSE
        The purpose of the script is to audit and update the ImmutableID field in M365 to fix duplicated account sync issues.
    .NOTES
        You will need the MSOL PowerShell module installed to run these commands.
        Be careful not to lose the ObjectID and ImmutableID data during your audit as these cannot be recovered after deletion.

#>

#Connect to the necessary service for this script
Connect-MsolService

#Get the ImmutableID for both accounts of the duplicated user

#Log the Cloud-only Immutable ID (probably blank): EQHDJsAWg0CXIlDBdKpvMg==
(Get-MsolUser -UserPrincipalName "clouduser@domain.com").ImmutableID

#Log the ADSynced Account Immutable ID (to be assigned to the cloud-only account in another step): EQHDJsAWg0CXIlDBdKpvMg==
(Get-MsolUser -UserPrincipalName "synceduser@domain.com").ImmutableID

<#

    Now that you have the Immutable IDs logged for future use, it's time to move the local AD account into an OU that doesn't sync with AzureAD. Usually a Disabled Users OU.
    Run a Delta Sync on the AD server. Give it about 30 seconds to complete.
    Now check the deleted users in Azure AD. You should see the duplicate account of the ADSynced user in the Deleted Users menu.
    Granted this account is unlicensed with no data, permanently delete this account in Azure AD. Give it about 30 seconds and refresh the page.
    Once the duplicate account is no longer showing in Azure AD, proceed to the next step.

#>

#Now you will take the ImmutableID from the recently deleted ADSynced account and assign it to the cloud-only account
Set-MsolUser -UserPrincipalName "clouduser@domain.com" -ImmutableID "EQHDJsAWg0CXIlDBdKpvMg=="

#Conversion tool for Hex, Base64, and GUID needed in rare cases
$hexstring = "11 01 C3 26 C0 16 83 40 97 22 50 C1 74 AA 6F 32"     # <- set your own Hex string here
$base64 = [system.convert]::ToBase64String([byte[]] (-split (($hexstring -replace " ", "") -replace '..', '0x$& ')))
$base64

$hexstring = "11 01 C3 26 C0 16 83 40 97 22 50 C1 74 AA 6F 32"     # <- set your own Hex string here
$guid = [GUID]([byte[]] (-split (($hexstring -replace " ", "") -replace '..', '0x$& ')))
$guid