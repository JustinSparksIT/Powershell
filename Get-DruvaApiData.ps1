
param (
    [ValidateSet('User','Device','Last Backup', 'First Backup','Share Details','Restore Details', 'Cloud Storage Details', 'CloudCache Details','Inactive Devices')]
    [Parameter(Mandatory=$true)]
    [string]$ReportType,
    [Parameter(Mandatory=$true)]
    [string]$ApiUserName,
    [Parameter(Mandatory=$true)]
    [string]$ApiToken,
    [Parameter(Mandatory=$true)]
    [string]$server
)

switch ( $Reporttype )
{
    'User'                   { $report = 'users' }
    'Device'                 { $report = 'devices'}
    'Last Backup'            { $report = 'lastbackupdetails' }
    'First Backup'           { $report = 'firstbackupdetails' }
    'Share Details'          { $report = 'sharedetails' }
    'Restore Details'        { $report = 'restoredetails' }
    'Cloud Storage Details'  { $report = 'storages' }
    'CloudCache Details'     { $report = 'cloudcachedetails' }
    'Inactive Devices'       { $report = 'inactivedevicesdetails' }
}

$credPair = $credPair = "$($ApiUserName):$($ApiToken)"
$encodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credPair))
$headers = @{ Authorization = "Basic $encodedCredentials" }
$uri = "$server/api/reports/v2/$report"

TRY {
    $responseData = Invoke-RestMethod -Uri $uri  -Method Get -headers $headers -UseBasicParsing
    $response = $responseData.data
    return $response
}
CATCH {
    Write-Host $_.Exception.Message 
}






