#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Azure Tenant E5 Validation Checklist for CPA Firm (Solo Practitioner)
    Includes QuickBooks, Dynamics 365, and accounting software integrations

.DESCRIPTION
    Comprehensive validation script for:
    - Microsoft 365 E5 tenant prerequisites
    - Cross-tenant collaboration readiness
    - QuickBooks Online API integration
    - Dynamics 365 Business Central compatibility
    - Other accounting software (Xero, Bill.com, etc.)
    - CPA firm specific compliance checks

.PARAMETER TenantId
    Your Azure tenant ID (optional, will auto-detect if not provided)

.PARAMETER IncludeQuickBooks
    Validate QuickBooks Online API prerequisites

.PARAMETER IncludeDynamics365
    Validate Dynamics 365 Business Central integration

.PARAMETER IncludeThirdPartyApps
    Check other accounting software integrations

.EXAMPLE
    .\validate-cpa-tenant-e5.ps1
    
.EXAMPLE
    .\validate-cpa-tenant-e5.ps1 -IncludeQuickBooks -IncludeDynamics365 -Verbose

.NOTES
    Author: Hassan Rahman (Heyson315)
    Version: 1.0
    CPA Firm: Solo Practitioner Testing Playground
    License: MIT
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$TenantId,
    
    [Parameter()]
    [switch]$IncludeQuickBooks,
    
    [Parameter()]
    [switch]$IncludeDynamics365,
    
    [Parameter()]
    [switch]$IncludeThirdPartyApps,
    
    [Parameter()]
    [switch]$DetailedReport
)

# Requires PowerShell 7+
#Requires -Version 7.0

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# ============================================================================
# GLOBAL VARIABLES
# ============================================================================

$script:ValidationResults = @()
$script:CriticalIssues = @()
$script:Warnings = @()
$script:Passed = 0
$script:Failed = 0
$script:WarningCount = 0

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Write-Header {
    param([string]$Title)
    Write-Host ""
    Write-Host "=" * 80 -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "=" * 80 -ForegroundColor Cyan
    Write-Host ""
}

function Write-CheckResult {
    param(
        [string]$CheckName,
        [string]$Status,
        [string]$Message,
        [string]$Severity = "Info"
    )
    
    $Icon = switch ($Status) {
        "Pass" { "✅"; $script:Passed++ }
        "Fail" { "❌"; $script:Failed++ }
        "Warning" { "⚠️ "; $script:WarningCount++ }
        "Info" { "ℹ️ " }
        default { "❓" }
    }
    
    Write-Host "  $Icon $CheckName" -ForegroundColor $(
        switch ($Status) {
            "Pass" { "Green" }
            "Fail" { "Red" }
            "Warning" { "Yellow" }
            default { "Cyan" }
        }
    )
    
    if ($Message) {
        Write-Host "     $Message" -ForegroundColor Gray
    }
    
    $script:ValidationResults += [PSCustomObject]@{
        Category = $script:CurrentCategory
        Check = $CheckName
        Status = $Status
        Message = $Message
        Severity = $Severity
    }
    
    if ($Status -eq "Fail" -and $Severity -eq "Critical") {
        $script:CriticalIssues += "${CheckName}: ${Message}"
    }
    elseif ($Status -eq "Warning") {
        $script:Warnings += "${CheckName}: ${Message}"
    }
}

function Test-ModuleInstalled {
    param([string]$ModuleName)
    return (Get-Module -ListAvailable -Name $ModuleName) -ne $null
}

function Install-RequiredModule {
    param([string]$ModuleName)
    
    Write-Host "  📦 Installing $ModuleName..." -ForegroundColor Yellow
    try {
        Install-Module -Name $ModuleName -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
        Write-Host "  ✅ $ModuleName installed successfully" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  ❌ Failed to install $ModuleName : $_" -ForegroundColor Red
        return $false
    }
}

# ============================================================================
# VALIDATION CHECKS
# ============================================================================

