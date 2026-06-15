param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [string]$Email
)

git config user.name "$Name"
git config user.email "$Email"

Write-Host "Updated local repo identity:"
git config --show-origin --get user.name
git config --show-origin --get user.email
