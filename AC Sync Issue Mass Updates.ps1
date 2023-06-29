Connect-MsolService
Connect-ExchangeOnline

Import-CSV -Path "C:\temp\AC-NoSync-Users-Likely-Terminated.csv" | Foreach-Object {

# properties from the csv
$upn = $_.upn
#$name = Get-MsolUser -UserPrincipalName $upn | Select -ExpandProperty DisplayName

$upn
#$name
 
#Set-MsolUser -UserPrincipalName $upn -DisplayName ("x - " + $name) -BlockCredential $True -ImmutableID $null

#Set-Mailbox $upn -HiddenFromAddressListsEnabled $true

#temp line to set ImmutId only
Set-MsolUser -UserPrincipalName $upn -ImmutableID ""


}