function Test-PowerShellPrerequisites {
    $script:CurrentCategory = "PowerShell Prerequisites"
    Write-Header "1️⃣  PowerShell & Module Prerequisites"
    
    # PowerShell Version
    $psVersion = $PSVersionTable.PSVersion
    if ($psVersion.Major -ge 7) {
        Write-CheckResult "PowerShell Version" "Pass" "Version $psVersion"
    }
    else {
        Write-CheckResult "PowerShell Version" "Fail" "Version $psVersion (Requires 7.0+)" "Critical"
    }
    
    # Required Modules
    $requiredModules = @(
        @{Name = "Microsoft.Graph"; MinVersion = "2.0" },
        @{Name = "Microsoft.Graph.Authentication"; MinVersion = "2.0" },
        @{Name = "Microsoft.Graph.Identity.SignIns"; MinVersion = "2.0" },
        @{Name = "Microsoft.Graph.Users"; MinVersion = "2.0" }
    )
    
    foreach ($module in $requiredModules) {
        $installed = Get-Module -ListAvailable -Name $module.Name | 
                     Where-Object { $_.Version -ge $module.MinVersion } | 
                     Select-Object -First 1
        
        if ($installed) {
            Write-CheckResult "$($module.Name)" "Pass" "Version $($installed.Version)"
        }
        else {
            Write-CheckResult "$($module.Name)" "Fail" "Not installed or version < $($module.MinVersion)" "High"
            
            $install = Read-Host "    Install $($module.Name) now? (Y/N)"
            if ($install -eq 'Y') {
                Install-RequiredModule -ModuleName $module.Name
            }
        }
    }
}

function Test-AzureAuthentication {
    $script:CurrentCategory = "Azure Authentication"
    Write-Header "2️⃣  Azure Tenant Authentication"
    
    try {
        # Check if already connected
        $context = Get-MgContext -ErrorAction SilentlyContinue
        
        if ($null -eq $context) {
            Write-Host "  🔐 Not connected to Microsoft Graph. Attempting authentication..." -ForegroundColor Yellow
            Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All", "Policy.Read.All" -ErrorAction Stop
            $context = Get-MgContext
        }
        
        Write-CheckResult "Microsoft Graph Connection" "Pass" "Connected to tenant: $($context.TenantId)"
        
        # Store tenant ID for later use
        if (-not $script:TenantId) {
            $script:TenantId = $context.TenantId
        }
        
        # Check permissions
        $scopes = $context.Scopes
        $requiredScopes = @("User.Read.All", "Directory.Read.All", "Policy.Read.All")
        $missingScopes = $requiredScopes | Where-Object { $_ -notin $scopes }
        
        if ($missingScopes.Count -eq 0) {
            Write-CheckResult "Required Permissions" "Pass" "All required scopes granted"
        }
        else {
            Write-CheckResult "Required Permissions" "Warning" "Missing: $($missingScopes -join ', ')"
        }
    }
    catch {
        Write-CheckResult "Microsoft Graph Connection" "Fail" "Failed to connect: $_" "Critical"
    }
}

function Test-E5Licensing {
    $script:CurrentCategory = "E5 Licensing"
    Write-Header "3️⃣  Microsoft 365 E5 License Validation"
    
    try {
        # Get all users
        $users = Get-MgUser -All -Property "DisplayName,UserPrincipalName,AssignedLicenses" -ErrorAction Stop
        $totalUsers = $users.Count
        
        Write-CheckResult "Total Users" "Info" "$totalUsers users in tenant"
        
        # E5 SKU IDs (multiple variants)
        $e5Skus = @(
            "c7df2760-2c81-4ef7-b578-5b5392b571df",  # Microsoft 365 E5
            "06ebc4ee-1bb5-47dd-8120-11324bc54e06",  # Microsoft 365 E5 (No Teams)
            "f8a1db68-be16-40ed-86d5-cb42ce701560"   # Microsoft 365 E5 Developer
        )
        
        $e5Users = $users | Where-Object {
            $_.AssignedLicenses.SkuId | Where-Object { $_ -in $e5Skus }
        }
        
        $e5Count = ($e5Users | Measure-Object).Count
        $e5Percentage = if ($totalUsers -gt 0) { [math]::Round(($e5Count / $totalUsers) * 100, 2) } else { 0 }
        
        if ($e5Count -gt 0) {
            Write-CheckResult "E5 License Assignments" "Pass" "$e5Count users with E5 ($e5Percentage%)"
        }
        else {
            Write-CheckResult "E5 License Assignments" "Fail" "No E5 licenses found" "Critical"
        }
        
        # Check for users without E5 (in solo CPA, should be minimal)
        $nonE5Users = $totalUsers - $e5Count
        if ($nonE5Users -gt 0) {
            Write-CheckResult "Unlicensed/Non-E5 Users" "Warning" "$nonE5Users users without E5"
        }
        
        # Check E5 features availability
        $subscribedSkus = Get-MgSubscribedSku -ErrorAction Stop
        $e5Sku = $subscribedSkus | Where-Object { $_.SkuId -in $e5Skus } | Select-Object -First 1
        
        if ($e5Sku) {
            $availableLicenses = $e5Sku.PrepaidUnits.Enabled - $e5Sku.ConsumedUnits
            Write-CheckResult "E5 Licenses Available" "Info" "$availableLicenses licenses available"
            
            # Check included services
            $e5Services = @(
                "IDENTITY_THREAT_PROTECTION",     # Identity Protection
                "INTUNE_A",                       # Intune
                "MFA_PREMIUM",                    # MFA
                "AAD_PREMIUM_P2"                  # Entra ID P2
            )
            
            $enabledServices = $e5Sku.ServicePlans | Where-Object { $_.ProvisioningStatus -eq "Success" }
            foreach ($service in $e5Services) {
                $enabled = $enabledServices | Where-Object { $_.ServicePlanName -eq $service }
                if ($enabled) {
                    Write-CheckResult "$service" "Pass" "Enabled"
                }
                else {
                    Write-CheckResult "$service" "Warning" "Not enabled or not found"
                }
            }
        }
    }
    catch {
        Write-CheckResult "E5 License Check" "Fail" "Error: $_" "High"
    }
}

