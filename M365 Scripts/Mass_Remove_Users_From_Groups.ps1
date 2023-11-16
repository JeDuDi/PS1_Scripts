<#

    .PURPOSE
        The purpose of the script is to remove all groups from the users contained in your supplied CSV file.
    .NOTES
        Modified from sharepointdiary.com by JeDuDi

#>
  
#Connect to AzureAD
Connect-AzureAD
Connect-ExchangeOnline
   
#Get all Azure AD Unified Groups
$AADGroups = Get-AzureADMSGroup -Filter "groupTypes/any(c:c eq 'Unified')" -All:$true

#Get all Exchange distribution groups
$DistGroups = Get-DistributionGroup
 
#Iterate through each line in CSV
Import-CSV -Path "C:\temp\Users-export-testbatch.csv" | ForEach-Object {

    #Assign variables from the CSV file, these are mapped based off of column headers in the CSV file
    $upn = $_.upn

    #Output the current UPN to the terminal
    $upn
     
    #Get the Azure AD User based on the current UPN
    $AADUser  = Get-AzureADUser -Filter "UserPrincipalName eq '$upn'"
 
    #Check each Azure AD group for the user
    ForEach ($AzureGroup in $AADGroups)
    {
        try{
            $AzureGroupMembers = (Get-AzureADGroupMember -ObjectId $AzureGroup.id).UserPrincipalName
            If ($AzureGroupMembers -contains $upn)
            {
                #Remove user from Group
                Remove-AzureADGroupMember -ObjectId $AzureGroup.Id -MemberId $AADUser.ObjectId
                Write-Host ($upn + " successfully removed from " + $($AzureGroup.DisplayName)) -BackgroundColor Black -ForegroundColor Green
            }
        }
        catch{
            Write-Host ("Failed to remove " + $upn + " from " + $($AzureGroup.DisplayName) + " - Skipping to next entry") -BackgroundColor Black -ForegroundColor Red
        }
    }

    #Check each Distrubtion group for the user
    ForEach ($DistGroup in $DistGroups)
    {
        try{
            $DistGroupMembers = (Get-DistributionGroupMember -Identity $DistGroup.id).Name
            If ($DistGroupMembers -contains $upn)
            {
                #Remove user from Group
                Remove-DistributionGroupMember -Identity $DistGroup.Id -Member $upn -Confirm:$false
                Write-Host ($upn + " successfully removed from " + $($DistGroup.DisplayName)) -BackgroundColor Black -ForegroundColor Green
            }
        }
        catch{
            Write-Host ("Failed to remove " + $upn + " from " + $($DistGroup.DisplayName) + " - Skipping to next entry") -BackgroundColor Black -ForegroundColor Red
        }
    }
}