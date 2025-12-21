# 🎯 Solo CPA Custom Policy Deployment Guide
**Step-by-Step Implementation for Your 1-Person CPA Firm**

![CPA](https://img.shields.io/badge/Solo_CPA-Custom_Policy-success?logo=microsoftazure)
![Testing](https://img.shields.io/badge/Testing-Playground_Ready-blue?logo=github)

---

## 📋 **What Makes This Policy Special**

Your custom policy (`conditional-access-solo-cpa-custom.yaml`) is optimized for:

✅ **Solo CPA practitioner** (just you!)  
✅ **Client B2B guests** (limited access to their engagement folders)  
✅ **QuickBooks Online** (OAuth 2.0 API integration)  
✅ **Dynamics 365 Business Central** (service principal API)  
✅ **Testing playground** (start in report-only mode)  
✅ **Flexible work** (8-hour sessions vs. enterprise 4-hour)  

---

## 🚀 **3-Phase Deployment Plan**

### **Phase 1: Report-Only Mode (Week 1-2)** ⚠️

```yaml
objective: "See what would happen WITHOUT blocking anyone"
duration: 1-2 weeks
state: enabledForReportingButNotEnforced

what_happens:
  - Policy evaluates all sign-ins
  - Results logged in CA insights
  - NO users blocked (safe to test!)
  - You review logs daily

success_criteria:
  - No unexpected blocks in simulation
  - Sign-in patterns understood
  - False positives identified
```

**Deployment Steps:**

```powershell
# 1. Navigate to Entra admin center
# https://entra.microsoft.com/

# 2. Go to: Protection → Conditional Access → New policy

# 3. Configure using your YAML template
# Open: conditional-access-solo-cpa-custom.yaml
# Copy settings into GUI

# 4. CRITICAL: Set State to "Report-only"
# This ensures no one gets blocked during testing!

# 5. Save policy

# 6. Monitor for 1-2 weeks
# Entra admin center → Protection → CA → Insights and reporting
```

**Daily Monitoring (5 minutes):**

```powershell
# Check sign-in logs
Connect-MgGraph -Scopes "AuditLog.Read.All"

$startDate = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")
Get-MgAuditLogSignIn -Filter "createdDateTime ge $startDate" -Top 100 |
  Select-Object UserPrincipalName, CreatedDateTime, ConditionalAccessStatus, Status |
  Format-Table -AutoSize

# Look for:
# - ConditionalAccessStatus: "reportOnlySuccess" or "reportOnlyFailure"
# - If "reportOnlyFailure" → Policy would have blocked (investigate!)
```

---

### **Phase 2: Pilot (Your Account Only) (Week 3-4)** 🧪

```yaml
objective: "Enable policy for YOU only (not clients yet)"
duration: 1-2 weeks
state: enabled

scope:
  include:
    - your_account_upn  # e.g., hassan@yourtenant.onmicrosoft.com
  exclude:
    - All B2B guests (temporarily)
    - Emergency access account

what_happens:
  - Policy enforces controls on YOUR sign-ins only
  - Clients not affected yet (safe!)
  - You experience real policy (MFA, session timeout, etc.)

success_criteria:
  - You can work normally (laptop, phone)
  - No disruptions to QuickBooks/D365 integrations
  - 8-hour session timeout acceptable
```

**Deployment Steps:**

```powershell
# 1. Edit your CA policy in Entra admin center

# 2. Update Assignments → Users
# Include: Your UPN (e.g., hassan@yourtenant.onmicrosoft.com)
# Exclude: All guest users (temporarily)

# 3. Change State: "Report-only" → "On"

# 4. Save policy

# 5. Test immediately:
# - Sign out of all devices
# - Sign in from your laptop → Should work (MFA once)
# - Sign in from your phone → Should work (email/Teams only)
# - Try QuickBooks OAuth → Should work
# - Try D365 BC API → Should work

# 6. Monitor for 1 week
# - Any issues? Adjust policy
# - Working smoothly? Proceed to Phase 3
```

**Testing Checklist:**

- [ ] Sign in from your work laptop → ✅ Works with MFA
- [ ] Sign in from your phone → ✅ Email/Teams accessible
- [ ] Download file from SharePoint (laptop) → ✅ Allowed
- [ ] Try to download from phone → ⚠️ Blocked by Intune APP (expected)
- [ ] QuickBooks OAuth authorization → ✅ Works
- [ ] D365 BC API call → ✅ Works
- [ ] Session timeout after 8 hours → ✅ Re-prompt for MFA
- [ ] Sign in from friend's laptop → ❌ Blocked (non-compliant)

---

### **Phase 3: Production (All Users) (Week 5+)** 🚀

```yaml
objective: "Enable policy for YOU + all B2B guest clients"
duration: Ongoing (production)
state: enabled

scope:
  include:
    - your_account_upn
    - All guest users (clients)
  exclude:
    - Emergency access account
    - QuickBooks service principal
    - D365 BC service principal

what_happens:
  - Policy enforces for everyone
  - Clients must use MFA
  - Clients limited to their engagement folders
  - Continuous monitoring

success_criteria:
  - You work normally
  - Clients can access their folders
  - No support issues
  - Audit logs clean
```

**Deployment Steps:**

```powershell
# 1. Edit your CA policy

# 2. Update Assignments → Users
# Include: 
#   - Your UPN
#   - "All guest users" (enable client enforcement)

# 3. Policy already "On" from Phase 2 (no change)

# 4. Save policy

# 5. Notify clients:
# Email template below

# 6. Monitor for first week closely
# - Any client issues? Provide support
# - False positives? Adjust policy

# 7. Ongoing: Review CA insights weekly
```

**Client Notification Email Template:**

```
Subject: Enhanced Security for Client Portal Access

Hi [Client Name],

We're implementing enhanced security measures to protect your confidential information. 

Starting [Date], when you access your engagement folder on our client portal, you'll be prompted to:

1. Set up Multi-Factor Authentication (MFA) if you haven't already
2. Accept our Terms of Use (one-time)
3. Sign in with your Microsoft 365 account

What This Means for You:
✅ Your data is more secure
✅ You'll need MFA (text message or app) when signing in
✅ Sessions expire after 4 hours (for security)

Need Help?
- MFA setup guide: [link to guide]
- Call/email me if you have questions

Thank you for your cooperation in keeping your information secure!

Best regards,
[Your Name], CPA
[Your Firm]
```

---

## 🔧 **Customization Options**

### **Option 1: Separate Policies for You vs. Clients**

**Current:** One policy for everyone  
**Alternative:** Two policies (more control)

```yaml
policy_1_cpa_owner:
  name: "CA-Solo-CPA-Owner"
  scope: Just you
  controls:
    - MFA required (once per 8 hours)
    - Device compliance recommended (not required)
    - No download restrictions
    - Full access to all apps

policy_2_client_guests:
  name: "CA-Solo-CPA-Clients"
  scope: All guest users
  controls:
    - MFA required (every sign-in)
    - Device compliance not required (they use their devices)
    - 4-hour session timeout
    - Download limits (DLP)
    - Access only to specific SharePoint sites
```

**When to Use:**
- You want different session timeouts (you: 8 hours, clients: 4 hours)
- You want stricter controls for clients vs. yourself
- You have many clients (>10) with varying needs

---

### **Option 2: Client-Specific Policies**

**For high-value clients (e.g., public companies):**

```yaml
policy_client_a_public_company:
  name: "CA-Client-A-Public-Company"
  scope: Client A CFO (specific guest user)
  controls:
    - MFA required (every sign-in, no trust)
    - Compliant device required (managed by Client A)
    - 2-hour session timeout
    - No downloads (view-only)
    - Phishing-resistant MFA (FIDO2 key)
  
  compliance_reason: SOX compliance for public company audit
```

**When to Use:**
- Client is a public company (SOX audit)
- Client handles sensitive data (HIPAA, PCI-DSS)
- Client requires it contractually

---

### **Option 3: Relaxed Policy for Testing**

**During playground experimentation:**

```yaml
testing_policy:
  name: "CA-Solo-CPA-Testing"
  scope: Your test account (separate from production)
  controls:
    - MFA required (once per day)
    - No device compliance
    - No session timeouts
    - All downloads allowed
  
  state: enabled
  duration: Temporary (disable after testing)
```

**When to Use:**
- Experimenting with QuickBooks API
- Testing D365 BC integration
- Learning E5 features
- Don't want to disrupt real work

---

## 🔐 **QuickBooks Online Integration Setup**

### **Step 1: Create Service Principal (Optional)**

```powershell
# If you want API-only access (no user prompt)

# 1. Create Azure AD app registration
Connect-MgGraph -Scopes "Application.ReadWrite.All"

$app = New-MgApplication -DisplayName "QuickBooks Online API" `
  -SignInAudience "AzureADMyOrg"

# 2. Note Application (client) ID
$app.AppId  # Save this!

# 3. Create client secret
$secret = Add-MgApplicationPassword -ApplicationId $app.Id `
  -PasswordCredential @{ DisplayName = "QBO API Secret" }

$secret.SecretText  # Save this immediately! (only shown once)

# 4. Grant API permissions (none needed for QBO OAuth)
# QBO uses OAuth 2.0 with redirect, not service principal

# 5. Add to CA policy exclusions
# Entra admin center → CA policy → Exclude: <App ID>
```

**Note:** QuickBooks Online typically uses **user OAuth**, not service principal. You'll authorize once, then your app uses tokens.

---

### **Step 2: OAuth 2.0 Flow (User Authorization)**

```yaml
qbo_oauth_flow:
  step_1_authorize:
    url: https://appcenter.intuit.com/connect/oauth2
    parameters:
      client_id: "Your QBO App Client ID"
      redirect_uri: "https://yourapp.com/callback"
      scope: "com.intuit.quickbooks.accounting"
    
    ca_policy_impact:
      - User prompted for MFA (one-time)
      - Terms of Use shown (if configured)
      - After authorization, tokens stored
  
  step_2_api_calls:
    url: https://quickbooks.api.intuit.com/v3/company/{companyId}/invoice/{id}
    authentication: Bearer {access_token}
    
    ca_policy_impact:
      - No MFA prompt (uses stored token)
      - Not subject to session timeout
      - If token expires, auto-refresh (no user prompt)

security_recommendations:
  - Store tokens in Azure Key Vault
  - Use encrypted connection strings
  - Rotate refresh tokens every 90 days
  - Log all API calls
```

---

## 🔐 **Dynamics 365 Business Central Integration Setup**

### **Step 1: Create App Registration**

```powershell
# 1. Create Azure AD app registration
Connect-MgGraph -Scopes "Application.ReadWrite.All"

$app = New-MgApplication -DisplayName "Dynamics 365 BC API" `
  -SignInAudience "AzureADMyOrg" `
  -RequiredResourceAccess @(
    @{
      ResourceAppId = "00000003-0000-0000-c000-000000000000"  # Microsoft Graph
      ResourceAccess = @(
        @{
          Id = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"  # User.Read
          Type = "Scope"
        }
      )
    }
  )

# 2. Note Application (client) ID and Tenant ID
$app.AppId  # Save this!
Get-MgOrganization | Select-Object -ExpandProperty Id  # Tenant ID

# 3. Create client secret
$secret = Add-MgApplicationPassword -ApplicationId $app.Id `
  -PasswordCredential @{ DisplayName = "D365 BC API Secret" }

$secret.SecretText  # Save this immediately!

# 4. Grant API permissions (admin consent)
# Azure Portal → App Registrations → Your app → API permissions
# Add: Dynamics 365 Business Central → Financials.ReadWrite.All
# Click "Grant admin consent"

# 5. Add to D365 Business Central
# Business Central → Users → New → App user
# Add your service principal (App ID)

# 6. Exclude from CA policy
# Entra admin center → CA policy → Exclude: <App ID>
```

---

### **Step 2: API Authentication**

```powershell
# Get access token for D365 BC API
$tenantId = "your-tenant-id"
$clientId = "your-app-id"
$clientSecret = "your-client-secret"

$body = @{
  grant_type = "client_credentials"
  client_id = $clientId
  client_secret = $clientSecret
  scope = "https://api.businesscentral.dynamics.com/.default"
}

$tokenResponse = Invoke-RestMethod -Method Post `
  -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" `
  -Body $body

$accessToken = $tokenResponse.access_token

# Use token to call D365 BC API
$headers = @{
  Authorization = "Bearer $accessToken"
  "Content-Type" = "application/json"
}

$apiUrl = "https://api.businesscentral.dynamics.com/v2.0/$tenantId/production/api/v2.0/companies"
$companies = Invoke-RestMethod -Method Get -Uri $apiUrl -Headers $headers

$companies.value | Format-Table -Property id, name
```

**CA Policy Impact:** Service principal authentication bypasses user CA policies!

---

## 📊 **Monitoring & Maintenance**

### **Weekly Tasks (10 minutes)**

```powershell
# 1. Review CA insights
# Entra admin center → Protection → CA → Insights and reporting

# 2. Check blocked sign-ins
Get-MgAuditLogSignIn -Filter "conditionalAccessStatus eq 'failure'" -Top 100 |
  Select-Object UserPrincipalName, CreatedDateTime, Status, ConditionalAccessStatus |
  Format-Table -AutoSize

# 3. Review risk detections
Get-MgRiskDetection -Top 50 |
  Where-Object { $_.RiskState -eq "atRisk" } |
  Select-Object UserDisplayName, RiskType, RiskLevel, DetectedDateTime |
  Format-Table -AutoSize

# 4. Check QuickBooks/D365 API logs
# (Application-specific logging)
```

---

### **Monthly Tasks (30 minutes)**

```powershell
# 1. Export CA policy (version control)
$policy = Get-MgIdentityConditionalAccessPolicy -Filter "displayName eq 'Solo CPA Firm - Client Collaboration & Accounting Software'"
$policy | ConvertTo-Json -Depth 10 | Out-File "CA-Policy-SoloCPA-$(Get-Date -Format 'yyyyMM').json"

# 2. Review MFA enrollment
Get-MgReportAuthenticationMethodUserRegistrationDetail -All |
  Select-Object UserPrincipalName, IsMfaRegistered, MethodsRegistered |
  Export-Csv "MFA-Enrollment-$(Get-Date -Format 'yyyyMM').csv"

# 3. Review device compliance
# Intune admin center → Devices → Compliance
# Export report → Save for records

# 4. Check session timeouts (are 8 hours still appropriate?)
# Review sign-in logs for session lifetime patterns
```

---

### **Quarterly Tasks (1 hour)**

```yaml
tasks:
  - Review entire CA policy (still appropriate?)
  - Update Terms of Use (if needed)
  - Rotate QuickBooks/D365 secrets
  - Audit client B2B access (who still needs access?)
  - Review compliance requirements (any changes?)
  - Update documentation (this guide!)

deliverables:
  - Updated CA policy (if changes)
  - Client access review report
  - Secret rotation log
  - Compliance attestation
```

---

## 🚨 **Troubleshooting Common Issues**

### **Issue 1: "You're Locked Out!"**

```yaml
symptom: "I can't sign in from my laptop"

diagnosis:
  1. Check device compliance: Intune admin center → Devices → Your device
  2. Check sign-in logs: Entra admin center → Sign-in logs → Filter: Your UPN
  3. Check risk detections: Identity Protection → Risk detections

solutions:
  a_device_not_compliant:
    - Enroll device in Intune (Settings → Accounts → Access work or school)
    - Wait 15 minutes for compliance check
    - Try signing in again
  
  b_sign_in_risk_detected:
    - Dismiss risk: Identity Protection → Risky users → Your account → Dismiss
    - Change password if legitimate risk
  
  c_emergency_access:
    - Use break-glass account temporarily
    - Fix issue with main account
    - Switch back to main account
```

---

### **Issue 2: "Client Can't Sign In"**

```yaml
symptom: "Client CFO says they're blocked"

diagnosis:
  1. Check their sign-in logs
  2. Ask: Did they set up MFA? (common issue!)
  3. Check: Did they accept Terms of Use?

solutions:
  a_mfa_not_set_up:
    - Help client set up MFA in THEIR tenant
    - They need MFA in their organization's M365
    - Guide: https://support.microsoft.com/mfa-setup
  
  b_terms_of_use_not_accepted:
    - Client must accept ToU during first sign-in
    - Check: Entra admin center → Terms of use → Acceptances
  
  c_device_compliance_issue:
    - Your policy may require compliant device
    - Client's device not managed by you (expected!)
    - Solution: Adjust policy to NOT require compliance for guests
```

---

### **Issue 3: "QuickBooks OAuth Fails"**

```yaml
symptom: "Can't authorize QuickBooks connection"

diagnosis:
  1. Check: Is QBO app registration excluded from CA policy?
  2. Check: Browser console errors during OAuth flow
  3. Check: QBO developer dashboard for errors

solutions:
  a_ca_policy_blocking:
    - Ensure QBO service principal excluded
    - Try OAuth flow in private/incognito browser
    - Use personal device (not subject to CA policy) temporarily
  
  b_qbo_app_misconfigured:
    - Verify redirect URI matches in QBO app settings
    - Check client ID and secret are correct
    - Regenerate secret if needed (QBO developer portal)
```

---

### **Issue 4: "D365 BC API Returns 401 Unauthorized"**

```yaml
symptom: "D365 Business Central API calls failing"

diagnosis:
  1. Check: Is access token valid? (not expired)
  2. Check: Is service principal added to D365 BC users?
  3. Check: Are API permissions granted?

solutions:
  a_token_expired:
    - Refresh access token (lifetime: 1 hour)
    - Implement auto-refresh logic in your app
  
  b_service_principal_not_added:
    - D365 BC → Users → New → App user
    - Add your Azure AD app registration
    - Assign permissions (Financials.ReadWrite.All)
  
  c_permissions_not_granted:
    - Azure Portal → App Registrations → Your app
    - API permissions → Grant admin consent
    - Wait 5 minutes for propagation
```

---

## 📞 **Support Resources**

| Question | Resource |
|----------|----------|
| **"How do I deploy this?"** | This guide (you're reading it!) |
| **"QuickBooks OAuth help"** | [QBO Developer Docs](https://developer.intuit.com/app/developer/qbo/docs/get-started) |
| **"D365 BC API help"** | [D365 BC API Docs](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/api-reference/v2.0/) |
| **"E5 features explained"** | [E5 Optimization Guide](../e5-optimization-guide.md) |
| **"Validation before deploy"** | Run `pwsh validate-cpa-tenant-e5.ps1` |

---

## 🎯 **Next Steps**

```sh
# 1. Read this guide (you're here!)
# 2. Run validation script
   pwsh validate-cpa-tenant-e5.ps1

# 3. Deploy Phase 1 (report-only)
   # Entra admin center → New CA policy
   # Use conditional-access-solo-cpa-custom.yaml as guide
   # Set state: "Report-only"

# 4. Monitor for 1-2 weeks
   # Daily: Check sign-in logs (5 min)

# 5. Deploy Phase 2 (your account only)
   # Change state: "On"
   # Include: Just you
   # Monitor for 1 week

# 6. Deploy Phase 3 (all users)
   # Include: You + all guests
   # Notify clients
   # Monitor closely for first week

# 7. Ongoing maintenance
   # Weekly: CA insights review (10 min)
   # Monthly: Export policy, check MFA enrollment (30 min)
   # Quarterly: Full policy review (1 hour)
```

---

<p align="center">
  <strong>You're Ready to Deploy! 🚀</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Solo_CPA-Custom_Policy-success" alt="Custom Policy">
  <img src="https://img.shields.io/badge/Testing-Playground_Ready-blue" alt="Testing Ready">
  <img src="https://img.shields.io/badge/QuickBooks-Integrated-2CA01C" alt="QuickBooks">
  <img src="https://img.shields.io/badge/Dynamics_365-Integrated-0078D4" alt="Dynamics 365">
</p>