function Test-IdentityProtection {
    $script:CurrentCategory = "Identity Protection"
    Write-Header "4️⃣  Identity Protection (E5 Feature)"
    
    try {
        # Check if Identity Protection is available
        # Note: This requires Microsoft.Graph.IdentityProtection module
        Write-CheckResult "Identity Protection Module" "Info" "Checking availability..."
        
        # For now, we'll check if the feature is enabled via policy
        $caCheck = @"
        Identity Protection features to verify manually:
        1. Sign-in risk policy configured
        2. User risk policy configured
        3. Risk detections monitored
        4. Alerts configured for high-risk events
"@
        Write-CheckResult "Identity Protection Setup" "Info" $caCheck
        
    }
    catch {
        Write-CheckResult "Identity Protection" "Warning" "Unable to verify: $_"
    }
}

function Test-ConditionalAccess {
    $script:CurrentCategory = "Conditional Access"
    Write-Header "5️⃣  Conditional Access Policies"
    
    try {
        $policies = Get-MgIdentityConditionalAccessPolicy -All -ErrorAction Stop
        $policyCount = ($policies | Measure-Object).Count
        
        if ($policyCount -gt 0) {
            Write-CheckResult "CA Policies Deployed" "Pass" "$policyCount policies found"
            
            # Check for external user policies
            $externalPolicies = $policies | Where-Object {
                $_.Conditions.Users.IncludeGuestsOrExternalUsers
            }
            
            if ($externalPolicies) {
                Write-CheckResult "External User Policies" "Pass" "$($externalPolicies.Count) policies target external users"
            }
            else {
                Write-CheckResult "External User Policies" "Warning" "No policies specifically for external users"
            }
            
            # Check for report-only policies
            $reportOnly = $policies | Where-Object { $_.State -eq "enabledForReportingButNotEnforced" }
            if ($reportOnly) {
                Write-CheckResult "Report-Only Policies" "Info" "$($reportOnly.Count) policies in report-only mode"
            }
            
            # Check for emergency access exclusions
            $policiesWithExclusions = $policies | Where-Object {
                $_.Conditions.Users.ExcludeUsers.Count -gt 0
            }
            
            if ($policiesWithExclusions) {
                Write-CheckResult "Emergency Access Exclusions" "Pass" "Some policies have user exclusions"
            }
            else {
                Write-CheckResult "Emergency Access Exclusions" "Warning" "No emergency access exclusions found"
            }
        }
        else {
            Write-CheckResult "CA Policies Deployed" "Fail" "No policies found - deploy E5 templates" "High"
        }
    }
    catch {
        Write-CheckResult "Conditional Access" "Fail" "Error: $_" "High"
    }
}

