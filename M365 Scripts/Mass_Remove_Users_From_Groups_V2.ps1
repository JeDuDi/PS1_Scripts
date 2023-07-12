<#

    .PURPOSE
        The purpose of the script is to remove all groups from the users contained in your supplied CSV file.
    .NOTES
        Requires Remove_User_All_GroupsV2.ps1 to be in the same directory
        https://github.com/michevnew/PowerShell/blob/master/Remove_User_All_GroupsV2.ps1

#>

#Iterate through each line in CSV
Import-CSV -Path "C:\temp\HRV_MO-Users-export-testbatch.csv" | ForEach-Object {

    #Assign variables from the CSV file, these are mapped based off of column headers in the CSV file
    $upn = $_.upn

    #Output the current UPN to the terminal
    $upn
         
    #Assign variables from the CSV file, these are mapped based off of column headers in the CSV file
    .\Remove_User_All_GroupsV2.ps1 -Identity $upn -WhatIf -IncludeAADSecurityGroups -IncludeOffice365Groups


}