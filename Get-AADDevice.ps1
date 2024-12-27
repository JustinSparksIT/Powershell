param(
    [string]$tenantId,
    [string]$appId,
    [string]$appSecret
)

$device = "desktop-sparks"
function Get-GraphAccessTokenApp {
    param(
        $tenantId,
        $appId,
        $appSecret
    )
    # Define your Azure AD and application details
    $TenantID = $tenantId
    $appId = $appId
    $appSecret = $appSecret
    $GraphScope = "https://graph.microsoft.com/.default"

    # Define the resource URI and OAuth token endpoint
    $oAuthUri = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"

    # Prepare the body for the OAuth token request
    $authBody = [Ordered] @{
         client_id = "$appId"
         client_secret = "$appSecret"
         grant_type = 'client_credentials'
         scope = $GraphScope
    }

    #Write-Log -Message "Retrieving Token for $resourceAppIdUri"

    try {
        # Make the OAuth token request
        $authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop
        $token = $authResponse.access_token
        Write-Output $token
        #Write-Log -Message "Successfully retrieved access token" 

    } catch {
        #Write-Log -Message "An error occurred: $_" 
    }

}

$GraphAccessToken = Get-GraphAccessTokenApp -tenantId $tenantId -appId $appId -appSecret $appSecret

function Get-EntraIdDevice {
    [CmdletBinding()]
    param (
        [string]$accessToken
    )

    $apiUrl = "https://graph.microsoft.com/v1.0/devices?`$filter=startswith(displayName,'$($device)')"

    
    # Set up the headers with the authorization token
    $headers = @{
        "Authorization" = "Bearer $accessToken"
        "Content-Type"  = "application/json"
    }

    $array = @()

    # Make the API request
    $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -Method Get

    # Output the list of machines
    $array += $response.value

    return $array

}

Get-EntraIdDevice -accessToken $GraphAccessToken