function Test-IntuneDeviceCompliance {
    $script:CurrentCategory = "Intune Device Compliance"
    Write-Header "6️⃣  Intune Device Compliance (E5 Feature)"
    
    # Note: Full Intune validation requires Microsoft.Graph.Intune module
    Write-Host "  ℹ️  Intune validation requires manual verification:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. Navigate to: Intune admin center → Devices → Compliance policies" -ForegroundColor Gray
    Write-Host "  2. Verify policies exist for:" -ForegroundColor Gray
    Write-Host "     - Windows 10/11 (BitLocker, Defender AV, OS version)" -ForegroundColor Gray
    Write-Host "     - iOS/iPadOS (device encryption, passcode)" -ForegroundColor Gray
    Write-Host "     - Android (device encryption, Google Play Protect)" -ForegroundColor Gray
    Write-Host "  3. Check device enrollment status" -ForegroundColor Gray
    Write-Host ""
    
    Write-CheckResult "Intune Configuration" "Info" "Manual verification required (see above)"
}

function Test-CrossTenantAccess {
    $script:CurrentCategory = "Cross-Tenant Access"
    Write-Header "7️⃣  Cross-Tenant Access Configuration"
    
    try {
        # Check cross-tenant access settings
        Write-Host "  ℹ️  Checking cross-tenant access configuration..." -ForegroundColor Cyan
        
        # For now, manual check
        $crossTenantCheck = @"
        Cross-tenant access settings to verify:
        1. Entra admin center → External Identities → Cross-tenant access settings
        2. Check if partner organizations configured
        3. Verify inbound/outbound trust settings
        4. Confirm MFA/device claims accepted
"@
        Write-CheckResult "Cross-Tenant Access" "Info" $crossTenantCheck
        
    }
    catch {
        Write-CheckResult "Cross-Tenant Access" "Warning" "Unable to verify: $_"
    }
}

function Test-QuickBooksIntegration {
    param()
    
    $script:CurrentCategory = "QuickBooks Online"
    Write-Header "8️⃣  QuickBooks Online API Integration"
    
    Write-Host "  📊 QuickBooks Online Prerequisites:" -ForegroundColor Cyan
    Write-Host ""
    
    # QuickBooks API requirements
    $qbRequirements = @(
        @{
            Name = "QuickBooks Developer Account"
            Check = "Do you have a QuickBooks Developer account?"
            Action = "Create at: https://developer.intuit.com/"
        },
        @{
            Name = "OAuth 2.0 App Created"
            Check = "Have you created an app in QuickBooks Developer portal?"
            Action = "Create app → Get Client ID & Secret"
        },
        @{
            Name = "Redirect URI Configured"
            Check = "Is your redirect URI registered?"
            Action = "Add to app settings (e.g., https://yourapp.com/callback)"
        },
        @{
            Name = "Scopes Requested"
            Check = "Required scopes: com.intuit.quickbooks.accounting"
            Action = "Enable in app settings"
        },
        @{
            Name = "Test Company Connection"
            Check = "Can you connect to QuickBooks sandbox?"
            Action = "Use sandbox company for testing"
        }
    )
    
    foreach ($req in $qbRequirements) {
        Write-Host "  ☐ $($req.Name)" -ForegroundColor Yellow
        Write-Host "     Check: $($req.Check)" -ForegroundColor Gray
        Write-Host "     Action: $($req.Action)" -ForegroundColor Gray
        Write-Host ""
    }
    
    Write-CheckResult "QuickBooks API Prerequisites" "Info" "Manual verification required (see checklist above)"
    
    # API Endpoint Test (if credentials available)
    Write-Host "  ℹ️  To test QBO API connection, you'll need:" -ForegroundColor Cyan
    Write-Host "     - Client ID" -ForegroundColor Gray
    Write-Host "     - Client Secret" -ForegroundColor Gray
    Write-Host "     - Company ID (Realm ID)" -ForegroundColor Gray
    Write-Host "     - OAuth tokens (access + refresh)" -ForegroundColor Gray
    Write-Host ""
}

