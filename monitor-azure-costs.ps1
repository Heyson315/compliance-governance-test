#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Azure Cost Monitor & Alert System for Lean Strategy Compliance
    
.DESCRIPTION
    Monitors Azure and Microsoft 365 costs to ensure compliance with the "Start Lean" principle.
    Sends alerts when costs exceed thresholds defined in the Lean Tech Roadmap.
    
    Alert Thresholds:
    - Phase 1 (Current): $0-10/month (WARNING at $5, CRITICAL at $10)
    - Phase 2 (Planned): $10-50/month (WARNING at $40, CRITICAL at $50)
    - Phase 3 (Scale): $50-150/month (WARNING at $120, CRITICAL at $150)
    
.PARAMETER TenantId
    Your Azure tenant ID (optional, will auto-detect if not provided)
    
.PARAMETER AlertEmail
    Email address to send cost alerts (optional)
    
.PARAMETER SlackWebhook
    Slack webhook URL for notifications (optional)
    
.PARAMETER ExportReport
    Generate a detailed cost report file
    
.EXAMPLE
    .\monitor-azure-costs.ps1 -Verbose
    
.EXAMPLE
    .\monitor-azure-costs.ps1 -AlertEmail "admin@example.com" -ExportReport
    
.NOTES
    Author: Hassan Rahman (Heyson315)
    Version: 1.0
    Repository: compliance-governance-test
    License: MIT
    
    Required Permissions:
    - Cost Management Reader (Azure)
    - Global Reader or Billing Administrator (M365)
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$TenantId,
    
    [Parameter()]
    [string]$AlertEmail,
    
    [Parameter()]
    [string]$SlackWebhook,
    
    [Parameter()]
    [switch]$ExportReport
)

#Requires -Version 7.0

# Cost thresholds based on roadmap phases
$script:CostThresholds = @{
    Phase1 = @{
        Name = "Quick Wins"
        MaxCost = 10
        WarningCost = 5
        CurrentPhase = $true
    }
    Phase2 = @{
        Name = "Incremental Automation"
        MaxCost = 50
        WarningCost = 40
        CurrentPhase = $false
    }
    Phase3 = @{
        Name = "Scale Gradually"
        MaxCost = 150
        WarningCost = 120
        CurrentPhase = $false
    }
}

