# Variables
$repo = "${{ github.repository }}"
$environment = "${{ env.ENVIRONMENT_NAME }}"
$url = "https://api.github.com/repos/$repo/environments/$environment"
$headers = @{ Authorization = "token $env:GITHUB_TOKEN" }

# Make the API request
try {
    $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -UseBasicParsing
} catch {
    $statusCode = $_.Exception.Response.StatusCode
    if ($statusCode -eq 403) {
        Write-Host "Error: Insufficient permissions. Ensure that the workflow has the following permissions:"
        Write-Host "permissions: actions: read, contents: read, deployments: read"
        exit 1
    }

    if ($statusCode -eq 404) {
        Write-Host "Error: '$environment' environment does not exist."
        exit 1
    }

    Write-Host "Error: '$statusCode': $response"
}

# Check if protection rules exist
$protectionRules = $response.protection_rules

if ($protectionRules.Count -eq 0) {
    Write-Host "Error: '$environment' environment exists but has no protection rules (approval requirements)."
    exit 1
}

Write-Host "'$environment' environment exists and has protection rules."