function Test-Dynamics365Integration {
    param()
    
    $script:CurrentCategory = "Dynamics 365 Business Central"
    Write-Header "9️⃣  Dynamics 365 Business Central Integration"
    
    Write-Host "  📊 Dynamics 365 Business Central Prerequisites:" -ForegroundColor Cyan
    Write-Host ""
    
    # D365 BC requirements
    $d365Requirements = @(
        @{
            Name = "Dynamics 365 Business Central License"
            Check = "Do you have D365 BC Essentials or Premium?"
            Action = "Required for API access"
        },
        @{
            Name = "Azure AD App Registration"
            Check = "Have you registered an Azure AD app for D365 BC?"
            Action = "Azure Portal → App Registrations → New"
        },
        @{
            Name = "API Permissions Granted"
            Check = "API permissions: Dynamics 365 Business Central API"
            Action = "Grant admin consent for API access"
        },
        @{
            Name = "Service Principal Access"
            Check = "Is service principal added to D365 BC?"
            Action = "Business Central → Users → Add app user"
        },
        @{
            Name = "Web Services Enabled"
            Check = "Are OData/API web services published?"
            Action = "D365 BC → Web Services → Publish required pages"
        }
    )
    
    foreach ($req in $d365Requirements) {
        Write-Host "  ☐ $($req.Name)" -ForegroundColor Yellow
        Write-Host "     Check: $($req.Check)" -ForegroundColor Gray
        Write-Host "     Action: $($req.Action)" -ForegroundColor Gray
        Write-Host ""
    }
    
    Write-CheckResult "Dynamics 365 BC Prerequisites" "Info" "Manual verification required (see checklist above)"
    
    # Environment check
    Write-Host "  ℹ️  D365 Business Central API Endpoints:" -ForegroundColor Cyan
    Write-Host "     Production: https://api.businesscentral.dynamics.com/v2.0/{tenantId}/{environment}" -ForegroundColor Gray
    Write-Host "     Sandbox: Use your sandbox environment name" -ForegroundColor Gray
    Write-Host ""
}

function Test-ThirdPartyApps {
    param()
    
    $script:CurrentCategory = "Third-Party Integrations"
    Write-Header "🔟 Other Accounting Software Integrations"
    
    $thirdPartyApps = @(
        @{
            Name = "Xero"
            ApiDocs = "https://developer.xero.com/"
            AuthType = "OAuth 2.0"
            Notes = "Popular for small businesses"
        },
        @{
            Name = "Bill.com"
            ApiDocs = "https://developer.bill.com/"
            AuthType = "OAuth 2.0"
            Notes = "AP/AR automation"
        },
        @{
            Name = "Avalara (Tax)"
            ApiDocs = "https://developer.avalara.com/"
            AuthType = "API Key / OAuth"
            Notes = "Sales tax automation"
        },
        @{
            Name = "Stripe (Payments)"
            ApiDocs = "https://stripe.com/docs/api"
            AuthType = "API Key"
            Notes = "Payment processing"
        },
        @{
            Name = "Plaid (Banking)"
            ApiDocs = "https://plaid.com/docs/"
            AuthType = "API Key"
            Notes = "Bank account connectivity"
        }
    )
    
    Write-Host "  📋 Common CPA Firm Integrations:" -ForegroundColor Cyan
    Write-Host ""
    
    foreach ($app in $thirdPartyApps) {
        Write-Host "  • $($app.Name)" -ForegroundColor Yellow
        Write-Host "     Docs: $($app.ApiDocs)" -ForegroundColor Gray
        Write-Host "     Auth: $($app.AuthType)" -ForegroundColor Gray
        Write-Host "     Notes: $($app.Notes)" -ForegroundColor Gray
        Write-Host ""
    }
    
    Write-CheckResult "Third-Party App Research" "Info" "See list above for integration options"
}

function Test-CPAFirmCompliance {
    $script:CurrentCategory = "CPA Firm Compliance"
    Write-Header "1️⃣1️⃣  CPA Firm Specific Compliance Checks"
    
    Write-Host "  🏢 Solo CPA Practitioner Considerations:" -ForegroundColor Cyan
    Write-Host ""
    
    $cpaChecks = @(
        @{
            Name = "Client Data Segregation"
            Requirement = "Each client's data in separate folders/SharePoint sites"
            Status = "Manual"
        },
        @{
            Name = "7-Year Data Retention"
            Requirement = "Configure audit logs and file retention (IRS requirement)"
            Status = "Manual"
        },
        @{
            Name = "Encryption at Rest"
            Requirement = "Enabled by default in Microsoft 365"
            Status = "Auto"
        },
        @{
            Name = "Encryption in Transit"
            Requirement = "TLS 1.2+ for all connections"
            Status = "Auto"
        },
        @{
            Name = "MFA Enforcement"
            Requirement = "All users (including you) must use MFA"
            Status = "Check CA Policies"
        },
        @{
            Name = "Client Confidentiality"
            Requirement = "AICPA Code of Professional Conduct Section 1.700"
            Status = "Policy"
        },
        @{
            Name = "State Board Compliance"
            Requirement = "Check your state's data protection requirements"
            Status = "Manual"
        }
    )
    
    foreach ($check in $cpaChecks) {
        Write-Host "  ☐ $($check.Name)" -ForegroundColor Yellow
        Write-Host "     Requirement: $($check.Requirement)" -ForegroundColor Gray
        Write-Host "     Status: $($check.Status)" -ForegroundColor Gray
        Write-Host ""
    }
    
    Write-CheckResult "CPA Compliance Framework" "Info" "Manual verification required (see checklist above)"
}

