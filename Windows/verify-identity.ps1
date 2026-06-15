$insideRepo = $false
try {
    git rev-parse --is-inside-work-tree | Out-Null
    $insideRepo = $true
} catch {
    $insideRepo = $false
}

if ($insideRepo) {
    Write-Host "Repository: $(git rev-parse --show-toplevel)"
} else {
    Write-Host "Repository: not in a git repo"
}

Write-Host "user.name : $(git config --show-origin --get user.name)"
Write-Host "user.email: $(git config --show-origin --get user.email)"
Write-Host ""
Write-Host "Author ident:"
git var GIT_AUTHOR_IDENT 2>$null
