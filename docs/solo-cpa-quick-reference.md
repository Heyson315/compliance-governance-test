# 🎯 Solo CPA Quick Reference Card
**Testing Playground + Real Client Work**

---

## ⚡ **Run Validation (Do This First!)**

```powershell
cd E:\source\Heyson315\compliance-governance-test
pwsh validate-cpa-tenant-e5.ps1
```

**Expected Time:** 5-10 minutes  
**What It Checks:** E5 licenses, CA policies, integrations readiness

---

## 🏢 **Your Setup**

```yaml
Firm: Solo CPA Practitioner
License: Microsoft 365 E5 ($57/month)
Users: 1 (you!)
Purpose: Testing + Real client collaboration

Accounting Software:
├── QuickBooks Online (primary)
├── Dynamics 365 Business Central (optional)
└── Others: Xero, Bill.com, Avalara

Client Collaboration:
├── B2B guests (client CFOs, controllers)
├── Cross-tenant access (trust their MFA)
└── Time-limited access (engagement duration)
```

---

## ✅ **Validation Checklist**

### **1. PowerShell & Modules**
- [ ] PowerShell 7+ installed
- [ ] Microsoft.Graph modules installed
- [ ] Connected to your tenant

### **2. E5 Licensing**
- [ ] E5 license assigned to you
- [ ] Identity Protection enabled
- [ ] Intune available
- [ ] MFA Premium active

### **3. Security Policies**
- [ ] Conditional Access policies deployed
- [ ] External user policies configured
- [ ] Device compliance (your laptop)
- [ ] Emergency access (break-glass account)

### **4. Client Collaboration**
- [ ] Cross-tenant access configured
- [ ] MFA trust settings enabled
- [ ] Client folders separated
- [ ] Audit logging active (7-year retention)

### **5. QuickBooks Integration**
- [ ] QBO Developer account created
- [ ] OAuth 2.0 app registered
- [ ] Client ID & Secret obtained
- [ ] Sandbox company for testing
- [ ] API scopes requested

### **6. Dynamics 365 BC** (optional)
- [ ] Azure AD app registration
- [ ] D365 BC license (Essentials/Premium)
- [ ] API permissions granted
- [ ] Service principal added to D365
- [ ] Web services published

---

## 🧪 **Testing Scenarios**

### **Scenario 1: You Working Solo**
```powershell
# YOUR laptop → Full access ✅
# YOUR phone → Email only ✅
# Friend's laptop → BLOCKED ❌
```

### **Scenario 2: Client Collaboration**
```powershell
# Invite client CFO as B2B guest
# Client logs in → MFA required ✅
# Client accesses THEIR folder → Allowed ✅
# Client accesses OTHER client → BLOCKED ❌
# Session timeout → 4 hours ✅
```

### **Scenario 3: QuickBooks API**
```powershell
# Client authorizes QBO connection
# Your app reads invoices, expenses
# Data syncs to Excel/Power BI
# Generate reports for client
```

---

## 📊 **QuickBooks Online API Quick Start**

```sh
# 1. Create developer account (free)
https://developer.intuit.com/

# 2. Create sandbox company
Dashboard → Sandbox → Create company

# 3. Create app
Dashboard → Create an app → QuickBooks Online

# 4. Get credentials
App settings → Keys & OAuth → Copy Client ID & Secret

# 5. Test API
GET https://sandbox-quickbooks.api.intuit.com/v3/company/{companyId}/invoice/{id}
Authorization: Bearer {access_token}
```

**Required Scopes:**
- `com.intuit.quickbooks.accounting` (read/write)
- `openid`, `email`, `profile` (user info)

---

## 📊 **Dynamics 365 BC API Quick Start**

```sh
# 1. Azure AD app registration
Azure Portal → App Registrations → New → Register

# 2. Grant API permissions
API permissions → Add → Dynamics 365 Business Central
→ Delegated: Financials.ReadWrite.All
→ Grant admin consent

# 3. Add to D365 BC
Business Central → Users → New → App user
→ Add your app's service principal

# 4. Test API
GET https://api.businesscentral.dynamics.com/v2.0/{tenantId}/{environment}/api/v2.0/companies
Authorization: Bearer {access_token}
```

---

## 🚀 **5-Day Testing Plan**