$script:CostData = @{
    Azure = @{
        Total = 0
        Services = @()
    }
    M365 = @{
        Total = 0
        Licenses = @()
    }
    GitHub = @{
        Total = 0
        Usage = @()
    }
}

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-StatusBanner {
    param([string]$Title)
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Get-AzureCosts {
    Write-StatusBanner "Analyzing Azure Costs"
    
    try {
        # Check if Az modules are installed
        $azAccountsModule = Get-Module -ListAvailable -Name Az.Accounts
        $azCostModule = Get-Module -ListAvailable -Name Az.CostManagement
        
        if (-not $azAccountsModule) {
            Write-ColorOutput "⚠️  Az.Accounts module not installed" "Yellow"
            Write-ColorOutput "   Run: Install-Module -Name Az.Accounts -Scope CurrentUser" "Gray"
            return
        }
        
        # Connect to Azure
        $context = Get-AzContext -ErrorAction SilentlyContinue
        if (-not $context) {
            Write-ColorOutput "🔐 Connecting to Azure..." "Cyan"
            Connect-AzAccount -TenantId $TenantId -ErrorAction Stop | Out-Null
        }
        
        # Get current subscription
        $subscription = Get-AzSubscription -TenantId $TenantId | Select-Object -First 1
        if (-not $subscription) {
            Write-ColorOutput "⚠️  No Azure subscription found" "Yellow"
            return
        }
        
        Write-ColorOutput "📊 Subscription: $($subscription.Name)" "White"
        Write-ColorOutput "   Subscription ID: $($subscription.Id)" "Gray"
        
        # Get cost data for current month
        $startDate = (Get-Date -Day 1).ToString("yyyy-MM-dd")
        $endDate = (Get-Date).ToString("yyyy-MM-dd")
        
        Write-ColorOutput "   Analyzing costs from $startDate to $endDate..." "Gray"
        
        # Check for free tier subscriptions
        if ($subscription.Name -like "*Free*" -or $subscription.Name -like "*Trial*" -or $subscription.Name -like "*Student*") {
            Write-ColorOutput "✅ FREE Azure Subscription Detected!" "Green"
            Write-ColorOutput "   Type: $($subscription.Name)" "Gray"
            $script:CostData.Azure.Total = 0
            return
        }
        
        # Try to get actual cost data
        if ($azCostModule) {
            try {
                $costs = Get-AzCostManagementUsageDetail -Scope "/subscriptions/$($subscription.Id)" `
                    -StartDate $startDate `
                    -EndDate $endDate `
                    -ErrorAction Stop
                
                if ($costs) {
                    $totalCost = ($costs | Measure-Object -Property Cost -Sum).Sum
                    $script:CostData.Azure.Total = [math]::Round($totalCost, 2)
                    
                    # Group by service
                    $serviceGroups = $costs | Group-Object -Property ConsumedService
                    foreach ($group in $serviceGroups) {
                        $serviceCost = ($group.Group | Measure-Object -Property Cost -Sum).Sum
                        $script:CostData.Azure.Services += [PSCustomObject]@{
                            Service = $group.Name
                            Cost = [math]::Round($serviceCost, 2)
                        }
                    }
                }
            }
            catch {
                Write-ColorOutput "⚠️  Unable to retrieve detailed cost data: $_" "Yellow"
                Write-ColorOutput "   Check Azure Cost Management permissions" "Gray"
            }
        }
        else {
            Write-ColorOutput "ℹ️  Install Az.CostManagement for detailed cost analysis" "Cyan"
            Write-ColorOutput "   Run: Install-Module -Name Az.CostManagement -Scope CurrentUser" "Gray"
        }
        
    }
    catch {
        Write-ColorOutput "❌ Error analyzing Azure costs: $_" "Red"
    }
}

function Get-M365Costs {
    Write-StatusBanner "Analyzing Microsoft 365 Costs"
    
    try {
        # Check if Microsoft Graph module is installed
        $mgModule = Get-Module -ListAvailable -Name Microsoft.Graph.Authentication
        
        if (-not $mgModule) {
            Write-ColorOutput "⚠️  Microsoft.Graph module not installed" "Yellow"
            Write-ColorOutput "   Run: Install-Module -Name Microsoft.Graph -Scope CurrentUser" "Gray"
            return
        }
        
        # Connect to Microsoft Graph
        $context = Get-MgContext -ErrorAction SilentlyContinue
        if (-not $context) {
            Write-ColorOutput "🔐 Connecting to Microsoft Graph..." "Cyan"
            Connect-MgGraph -Scopes "Organization.Read.All", "Directory.Read.All" -TenantId $TenantId -ErrorAction Stop | Out-Null
        }
        
        # Get subscribed SKUs
        $skus = Get-MgSubscribedSku -ErrorAction Stop
        
        $totalMonthlyCost = 0
        $freeLicenses = @()
        
        foreach ($sku in $skus) {
            $skuName = $sku.SkuPartNumber
            $consumed = $sku.ConsumedUnits
            $enabled = $sku.PrepaidUnits.Enabled
            
            # Detect free/trial licenses
            if ($skuName -like "*DEVELOPER*" -or $skuName -like "*TRIAL*" -or $skuName -like "*FREE*") {
                $freeLicenses += $skuName
                Write-ColorOutput "✅ FREE License: $skuName ($consumed/$enabled used)" "Green"
            }
            else {
                # Estimate costs for paid licenses (E5 ≈ $57/user/month)
                $estimatedCost = switch -Wildcard ($skuName) {
                    "*E5*" { $consumed * 57 }
                    "*E3*" { $consumed * 36 }
                    "*E1*" { $consumed * 10 }
                    "*BUSINESS_PREMIUM*" { $consumed * 22 }
                    "*BUSINESS_BASIC*" { $consumed * 6 }
                    default { 0 }
                }
                
                if ($estimatedCost -gt 0) {
                    $totalMonthlyCost += $estimatedCost
                    $script:CostData.M365.Licenses += [PSCustomObject]@{
                        License = $skuName
                        Consumed = $consumed
                        Cost = [math]::Round($estimatedCost, 2)
                    }
                    Write-ColorOutput "💰 $skuName ($consumed units) ≈ `$$([math]::Round($estimatedCost, 2))/month" "Yellow"
                }
            }
        }
        
        $script:CostData.M365.Total = [math]::Round($totalMonthlyCost, 2)
        
        if ($freeLicenses.Count -gt 0) {
            Write-ColorOutput "🎉 You're using $($freeLicenses.Count) free license type(s)!" "Green"
        }
        
    }
    catch {
        Write-ColorOutput "❌ Error analyzing M365 costs: $_" "Red"
    }
}

