# Set the GitHub repository details
$owner = "your-github-username"
$repo = "your-repository-name"
$token = "your-github-personal-access-token"

# Set the GitHub API URL for the repository contents
$apiUrl = "https://api.github.com/repos/$owner/$repo/contents/.github/workflows"

# Get the list of files in the .github/workflows directory
$response = Invoke-RestMethod -Uri $apiUrl -Headers @{
    Authorization = "token $token"
    Accept = "application/vnd.github.v3+json"
}

# Loop through the files and delete the YAML files
foreach ($file in $response) {
    if ($file.name -match "\.ya?ml$") {
        $deleteUrl = "https://api.github.com/repos/$owner/$repo/contents/.github/workflows/$($file.name)"
        $body = @{
            message = "Delete $($file.name)"
            sha     = $file.sha
        }
        $jsonBody = $body | ConvertTo-Json
        $deleteResponse = Invoke-RestMethod -Method Delete -Uri $deleteUrl -Headers @{
            Authorization = "token $token"
            Accept = "application/vnd.github.v3+json"
        } -Body $jsonBody
        Write-Output "Deleted file: $($file.name)"
    }
}
