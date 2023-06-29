# This must match a NinjaRMM API App created for this script
$client_id = "AF6f2wNNnfcP1ZjhVu9v_tyjwKg"
$client_secret = "qh7OV1j8uavE9UNQ_2xTxsP77UuI5AKeldONw4Kun9yzyp9QE3j7Sg"
$redirect_uri = "http://localhost:8888/"
$scope = "monitoring management offline_access"
$auth_url = "https://app.ninjarmm.com/ws/oauth/authorize"

# Add Type System.Web if not already added
Try {
    [System.Web.HttpUtility]$HttpUtilityTest
    }
Catch {
    Add-Type -AssemblyName System.Web
    }


Write-Host "Starting HTTP server to listen for callback to $redirect_uri ..."
$httpServer = [System.Net.HttpListener]::new()
$httpServer.Prefixes.Add($redirect_uri)
$httpServer.Start()

Write-Host "Launching NinjaRMM API OAuth authorization page $auth_url ..."
$auth_redirect_url = $auth_url + "?response_type=code&client_id=" + $client_id + "&redirect_uri=" + $redirect_uri + "&state=custom_state&scope=monitoring%20management%20offline_access"
Start-Process $auth_redirect_url

Write-Host "Listening for authorization code from local callback to $redirect_uri ..."
while ($httpServer.IsListening) {
  $httpContext = $httpServer.GetContext()
  $httpRequest = $httpContext.Request
  $httpResponse = $httpContext.Response
  $httpRequestURL = [uri]($httpRequest.Url)
  if ($httpRequest.IsLocal) {
    Write-Host "Heard local request to $httpRequestURL ..."
    $httpRequestQuery = [System.Web.HttpUtility]::ParseQueryString($httpRequestURL.Query)
    if (-not [string]::IsNullOrEmpty($httpRequestQuery['code'])) {
      $authorization_code = $httpRequestQuery['code']
      $httpResponse.StatusCode = 200
      [string]$httpResponseContent = "<html><body>Authorized! You may now close this browser tab/window.</body></html>"
      $httpResponseBuffer = [System.Text.Encoding]::UTF8.GetBytes($httpResponseContent)
      $httpResponse.ContentLength64 = $httpResponseBuffer.Length
      $httpResponse.OutputStream.Write($httpResponseBuffer, 0, $httpResponse.ContentLength64)
    } else {
      Write-Host "HTTP 400ing local request (missing code parameter in URL query string) ..."
      $httpResponse.StatusCode = 400
    }
  } else {
    Write-Host "HTTP 403ing remote request to $httpRequestURL ..."
    $httpResponse.StatusCode = 403
  }
  $httpResponse.Close()
  if (-not [string]::IsNullOrEmpty($authorization_code)) { $httpServer.Stop() }
}
Write-Host "Parsed authorization code $authorization_code ..."

$API_AuthHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$API_AuthHeaders.Add("accept", 'application/json')
$API_AuthHeaders.Add("Content-Type", 'application/x-www-form-urlencoded')
$body = @{
  grant_type = "authorization_code"
  client_id = $client_id
  client_secret = $client_secret
  redirect_uri = $redirect_uri
  scope = $scope
  code = $authorization_code
}
$auth_token = Invoke-RestMethod -Uri https://app.ninjarmm.com/ws/oauth/token -Method POST -Headers $API_AuthHeaders -Body $body
$access_token = $auth_token | Select-Object -ExpandProperty 'access_token' -EA 0
Write-Host "Got access token $access_token ..."

# Defining the headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("accept", 'application/json')
$headers.Add("Authorization", "Bearer $access_token")

# 1. Import CSV file. Should contain two columns, with headers entitled "location" and "organization"
$filepath = "C:\Users\Jesse Dickens\OneDrive - TeamLogic IT\NinjaImport.csv"

$locationsCSV = Import-CSV -Path $filepath

#This creates a Powershell object with the two pieces of information we have, plus placeholders for two pieces of data that we need to retrieve from the API
$assets = Foreach ($key in $locationsCSV) {
  [PSCustomObject]@{
      LocName = $key.location
      OrgName = $key.organization
      LocID = 0
      OrgID = 0
  }
  }

# 2. Correlate org names to org IDs

  $organizations_url = "https://app.ninjarmm.com/v2/organizations"
  $organizations = Invoke-RestMethod -Uri $organizations_url -Method GET -Headers $headers