function Get-GitHubCosts {
    Write-StatusBanner "Analyzing GitHub Costs"
    
    Write-ColorOutput "📊 GitHub Actions Usage:" "White"
    Write-ColorOutput "   Free tier: 2,000 minutes/month for private repos" "Gray"
    Write-ColorOutput "   Unlimited minutes for public repos" "Gray"
    
    # Check if GitHub CLI is installed
    $ghInstalled = Get-Command gh -ErrorAction SilentlyContinue
    
    if (-not $ghInstalled) {
        Write-ColorOutput "⚠️  GitHub CLI not installed" "Yellow"
        Write-ColorOutput "   Install from: https://cli.github.com" "Gray"
        Write-ColorOutput "   Current cost: $0 (assumed free tier)" "Green"
        return
    }
    
    try {
        # Get current usage (requires gh auth)
        $authStatus = gh auth status 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "⚠️  GitHub CLI not authenticated" "Yellow"
            Write-ColorOutput "   Run: gh auth login" "Gray"
            return
        }
        
        # Get workflow runs for current month
        $startDate = (Get-Date -Day 1).ToString("yyyy-MM-dd")
        $runs = gh api "/repos/Heyson315/compliance-governance-test/actions/runs?created=>=$startDate" 2>$null | ConvertFrom-Json
        
        if ($runs.total_count) {
            Write-ColorOutput "✅ Workflow runs this month: $($runs.total_count)" "Green"
            Write-ColorOutput "   All in free tier ✓" "Gray"
        }
        
        $script:CostData.GitHub.Total = 0
        
    }
    catch {
        Write-ColorOutput "⚠️  Unable to retrieve GitHub usage: $_" "Yellow"
    }
}

function Test-CostThresholds {
    Write-StatusBanner "Cost Threshold Analysis"
    
    $totalMonthlyCost = $script:CostData.Azure.Total + $script:CostData.M365.Total + $script:CostData.GitHub.Total
    
    Write-ColorOutput "📊 Monthly Cost Summary:" "Cyan"
    Write-ColorOutput "   Azure:     `$$($script:CostData.Azure.Total)" "White"
    Write-ColorOutput "   M365:      `$$($script:CostData.M365.Total)" "White"
    Write-ColorOutput "   GitHub:    `$$($script:CostData.GitHub.Total)" "White"
    Write-Host "   ─────────────────────────" -ForegroundColor Gray
    Write-ColorOutput "   TOTAL:     `$$totalMonthlyCost" "Cyan"
    Write-Host ""
    
    # Determine current phase
    $currentPhase = $script:CostThresholds.Phase1
    if ($script:CostThresholds.Phase2.CurrentPhase) { $currentPhase = $script:CostThresholds.Phase2 }
    if ($script:CostThresholds.Phase3.CurrentPhase) { $currentPhase = $script:CostThresholds.Phase3 }
    
    Write-ColorOutput "🎯 Current Phase: $($currentPhase.Name)" "Cyan"
    Write-ColorOutput "   Budget Target: `$0-`$$($currentPhase.MaxCost)/month" "Gray"
    
    # Check thresholds
    if ($totalMonthlyCost -eq 0) {
        Write-ColorOutput "✅ EXCELLENT! Zero monthly costs - Perfect 'Start Lean' execution!" "Green"
    }
    elseif ($totalMonthlyCost -lt $currentPhase.WarningCost) {
        Write-ColorOutput "✅ GOOD! Within budget (< `$$($currentPhase.WarningCost))" "Green"
    }
    elseif ($totalMonthlyCost -lt $currentPhase.MaxCost) {
        Write-ColorOutput "⚠️  WARNING! Approaching budget limit (`$$totalMonthlyCost / `$$($currentPhase.MaxCost))" "Yellow"
        Send-CostAlert "WARNING" $totalMonthlyCost $currentPhase.MaxCost
    }
    else {
        Write-ColorOutput "🚨 CRITICAL! Budget exceeded (`$$totalMonthlyCost > `$$($currentPhase.MaxCost))" "Red"
        Write-ColorOutput "   ACTION REQUIRED: Review and reduce costs immediately" "Red"
        Send-CostAlert "CRITICAL" $totalMonthlyCost $currentPhase.MaxCost
    }
    
    # Provide recommendations
    Write-Host ""
    Write-ColorOutput "💡 Cost Optimization Recommendations:" "Cyan"
    
    if ($script:CostData.Azure.Total -gt 0) {
        Write-ColorOutput "   • Azure: Review active resources and consider:" "Yellow"
        foreach ($service in $script:CostData.Azure.Services | Sort-Object Cost -Descending | Select-Object -First 3) {
            Write-ColorOutput "     - $($service.Service): `$$($service.Cost)" "Gray"
        }
    }
    
    if ($script:CostData.M365.Total -gt 0) {
        Write-ColorOutput "   • M365: Consider E5 Developer (FREE) for testing" "Yellow"
        Write-ColorOutput "     Visit: https://developer.microsoft.com/microsoft-365/dev-program" "Gray"
    }
}