function Write-FinalSummary {
    Write-Header "📊 Validation Summary"
    
    Write-Host "  Results:" -ForegroundColor Cyan
    Write-Host "  ✅ Passed: $script:Passed" -ForegroundColor Green
    Write-Host "  ❌ Failed: $script:Failed" -ForegroundColor Red
    Write-Host "  ⚠️  Warnings: $script:WarningCount" -ForegroundColor Yellow
    Write-Host ""
    
    # Critical issues
    if ($script:CriticalIssues.Count -gt 0) {
        Write-Host "  🚨 CRITICAL ISSUES (Must Fix):" -ForegroundColor Red
        foreach ($issue in $script:CriticalIssues) {
            Write-Host "     • $issue" -ForegroundColor Red
        }
        Write-Host ""
    }
    
    # Warnings
    if ($script:Warnings.Count -gt 0 -and $script:Warnings.Count -le 5) {
        Write-Host "  ⚠️  WARNINGS (Recommended):" -ForegroundColor Yellow
        foreach ($warning in $script:Warnings) {
            Write-Host "     • $warning" -ForegroundColor Yellow
        }
        Write-Host ""
    }
    
    # Next steps
    Write-Host "  📋 Next Steps:" -ForegroundColor Cyan
    Write-Host ""
    
    if ($script:Failed -gt 0) {
        Write-Host "  1. Address CRITICAL issues above" -ForegroundColor Red
        Write-Host "  2. Review E5 prerequisites in docs/e5-optimization-guide.md" -ForegroundColor Yellow
        Write-Host "  3. Deploy missing CA policies from docs/policies/" -ForegroundColor Yellow
    }
    else {
        Write-Host "  1. ✅ Tenant meets E5 prerequisites!" -ForegroundColor Green
        Write-Host "  2. Deploy E5-enhanced CA policy (docs/policies/conditional-access-mfa-external-e5-enhanced.yaml)" -ForegroundColor Cyan
        Write-Host "  3. Set up cross-tenant access (docs/cross-tenant-access/partner-tenant-config.yaml)" -ForegroundColor Cyan
        Write-Host "  4. Configure accounting software integrations (QuickBooks, D365)" -ForegroundColor Cyan
    }
    Write-Host ""
    
    # Export detailed report
    if ($DetailedReport) {
        $reportPath = ".\validation-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        $script:ValidationResults | ConvertTo-Json -Depth 10 | Out-File $reportPath
        Write-Host "  📄 Detailed report saved: $reportPath" -ForegroundColor Cyan
        Write-Host ""
    }
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

try {
    Write-Host ""
    Write-Host "🎯 Azure Tenant E5 Validation for CPA Firm (Solo Practitioner)" -ForegroundColor Cyan
    Write-Host "   Testing Playground + Accounting Software Integrations" -ForegroundColor Cyan
    Write-Host ""
    
    # Run validation checks
    Test-PowerShellPrerequisites
    Test-AzureAuthentication
    Test-E5Licensing
    Test-IdentityProtection
    Test-ConditionalAccess
    Test-IntuneDeviceCompliance
    Test-CrossTenantAccess
    
    # Optional integrations
    if ($IncludeQuickBooks -or $PSBoundParameters.Count -eq 0) {
        Test-QuickBooksIntegration
    }
    
    if ($IncludeDynamics365 -or $PSBoundParameters.Count -eq 0) {
        Test-Dynamics365Integration
    }
    
    if ($IncludeThirdPartyApps -or $PSBoundParameters.Count -eq 0) {
        Test-ThirdPartyApps
    }
    
    Test-CPAFirmCompliance
    
    # Final summary
    Write-FinalSummary
    
    # Exit code
    if ($script:Failed -gt 0) {
        exit 1
    }
    else {
        exit 0
    }
}
catch {
    Write-Host ""
    Write-Host "❌ Fatal Error: $_" -ForegroundColor Red
    Write-Host ""
    exit 1
}
finally {
    Write-Host "=" * 80 -ForegroundColor Gray
    Write-Host ""
}
