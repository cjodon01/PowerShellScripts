# Set the GitHub repository details
$owner = "your-github-username"
$repo = "your-repository-name"
$token = "your-github-personal-access-token"

# Set the GitHub API URL for the repository actions
$apiUrl = "https://api.github.com/repos/$owner/$repo/actions/artifacts"

# Get the list of artifacts in the repository
$response = Invoke-RestMethod -Uri $apiUrl -Headers @{
    Authorization = "token $token"
    Accept = "application/vnd.github.v3+json"
}

# Loop through the artifacts and delete them
foreach ($artifact in $response.artifacts) {
    $artifactId = $artifact.id
    $deleteUrl = "https://api.github.com/repos/$owner/$repo/actions/artifacts/$artifactId"
    Invoke-RestMethod -Method Delete -Uri $deleteUrl -Headers @{
        Authorization = "token $token"
        Accept = "application/vnd.github.v3+json"
    }
    Write-Output "Deleted artifact: $artifactId"
}
