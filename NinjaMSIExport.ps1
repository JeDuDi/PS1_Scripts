$StartTime = Get-Date

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
    
# Get date of today   
$today = Get-Date -format "yyyyMMdd"

#define my table
$table = New-Object System.Data.Datatable
# Adding columns
[void]$table.Columns.Add("Org Name")
[void]$table.Columns.Add("Location")
[void]$table.Columns.Add("MSI")
    
# file paths    
$MSI_export = "C:\MSIExports\" + $today + "_Ninja_MSI_Export.csv"   
   
# define ninja urls    
$organizations_url = "https://app.ninjarmm.com/v2/organizations-detailed"
    
# call ninja urls  
$organizations = Invoke-RestMethod -Uri $organizations_url -Method GET -Headers $headers -Verbose
$organizations | Format-Table | Out-String
    
# add rows to the table
Foreach ($organization in $organizations) {
    $organizationID = $organization.id
    $locations = $organization.locations
    
    Foreach ($location in $locations) {
        $locationID = $location.id
        $MSI_url = "https://app.ninjarmm.com/v2/organization/" + $organizationID + "/location/" + $locationID + "/installer/WINDOWS_MSI"
        $MSI = Invoke-RestMethod -Uri $MSI_url -Method GET -Headers $headers
        $MSIOutput = "C:\MSIExports\" + $organization.Name + $location.Name + ".msi"
        Start-BitsTransfer -Source $MSI.url -Destination $MSIOutput

        # Adding rows
        [void]$table.Rows.Add($organization.Name,$location.name,$MSI.url)

        #create bat file
        $BATexport = "C:\MSIExports\" + $organization.Name + $location.Name + ".bat"
        $BATcode = 'msiexec.exe /i ' + $msi.url
        $BATcode | Out-File "$BATexport"  -Encoding Ascii
     }
}
         
$table | Format-Table | Out-String

$table | Export-CSV -NoTypeInformation -Path $MSI_export
    
    
Write-Host "csv files have been created with success!"
Write-Host "Creation Time: " $((New-Timespan -Start $StartTime -End $(Get-Date)).TotalMinutes) " minutes"
Write-Host "Go to " $MSI_export " to find your MSI Export"