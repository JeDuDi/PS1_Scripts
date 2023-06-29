$guid = "b5d27fa9-d24a-4bf7-ad3c-5991ce9aa3d3"   
$base64 = [system.convert]::ToBase64String(([GUID]$guid).ToByteArray())
Write-Output($base64)


Connect-MsolService

Get-MsolUser -ObjectID b5d27fa9-d24a-4bf7-ad3c-5991ce9aa3d3 | Format-List

Set-MsolUser -UserPrincipalName dschendel@villagemissions.org -ImmutableId null

Get-MsolUser -ReturnDeletedUsers


Get-MsolUser -UserPrincipalName rhayes@VillageMissions.onmicrosoft.com | Format-List


Set-MsolUser -UserPrincipalName dschendel@villagemissions.org -ImmutableId Up1Z3Fkm3kGauZyCddRh7Q==

Set-MsolUser -UserPrincipalName rhayes@villagemissions.org -ImmutableId 7408q4W6jUCTR4N6iE/ilA==

Set-MsolUser -UserPrincipalName VKeller@villagemissions.org -ImmutableId ZsFw9cjj0kONLdHokFKygA==

Get-MsolUser -UserPrincipalName support@timemarkinc.com -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin -Force
Get-MsolUser -UserPrincipalName dschendel4050@VillageMissions.onmicrosoft.com -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin -Force
Get-MsolUser -UserPrincipalName MaWright@familybuildingblocks.org -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin -Force
