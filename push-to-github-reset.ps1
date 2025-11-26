<#
push-to-github-reset.ps1

ONE-TIME helper to fully reset Git for this project and push everything
to your NEW GitHub account/repo.

Usage (run from VS Code / Cursor terminal or PowerShell):
  cd "C:\Users\acer\OneDrive - Taylor's Higher Education\Desktop\BimalSkatingPark\SkatingPark\SkatingPark\newBimalMama"
  powershell -ExecutionPolicy Bypass -File .\push-to-github-reset.ps1

What this script does:
- Deletes the existing .git folder in the project root (Git history only, NOT your files)
- Deletes the nested .git inside client (so client is part of the main repo)
- Re-initializes Git
- Sets your new GitHub identity:
    user.name  = skatingparkmanagementsystem-hash
    user.email = skatingparkmanagementsystem@gmail.com
- Adds origin remote:
    https://github.com/skatingparkmanagementsystem-hash/SkatingPark-Management-System.git
- Sets main as the default branch
- Adds ALL files, commits, and pushes to origin/main

IMPORTANT:
- Before running this, open Credential Manager and remove any old GitHub
  credentials (git:https://github.com, https://github.com) so that the
  push uses your new account.
#>

Set-StrictMode -Version Latest

Write-Host "=== SkatingPark FULL GIT RESET + PUSH (NEW ACCOUNT) ===" -ForegroundColor Cyan

# Always work from the folder where this script lives
Push-Location $PSScriptRoot

# Check Git is available
git --version > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Git is not installed or not in PATH."
    Pop-Location
    exit 1
}

$remoteUrl = "https://github.com/skatingparkmanagementsystem-hash/SkatingPark-Management-System.git"
$userName  = "skatingparkmanagementsystem-hash"
$userEmail = "skatingparkmanagementsystem@gmail.com"

Write-Host "Removing existing .git in repo root (if any)..."
if (Test-Path ".git") {
    Remove-Item -Recurse -Force ".git"
}

Write-Host "Removing nested .git inside client (if any)..."
if (Test-Path ".\client\.git") {
    Remove-Item -Recurse -Force ".\client\.git"
}

Write-Host "Initializing fresh Git repository..."
git init
if ($LASTEXITCODE -ne 0) {
    Write-Error "git init failed."
    Pop-Location
    exit 1
}

Write-Host "Configuring Git user for this repo..."
git config user.name  $userName
git config user.email $userEmail

Write-Host "Setting origin remote to $remoteUrl ..."
git remote add origin $remoteUrl

Write-Host "Setting main as default branch..."
git branch -M main

Write-Host "Staging ALL files..."
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Error "git add . failed."
    Pop-Location
    exit 1
}

$message = "Initial commit after full reset to new GitHub account"
Write-Host "Committing with message: $message"
git commit -m "$message"
if ($LASTEXITCODE -ne 0) {
    Write-Error "git commit failed (maybe nothing to commit?)."
    Pop-Location
    exit 1
}

Write-Host "Pushing to origin/main..."
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Error "git push failed. Check remote URL, network, or GitHub credentials."
    Pop-Location
    exit 1
}

Write-Host "=== RESET + PUSH COMPLETED SUCCESSFULLY ===" -ForegroundColor Green
Pop-Location
exit 0


