<#

    .PURPOSE
        This script queries a root folder you specify for child items with inheritance disabled and appends the ACL with an account you specify to each child item.
    
    .NOTES
        Created by JeDuDi

#>

#Define root path for testing all child items. We are looking for child items without inheritance.
$dirs = dir "E:\S_SALES" -Directory -recurse | get-acl | Where {$_.AreAccessRulesProtected} | Select @{Name="Path";Expression={Convert-Path $_.Path}}

#Define the entity that will be appended access on the ACL
$AccessRule = "D\_Executive:(OI)(CI)F"

#Loop through each child item without inheritance in the root path
foreach ($dir in $dirs) {

#Output existing ACL for path
Write-Host "Original ACL for " $dir.Path `r`n -ForegroundColor red
(Get-ACL -Path $dir.Path).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

#Append new entry with ICACLS
icacls.exe $dir.Path /grant $accessRule

#Output new ACL for path
Write-Host `r`n"New ACL for " $dir.Path -ForegroundColor Green
(Get-ACL -Path $dir.Path).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

}