#looks at list of every org in Ninja and pulls the unique ID for that org into the PS object we created above. This will help with identifying locations that already exist in Ninja so they don't get created multiple times.
  foreach ($organization in $organizations) {
    $currentDev = $assets | Where {$_.OrgName -eq $organization.name}
$currentDev | Add-Member -MemberType NoteProperty -Name 'OrgID' -Value $organization.id -Force
}

# 3. Check for duplicate locations

#Retrive info on locations from Ninja API
$locationsbyorg_url = "https://app.ninjarmm.com/v2/locations"
$locations = Invoke-RestMethod -Uri $locationsbyorg_url -Method GET -Headers $headers


$groupedData = $assets | Group-Object -Property "OrgName" | ForEach-Object {
  $_.Group | Select-Object -First 1
}

# Create an empty array to store the selected locations
$selectedLocations = @()

# Loop through the grouped data and add the selected location for each company to the array
foreach ($group in $groupedData) {
  $selectedLocation = [pscustomobject]@{
      "Company Name" = $group."OrgName"
      "Location Name" = $group."LocName"
      "Company ID" = $group."OrgID"
      "Location ID" = $group."LocID"
  }
  $selectedLocations += $selectedLocation
}

#now that we have a location from each organization that can use to overwrite the default generic location, we need to identify where that location exists.

foreach ($location in $locations){
  $currentOrg = $selectedLocations | Where-Object {$_."Company ID" -eq $location.organizationId}
  if ($location.name -eq "Main Office"){
$currentOrg | Add-Member -MemberType NoteProperty -Name "Location ID" -Value $location.id -Force
  }
}

# Output the selected locations
$selectedLocations

#make the API call for each asset where there is a location ID. Update the Main Office location where it exists with a location. The next function checks for duplicates so there will not be a dupicate location created.

foreach ($selectedLocation in $selectedLocations){
  if ($selectedLocation."Location ID" -gt 0) {

    $locationsupdate_url = "https://app.ninjarmm.com/api/v2/organization/" + $selectedLocation."Company ID" + "/locations/" + $selectedLocation."Location ID"

  # define request body
  $request_body = @{
    name = $selectedLocation."Location Name"
  }

  # convert body to JSON
  $json = $request_body | ConvertTo-Json

  Write-Host "Creating location: $($selectedLocation."Location Name") in $($selectedLocation."Company Name")"

  # Let's make the magic happen
  Invoke-RestMethod -Method 'Patch' -Uri $locationsupdate_url -Headers $headers -Body $json -ContentType "application/json" -Verbose


Write-Host "Done!"
}
}

#update locations endpoint to reflect the fact that Main Office has been updated
$locations = Invoke-RestMethod -Uri $locationsbyorg_url -Method GET -Headers $headers

# 4. Second API call to import the rest of the locations. First we find instances where a location name in our CSV already exists under the specified organization.
foreach ($asset in $assets) {
  $currentLocID = $locations | Where-Object {$_.name -eq $asset.LocName -and $_.organizationId -eq $asset.OrgID} | Select-Object -ExpandProperty id
    $asset | Add-Member -MemberType NoteProperty -Name 'LocID' -Value $currentLocID -Force
}
# 5. Discards duplicate locations that already exist in Ninja based on exact name match within the same organization, and creates API request for locations that still need to be created
foreach ($asset in $assets){
  if ($asset.LocID -eq 0 -or [string]::IsNullOrEmpty($asset.LocID)) {

  $locations_url = "https://app.ninjarmm.com/api/v2/organization/" + $asset.OrgID + "/locations"

  # define request body
  $request_body = @{
    name = $asset.LocName
  }

  # convert body to JSON
  $json = $request_body | ConvertTo-Json

  Write-Host "Creating location: $($asset.LocName) in $($asset.OrgName)"

  # Let's make the magic happen
  Invoke-RestMethod -Method 'Post' -Uri $locations_url -Headers $headers -Body $json -ContentType "application/json" -Verbose


Write-Host "Done!"
  }
#If the script is able to identify an existing location based on exact name match in the same organization, no API call will be made for that entry.
  else {
    Write-Error "$($asset.LocName) in $($asset.OrgName) appears to already exist, excluding from API call"
  }
}
