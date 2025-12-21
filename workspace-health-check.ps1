#!/usr/bin/env pwsh
# Workspace Health Check for compliance-governance-test
# Verifies all files are present and valid

Write-Host "🔍 Compliance-Governance-Test Workspace Health Check" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Gray
Write-Host ""

$RepoRoot = "E:\source\Heyson315\compliance-governance-test"
$AllGood = $true

# Change to repo directory
if (Test-Path $RepoRoot) {
    Set-Location $RepoRoot
    Write-Host "✅ Repository found: $RepoRoot" -ForegroundColor Green
} else {
    Write-Host "❌ Repository not found: $RepoRoot" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Expected files structure
$ExpectedFiles = @{
    "README.md" = "Main documentation hub"
    "docs/cross-tenant-collab.md" = "Comprehensive collaboration guide"
    "docs/e5-optimization-guide.md" = "E5 license optimization"
    "docs/e5-quick-reference.md" = "E5 quick reference card"
    "docs/policies/conditional-access-mfa-external.yaml" = "Standard CA policy"
    "docs/policies/conditional-access-mfa-external-e5-enhanced.yaml" = "E5-enhanced CA policy"
    "docs/cross-tenant-access/partner-tenant-config.yaml" = "Partner trust configuration"
    "docs/cross-tenant-sync/source-to-target.yaml" = "Sync automation config"
}

Write-Host "📄 Checking File Structure..." -ForegroundColor Yellow
Write-Host ""

$FileCheckResults = @()
foreach ($File in $ExpectedFiles.Keys) {
    $FullPath = Join-Path $RepoRoot $File
    $Description = $ExpectedFiles[$File]
    
    if (Test-Path $FullPath) {
        $FileSize = (Get-Item $FullPath).Length
        $FileSizeKB = [math]::Round($FileSize / 1KB, 2)
        
        Write-Host "  ✅ $File" -ForegroundColor Green
        Write-Host "     Size: ${FileSizeKB} KB | $Description" -ForegroundColor Gray
        
        $FileCheckResults += [PSCustomObject]@{
            File = $File
            Status = "✅ OK"
            Size = "${FileSizeKB} KB"
        }
    } else {
        Write-Host "  ❌ MISSING: $File" -ForegroundColor Red
        Write-Host "     Expected: $Description" -ForegroundColor Yellow
        $AllGood = $false
        
        $FileCheckResults += [PSCustomObject]@{
            File = $File
            Status = "❌ MISSING"
            Size = "N/A"
        }
    }
}
Write-Host ""

# Check YAML syntax (if yamllint available)
Write-Host "🔍 Checking YAML Syntax..." -ForegroundColor Yellow
Write-Host ""

$YamlFiles = Get-ChildItem -Path $RepoRoot -Recurse -Filter "*.yaml" -File
$YamlValid = $true

foreach ($YamlFile in $YamlFiles) {
    try {
        # Basic YAML validation (check for balanced quotes/brackets)
        $Content = Get-Content $YamlFile.FullName -Raw
        
        # Check for common YAML errors
        $Issues = @()
        
        # Check for unmatched quotes
        $SingleQuotes = ([regex]::Matches($Content, "'")).Count
        $DoubleQuotes = ([regex]::Matches($Content, '"')).Count
        
        if ($SingleQuotes % 2 -ne 0) {
            $Issues += "Unmatched single quotes"
        }
        if ($DoubleQuotes % 2 -ne 0) {
            $Issues += "Unmatched double quotes"
        }
        
        # Check for tabs (YAML doesn't allow tabs)
        if ($Content -match "`t") {
            $Issues += "Contains tabs (use spaces)"
        }
        
        if ($Issues.Count -eq 0) {
            Write-Host "  ✅ $($YamlFile.Name)" -ForegroundColor Green
        } else {
            Write-Host "  ⚠️  $($YamlFile.Name)" -ForegroundColor Yellow
            foreach ($Issue in $Issues) {
                Write-Host "     - $Issue" -ForegroundColor Yellow
            }
            $YamlValid = $false
        }
    } catch {
        Write-Host "  ❌ $($YamlFile.Name): $_" -ForegroundColor Red
        $YamlValid = $false
    }
}
Write-Host ""

# Check Git status
Write-Host "🔧 Git Configuration..." -ForegroundColor Yellow
Write-Host ""

$GitInitialized = Test-Path (Join-Path $RepoRoot ".git")
if ($GitInitialized) {
    Write-Host "  ✅ Git initialized" -ForegroundColor Green
    
    # Check for remote
    $Remote = git remote get-url origin 2>$null
    if ($Remote) {
        Write-Host "  ✅ Remote configured: $Remote" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  No remote configured (run setup-github-remote.ps1)" -ForegroundColor Yellow
        $AllGood = $false
    }
    
    # Check current branch
    $Branch = git branch --show-current
    Write-Host "  📍 Current branch: $Branch" -ForegroundColor Cyan
    
    # Check for uncommitted changes
    $Status = git status --porcelain
    if ($Status) {
        $UncommittedCount = ($Status | Measure-Object).Count
        Write-Host "  ⚠️  $UncommittedCount uncommitted file(s)" -ForegroundColor Yellow
    } else {
        Write-Host "  ✅ Working tree clean" -ForegroundColor Green
    }
} else {
    Write-Host "  ❌ Git not initialized (run: git init)" -ForegroundColor Red
    $AllGood = $false
}
Write-Host ""

# Check for E5 prerequisites (from conditional-access-mfa-external-e5-enhanced.yaml)
Write-Host "✅ E5 Prerequisites Checklist..." -ForegroundColor Yellow
Write-Host ""

$E5Prerequisites = @(
    "Intune device compliance policies configured"
    "Identity Protection risk policies enabled"
    "Defender for Cloud Apps connector configured"
    "Terms of Use published in Entra admin center"
    "Named locations defined (corporate networks)"
    "Emergency access accounts (break-glass) created"
)

Write-Host "  These must be configured in your Azure/Entra tenant:" -ForegroundColor Gray
foreach ($Prereq in $E5Prerequisites) {
    Write-Host "  ☐ $Prereq" -ForegroundColor Cyan
}
Write-Host ""

# Summary
Write-Host "=" * 60 -ForegroundColor Gray
Write-Host ""
Write-Host "📊 Summary:" -ForegroundColor Yellow
Write-Host ""

$FilesOK = ($FileCheckResults | Where-Object { $_.Status -eq "✅ OK" }).Count
$FilesMissing = ($FileCheckResults | Where-Object { $_.Status -eq "❌ MISSING" }).Count
$TotalFiles = $ExpectedFiles.Count

Write-Host "  Files: $FilesOK/$TotalFiles present" -ForegroundColor $(if ($FilesMissing -eq 0) { "Green" } else { "Yellow" })
Write-Host "  YAML: $(if ($YamlValid) { '✅ Valid' } else { '⚠️  Issues found' })" -ForegroundColor $(if ($YamlValid) { "Green" } else { "Yellow" })
Write-Host "  Git: $(if ($GitInitialized) { '✅ Initialized' } else { '❌ Not initialized' })" -ForegroundColor $(if ($GitInitialized) { "Green" } else { "Red" })
Write-Host ""

if ($AllGood -and $YamlValid) {
    Write-Host "🎉 Workspace is healthy!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Review E5 prerequisites above" -ForegroundColor White
    Write-Host "  2. Run setup-github-remote.ps1 (if remote not configured)" -ForegroundColor White
    Write-Host "  3. Commit and push to GitHub" -ForegroundColor White
    exit 0
} else {
    Write-Host "⚠️  Some issues found - please review above" -ForegroundColor Yellow
    exit 1
}
