# PowerShell Auto-Commit Script for Windows
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoDir = Split-Path -Parent $ScriptDir

Set-Location $RepoDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Starting Auto Commit for algorithm_SQL" -ForegroundColor Cyan
Write-Host " Repository: https://github.com/AkimJemi/algorithm_SQL.git" -ForegroundColor Cyan
Write-Host " Directory: $RepoDir" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Check git status
$gitStatus = git status --porcelain
if (-not $gitStatus) {
    Write-Host "No changes detected in repository. Nothing to commit." -ForegroundColor Yellow
    exit 0
}

# Determine commit message
$commitMsg = $args[0]
if (-not $commitMsg) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $commitMsg = "Auto commit: $timestamp"
}

# Get current branch
$branch = git rev-parse --abbrev-ref HEAD

Write-Host "Staging changes..." -ForegroundColor Yellow
git add .

Write-Host "Committing with message: '$commitMsg'..." -ForegroundColor Yellow
git commit -m $commitMsg

Write-Host "Pushing to remote origin/$branch..." -ForegroundColor Yellow
git push origin $branch

if ($LASTEXITCODE -eq 0) {
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host " Success! Changes pushed to GitHub." -ForegroundColor Green
    Write-Host " URL: https://github.com/AkimJemi/algorithm_SQL" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Green
} else {
    Write-Host "==========================================" -ForegroundColor Red
    Write-Host " Error: Failed to push changes to GitHub." -ForegroundColor Red
    Write-Host "==========================================" -ForegroundColor Red
    exit 1
}
