#!/usr/bin/env pwsh
# Setup GitHub Remote for compliance-governance-test
# Run this from: E:\source\Heyson315\compliance-governance-test

# Configuration
$RepoOwner = "Heyson315"
$RepoName = "compliance-governance-test"
$RemoteName = "origin"

Write-Host "🚀 Setting up GitHub remote for compliance-governance-test" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
$CurrentDir = Get-Location
if ($CurrentDir.Path -notlike "*compliance-governance-test*") {
    Write-Host "❌ Error: Please run this from the compliance-governance-test directory" -ForegroundColor Red
    Write-Host "   Current directory: $CurrentDir" -ForegroundColor Yellow
    exit 1
}

# Check if git is initialized
if (-not (Test-Path ".git")) {
    Write-Host "📦 Initializing git repository..." -ForegroundColor Yellow
    git init
    git branch -M master
}

# Check if remote already exists
$ExistingRemote = git remote get-url $RemoteName 2>$null
if ($ExistingRemote) {
    Write-Host "✅ Remote '$RemoteName' already configured: $ExistingRemote" -ForegroundColor Green
    Write-Host ""
    Write-Host "To change it, run:" -ForegroundColor Yellow
    Write-Host "  git remote set-url $RemoteName https://github.com/$RepoOwner/$RepoName.git" -ForegroundColor Cyan
    exit 0
}

# Add the remote
Write-Host "🔗 Adding remote '$RemoteName'..." -ForegroundColor Yellow
git remote add $RemoteName "https://github.com/$RepoOwner/$RepoName.git"

# Verify
$NewRemote = git remote get-url $RemoteName 2>$null
if ($NewRemote) {
    Write-Host "✅ Remote added successfully!" -ForegroundColor Green
    Write-Host "   URL: $NewRemote" -ForegroundColor Cyan
    Write-Host ""
    
    # Show next steps
    Write-Host "📋 Next Steps:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Create the repo on GitHub:" -ForegroundColor White
    Write-Host "   https://github.com/new" -ForegroundColor Cyan
    Write-Host "   Repository name: $RepoName" -ForegroundColor Cyan
    Write-Host "   Description: 'Lean Tech Roadmap for AI & Compliance Projects'" -ForegroundColor Cyan
    Write-Host "   ⚠️  Do NOT initialize with README (you already have files)" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "2. Stage all files:" -ForegroundColor White
    Write-Host "   git add ." -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "3. Commit:" -ForegroundColor White
    Write-Host "   git commit -m 'Initial commit: Cross-tenant collab docs with E5 optimization'" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "4. Push to GitHub:" -ForegroundColor White
    Write-Host "   git push -u origin master" -ForegroundColor Cyan
    Write-Host ""
    
} else {
    Write-Host "❌ Failed to add remote" -ForegroundColor Red
    exit 1
}

# Show current git status
Write-Host "📊 Current Git Status:" -ForegroundColor Yellow
Write-Host ""
git status --short
Write-Host ""

Write-Host "✨ Setup complete!" -ForegroundColor Green
