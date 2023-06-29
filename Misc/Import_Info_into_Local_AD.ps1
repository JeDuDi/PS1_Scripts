Import-Module ActiveDirectory  
Import-CSV -Path "C:\import.csv" | Foreach-Object {

# properties from the csv
$mail = $_.email
$title = $_.jobtitle
$office = $_.office
$department = $_.department
$mobile = $_.mobile
$telephone = $_.phone
$streetAddress = $_.address
$city = $_.city
$state = $_.state
$zip = $_.zip
$country = $_.country

If ([string]::IsNullOrEmpty($title)) {
    $title = $null
}

If ([string]::IsNullOrEmpty($office)) {
    $office = $null
}

If ([string]::IsNullOrEmpty($department)) {
    $department = $null
}

If ([string]::IsNullOrEmpty($mobile)) {
    $mobile = $null
}

If ([string]::IsNullOrEmpty($telephone)) {
    $telephone = $null
}

If ([string]::IsNullOrEmpty($streetAddress)) {
    $streetAddress = $null
}

If ([string]::IsNullOrEmpty($city)) {
    $city = $null
}

If ([string]::IsNullOrEmpty($state)) {
    $state = $null
}

If ([string]::IsNullOrEmpty($zip)) {
    $zip = $null
}

If ([string]::IsNullOrEmpty($country)) {
    $country = $null
}

$mail
$title
$office
$department
$mobile
$telephone
$streetAddress
$city
$state
$zip
$country
 
Get-ADUser -Filter "mail -eq '$mail'" -Properties * | Set-ADUser -Title $title -Office $office -Department $department -MobilePhone $mobile -OfficePhone $telephone -StreetAddress $streetAddress -City $city -State $state -PostalCode $zip -Country $country
}