### **Day 1: Validation**
```powershell
pwsh validate-cpa-tenant-e5.ps1
# Fix any CRITICAL issues
```

### **Day 2: Deploy CA Policy**
```yaml
# Customize: docs/policies/conditional-access-mfa-external-e5-enhanced.yaml
# Deploy in report-only mode
# Monitor for 1 week
```

### **Day 3: QuickBooks Setup**
```sh
# Create QBO developer account
# Create sandbox company
# Test OAuth flow
# Read sample invoice
```

### **Day 4: Client Collaboration**
```sh
# Invite yourself as B2B guest (personal email)
# Test access to folder
# Verify MFA enforced
# Check audit logs
```

### **Day 5: Document & Plan**
```sh
# Review all results
# Document setup (for yourself!)
# Create client onboarding checklist
# Plan next integrations
```

---

## 💰 **Monthly Cost Breakdown**

| Item | Cost | Notes |
|------|------|-------|
| **Microsoft 365 E5** | $57/month | Just you (1 license) |
| **QBO Developer** | $0 | Sandbox forever free |
| **D365 BC Trial** | $0 | 30 days free |
| **Azure Key Vault** | ~$1/month | For API secrets |
| **Total** | **~$60/month** | All-in cost |

**Client Billing:**
- Advisory services (hourly/project)
- Optional technology fee
- Pass through API costs (if any)

---

## 🔧 **Common Commands**

```powershell
# Run validation (full)
pwsh validate-cpa-tenant-e5.ps1

# Run validation (QuickBooks only)
pwsh validate-cpa-tenant-e5.ps1 -IncludeQuickBooks

# Run validation (D365 only)
pwsh validate-cpa-tenant-e5.ps1 -IncludeDynamics365

# Run validation (detailed report)
pwsh validate-cpa-tenant-e5.ps1 -DetailedReport

# Check workspace health
pwsh workspace-health-check.ps1

# Set up GitHub remote
pwsh setup-github-remote.ps1
```

---

## ⚠️ **CPA Firm Compliance**

### **AICPA Requirements:**
- ✅ Client confidentiality (Section 1.700)
- ✅ Data protection (encryption at rest/transit)
- ✅ MFA enforcement (all users)
- ✅ Audit logging (7-year retention)

### **IRS Requirements:**
- ✅ 7-year data retention
- ✅ Secure storage (encrypted)
- ✅ Access controls (least privilege)
- ✅ Audit trail (who accessed what, when)

### **State Board Requirements:**
- Check your state's data protection rules
- Most require encryption + MFA
- Some require cyber insurance

---

## 📞 **Quick Support**

| Issue | Resource |
|-------|----------|
| **Validation fails** | Run with `-Verbose` flag |
| **QBO API errors** | [QBO Developer Docs](https://developer.intuit.com/app/developer/qbo/docs/api/accounting/most-commonly-used/invoice) |
| **D365 BC errors** | [D365 BC API Docs](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/api-reference/v2.0/) |
| **E5 features** | [E5 Optimization Guide](e5-optimization-guide.md) |
| **General help** | [Solo CPA Testing Guide](solo-cpa-testing-guide.md) |

---

## 🎯 **Success Criteria**

You're done when:
- [ ] Validation script passes (0 CRITICAL issues)
- [ ] E5 CA policy deployed (report-only first)
- [ ] QuickBooks sandbox connection works
- [ ] Client collaboration tested (B2B guest)
- [ ] Audit logs verified (7-year retention)
- [ ] Documentation complete (for yourself!)

---

## 🎉 **Next Steps**

```sh
# 1. Run validation RIGHT NOW
pwsh validate-cpa-tenant-e5.ps1

# 2. Fix any issues
# 3. Deploy E5 policy
# 4. Set up QBO developer account
# 5. Test client collaboration
# 6. Document everything
# 7. Use with real clients! 🚀
```

---

<p align="center">
  <strong>Happy Testing! 📊</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Solo_CPA-Ready-success" alt="Solo CPA Ready">
  <img src="https://img.shields.io/badge/E5-Optimized-0078D4" alt="E5 Optimized">
  <img src="https://img.shields.io/badge/QuickBooks-Integrated-2CA01C" alt="QuickBooks">
</p>
