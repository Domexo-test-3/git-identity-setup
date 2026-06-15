param(
    [string]$OrganisationAName = "Organisation A Name",
    [string]$OrganisationAEmail = "you@organisation-a.example",
    [string]$OrganisationBName = "Organisation B Name",
    [string]$OrganisationBEmail = "you@organisation-b.example",
    [string]$OrganisationARepoDir = "$HOME\work\organisation-a\",
    [string]$OrganisationBRepoDir = "$HOME\work\organisation-b\"
)

$ErrorActionPreference = "Stop"

$homeGitConfig = Join-Path $HOME ".gitconfig"
$backupSuffix = Get-Date -Format "yyyyMMdd-HHmmss"
$backupPath = "$homeGitConfig.backup-$backupSuffix"

$orgAConfig = Join-Path $HOME ".gitconfig-organisation-a"
$orgBConfig = Join-Path $HOME ".gitconfig-organisation-b"

function Ensure-ParentFolder {
    param([string]$Path)
    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

function Write-IdentityConfig {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Email
    )
    Ensure-ParentFolder -Path $Path
    @"
[user]
    name = $Name
    email = $Email
"@ | Set-Content -Path $Path -Encoding utf8
}

function Append-IfMissing {
    param(
        [string]$Marker,
        [string]$Rule,
        [string]$PathValue
    )

    if (-not (Test-Path $homeGitConfig)) {
        New-Item -ItemType File -Path $homeGitConfig -Force | Out-Null
    }

    $content = Get-Content -Path $homeGitConfig -Raw
    if ($content -notmatch [regex]::Escape($Marker)) {
        Add-Content -Path $homeGitConfig -Value ""
        Add-Content -Path $homeGitConfig -Value "# $Marker"
        Add-Content -Path $homeGitConfig -Value "[includeIf `"$Rule`"]"
        Add-Content -Path $homeGitConfig -Value "    path = $PathValue"
    }
}

if (Test-Path $homeGitConfig) {
    Copy-Item -Path $homeGitConfig -Destination $backupPath -Force
} else {
    New-Item -ItemType File -Path $homeGitConfig -Force | Out-Null
}

New-Item -ItemType Directory -Path (Join-Path $HOME "work\organisation-a") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $HOME "work\organisation-b") -Force | Out-Null

Write-IdentityConfig -Path $orgAConfig -Name $OrganisationAName -Email $OrganisationAEmail
Write-IdentityConfig -Path $orgBConfig -Name $OrganisationBName -Email $OrganisationBEmail

$orgARule = "gitdir:" + ($OrganisationARepoDir -replace "\\", "/")
$orgBRule = "gitdir:" + ($OrganisationBRepoDir -replace "\\", "/")

Append-IfMissing -Marker "Git identity: organisation-a" -Rule $orgARule -PathValue $orgAConfig
Append-IfMissing -Marker "Git identity: organisation-b" -Rule $orgBRule -PathValue $orgBConfig

Write-Host "Installed."
Write-Host "Updated:"
Write-Host "  $homeGitConfig"
Write-Host "  $orgAConfig"
Write-Host "  $orgBConfig"
Write-Host "Backup:"
Write-Host "  $backupPath"
Write-Host "Next:"
Write-Host "  1. Edit the names, emails, and repo folder paths if needed."
Write-Host "  2. Put repositories under:"
Write-Host "     $OrganisationARepoDir"
Write-Host "     $OrganisationBRepoDir"
Write-Host "  3. Verify with:"
Write-Host '     git config --show-origin --get user.name'
Write-Host '     git config --show-origin --get user.email'
