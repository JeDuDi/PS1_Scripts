<#

    .PURPOSE
        The purpose of the script is to update the Read and Manage permissions for a list of mailboxes contained in a CSV file that you supply.
        The script will add the selected users below to the list of mailboxes and will not automatically map these mailboxes to Outlook.
        This will allow the selected users to open all of the mailboxes through OWA as required.
    .NOTES
        Created: 7/12/23 by JD

#>

#Connect to Exchange Online
Connect-ExchangeOnline

#Assign variables for delegated users to be used in the loop, these users will get full mailbox permissions to those mailboxes in the CSV file
$usr1 = "David@haugenrv.com"
$usr2 = "corbin@legacyrvcenter.com"
$usr3 = "Amy@legacyrvcenter.com"

#Loop through each entry in the targeted CSV file
Import-CSV -Path "C:\temp\HRV_MO-Users-export.csv" | Foreach-Object {

    #Assign variables from the CSV file, these are mapped based off of column headers in the CSV file
    $upn = $_.upn

    #Output the current UPN to the terminal
    $upn

    #Add permissions to the current mailbox in the loop and do not automatically map to Outlook
    try {
        Add-MailboxPermission -Identity $upn -User $usr1 -AccessRights FullAccess -InheritanceType All -AutoMapping $false
        Add-MailboxPermission -Identity $upn -User $usr2 -AccessRights FullAccess -InheritanceType All -AutoMapping $false
        Add-MailboxPermission -Identity $upn -User $usr3 -AccessRights FullAccess -InheritanceType All -AutoMapping $false
        Write-Host ("Successfully updated permissions for " + $upn) -BackgroundColor Black -ForegroundColor Green
    }
    catch {
        Write-Host ("Failed to update permissions for " + $upn + " - Skipping to next entry.") -BackgroundColor Black -ForegroundColor Red
    }

}