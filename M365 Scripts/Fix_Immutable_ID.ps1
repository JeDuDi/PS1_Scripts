Connect-MsolService

$var = (Get-MsolUser -UserPrincipalName "Dan.Canfield@andrews-cooper.com").ImmutableID

Write-Host($var)

Set-MsolUser -UserPrincipalName "Dan.Canfield@andrews-cooper.com" -ImmutableID "EQHDJsAWg0CXIlDBdKpvMg=="

Get-MsolUser -UserPrincipalName "Dan.Canfield@andrews-cooper.com" | Format-List

#Steve - Mac
#vJMrSv90pUiadth81TG6bw==

#ACarcia - LO
#UyxxTQalsUaCC2TFBQeNdA==

#Sami - Corp
#CNoGhP9KBkKWVF7EO48ktQ==

#act.local/Andrews-Cooper Corporate/Users/Staff/Barbara Duong
#PJJOC1jOlkyk1FiV96Qo1w==

#act.local/Andrews-Cooper Corporate/Users/Staff/Shawn Daniel
#+O/m/YsWvEeyJJRqIdX6jQ==

#act.local/Andrews-Cooper Lake Oswego/Users/Staff/Tyler Kenney
#avQixJQJt0yPrqxkoRzRnA==



#Dan
#EQHDJsAWg0CXIlDBdKpvMg==

#Was Xtreme
#WHcqKmFFoEebBM85VcRIig==


$hexstring = "11 01 C3 26 C0 16 83 40 97 22 50 C1 74 AA 6F 32"     # <- set your own Hex string here
$base64 = [system.convert]::ToBase64String([byte[]] (-split (($hexstring -replace " ", "") -replace '..', '0x$& ')))
$base64

$hexstring = "11 01 C3 26 C0 16 83 40 97 22 50 C1 74 AA 6F 32"     # <- set your own Hex string here
$guid = [GUID]([byte[]] (-split (($hexstring -replace " ", "") -replace '..', '0x$& ')))
$guid



Connect-AzureAD

$usr = Get-AzureADUser -ObjectID "teamlogicit@andrews-cooper.com"

$usr.DisplayName

$usr.MailNickName = ""
$usr.OnPremisesSecurityIdentifier = ""

Get-AzureADUser -ObjectId "dan.canfield@andrews-cooper.com"


Get-AzureADObjectByObjectId -ObjectIds 8b2820c1-fbce-4cc3-819b-d5c8cba996be




#774857ce-c9d5-47dc-b033-b02fe352312d
#b3ba2b4d-5298-4efe-87a2-39647c7d2d9c
#8b2820c1-fbce-4cc3-819b-d5c8cba996be
#05a83803-fa0b-4599-953b-24ea9e81adc5
#0801e996-befb-4afb-8357-4b9297762692
#55bbb6ac-ab37-464d-8d9b-85081bc391c7

Get-AzureADUser -ObjectId e008687c-ba87-4497-9bc2-9593edca634e | Format-List

Set-MsolUser -UserPrincipalName "aaron.chritton@andrews-cooper.com" -ImmutableID ""

 S-1-5-21-3143605458-3659537772-2962101204-1154