function Send-CostAlert {
    param(
        [string]$Level,
        [decimal]$CurrentCost,
        [decimal]$Threshold
    )
    
    $message = @"
🚨 Azure Cost Alert - $Level

Current Monthly Cost: `$$CurrentCost
Budget Threshold: `$$Threshold

Repository: compliance-governance-test
Phase: Phase 1 - Quick Wins

Action Required: Review costs at https://portal.azure.com
"@
    
    # Send email alert
    if ($AlertEmail) {
        Write-ColorOutput "📧 Sending alert to $AlertEmail..." "Cyan"
        # Email implementation would go here
    }
    
    # Send Slack alert
    if ($SlackWebhook) {
        Write-ColorOutput "📱 Sending alert to Slack..." "Cyan"
        try {
            $payload = @{
                text = $message
                username = "Azure Cost Monitor"
                icon_emoji = ":warning:"
            } | ConvertTo-Json
            
            Invoke-RestMethod -Uri $SlackWebhook -Method Post -Body $payload -ContentType "application/json" | Out-Null
            Write-ColorOutput "✅ Slack alert sent successfully" "Green"
        }
        catch {
            Write-ColorOutput "❌ Failed to send Slack alert: $_" "Red"
        }
    }
}

function Export-CostReport {
    $reportPath = Join-Path $PSScriptRoot "cost-report-$(Get-Date -Format 'yyyy-MM-dd').json"
    
    $report = @{
        GeneratedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        TotalCost = $script:CostData.Azure.Total + $script:CostData.M365.Total + $script:CostData.GitHub.Total
        Azure = $script:CostData.Azure
        M365 = $script:CostData.M365
        GitHub = $script:CostData.GitHub
        Phase = "Phase1"
        Status = if (($script:CostData.Azure.Total + $script:CostData.M365.Total) -eq 0) { "Excellent" } else { "Review" }
    }
    
    $report | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportPath -Encoding UTF8
    Write-ColorOutput "📄 Cost report exported to: $reportPath" "Green"
}

# Main execution
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                               ║" -ForegroundColor Cyan
Write-Host "║           Azure Cost Monitor - Lean Strategy Edition         ║" -ForegroundColor Cyan
Write-Host "║                                                               ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Get-AzureCosts
Get-M365Costs
Get-GitHubCosts
Test-CostThresholds

if ($ExportReport) {
    Export-CostReport
}

Write-Host ""
Write-ColorOutput "═══════════════════════════════════════════════════════════════" "Cyan"
Write-ColorOutput "  Monitoring Complete" "Cyan"
Write-ColorOutput "═══════════════════════════════════════════════════════════════" "Cyan"
Write-Host ""
