# 📊 Compliance Quick Reference
**Audit Evidence Collection Cheat Sheet**

---

## ⚡ **Most Common Audit Requests**

### **1. "Show me your access control policies"**
```powershell
# Export all Conditional Access policies
Connect-MgGraph -Scopes "Policy.Read.All"
$policies = Get-MgIdentityConditionalAccessPolicy -All
$policies | ConvertTo-Json -Depth 10 | Out-File "CA-Policies-$(Get-Date -Format 'yyyyMMdd').json"
```
**Evidence File:** `CA-Policies-20250118.json`  
**Satisfies:** SOX (AC-2), GDPR (Art 32), HIPAA (164.312(a)(1)), NIST (AC-3)

---

### **2. "Prove MFA is enforced"**
```powershell
# Export MFA sign-in logs (last 30 days)
$startDate = (Get-Date).AddDays(-30)
$logs = Get-MgAuditLogSignIn -Filter "createdDateTime ge $($startDate.ToString('yyyy-MM-dd'))" -Top 5000
$logs | Where-Object { $_.AuthenticationRequirement -eq 'multiFactorAuthentication' } | 
  Select-Object UserPrincipalName, CreatedDateTime, Status, ConditionalAccessStatus |
  Export-Csv "MFA-Logs-$(Get-Date -Format 'yyyyMMdd').csv"
```
**Evidence File:** `MFA-Logs-20250118.csv`  
**Satisfies:** SOX (IA-2), GDPR (Art 32), HIPAA (164.312(a)(2)(ii)), NIST (IA-2(1))

---

### **3. "Show me audit logs and retention policy"**
```powershell
# Export audit logs (last 90 days for GDPR compliance)
$startDate = (Get-Date).AddDays(-90).ToString("yyyy-MM-dd")
$endDate = (Get-Date).ToString("yyyy-MM-dd")
Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -ResultSize 5000 |
  Export-Csv "AuditLogs-90days-$(Get-Date -Format 'yyyyMMdd').csv"

# Check retention policy
Get-RetentionCompliancePolicy | 
  Select-Object Name, Enabled, RetentionDuration, RetentionType |
  Format-Table -AutoSize
```
**Evidence Files:**
- `AuditLogs-90days-20250118.csv`
- Screenshot of retention policy (7 years for SOX)

**Satisfies:** SOX (AU-2, AU-11), GDPR (Art 5), HIPAA (164.312(b)), NIST (AU-2)

---

### **4. "Demonstrate user access reviews"**
```powershell
# Export access review results
Connect-MgGraph -Scopes "AccessReview.Read.All"
$reviews = Get-MgIdentityGovernanceAccessReview -All
$reviews | Select-Object DisplayName, Status, CreatedDateTime, Decisions | 
  Export-Csv "AccessReviews-$(Get-Date -Format 'yyyyMMdd').csv"
```
**Evidence File:** `AccessReviews-20250118.csv`  
**Satisfies:** SOX (AC-2(7)), GDPR (Art 15), HIPAA (164.308(a)(4)), NIST (AC-2(7))

---

### **5. "Show encryption is enabled"**
```yaml
# M365 E5 Default Encryption (no script needed)
at_rest:
  encryption: AES-256
  key_management: Microsoft-managed (default)
  validation: M365 Security Center → Encryption report

in_transit:
  encryption: TLS 1.2+
  validation: SSL Labs test (https://www.ssllabs.com/ssltest/)
  
evidence:
  - M365 Security Center screenshot
  - SSL Labs report (A+ rating)
```
**Satisfies:** SOX (SC-13), GDPR (Art 32), HIPAA (164.312(e)(1)), NIST (SC-8)

---

## 📋 **Compliance Mapping Cheat Sheet**

| Your Template | SOX | GDPR | HIPAA | NIST | AICPA |
|---------------|-----|------|-------|------|-------|
| **conditional-access-mfa-external-e5-enhanced.yaml** |
| Lines 20-21 (user scope) | AC-2 | Art 32 | 164.308(a)(4) | AC-2 | 1.700.001 |
| Line 62 (MFA) | IA-2(1) | Art 32 | 164.312(a)(2)(ii) | IA-2(1) | N/A |
| Lines 64-65 (device compliance) | SC-7 | Art 32 | 164.310(d) | SC-7 | N/A |
| Lines 80-85 (session timeout) | SC-10 | Art 32 | 164.312(a)(2)(iii) | AC-12 | N/A |
| **partner-tenant-config.yaml** |
| Lines 25-32 (allowed users) | AC-6 | Art 32 | 164.308(a)(3) | AC-3 | 1.700.050 |
| Lines 95-101 (MFA trust) | IA-2(1) | Art 32 | 164.312(d) | IA-2(1) | N/A |
| **source-to-target.yaml** |
| Lines 30-45 (scope) | AC-2 | Art 5(c) | 164.308(a)(3) | AC-2 | 1.700.050 |
| Lines 120-135 (auto-deprovision) | AC-2(7) | Art 17 | 164.308(a)(3)(ii)(C) | AC-2(3) | 1.700.100 |

---

## 🎯 **Top 5 Evidence Files for Audits**

| File | How to Generate | Frequency | Auditor Wants This For |
|------|----------------|-----------|------------------------|
| **1. CA-Policies.json** | `Get-MgIdentityConditionalAccessPolicy` | Quarterly | Access control policies |
| **2. MFA-Logs.csv** | `Get-MgAuditLogSignIn` | Monthly | MFA enforcement proof |
| **3. AuditLogs-90days.csv** | `Search-UnifiedAuditLog` | Quarterly | Audit trail completeness |
| **4. AccessReviews.csv** | `Get-MgIdentityGovernanceAccessReview` | Quarterly | User access reviews |
| **5. DeviceCompliance.pdf** | Intune admin center → Reports | Quarterly | Device security |

---

## 📊 **Audit Response Templates (Copy-Paste Ready)**

### **SOX: User Access Management**
```
Control Objective: Ensure only authorized users access financial systems.

Implementation:
- Conditional Access policy enforces MFA (see CA-Policies.json)
- External users limited to specific apps (SharePoint, Teams)
- Device compliance required (Intune)
- 4-hour session timeout

Evidence Attached:
1. CA-Policies-20250118.json
2. MFA-Logs-20250118.csv
3. DeviceCompliance-Q1-2025.pdf

Testing: 25 sample sign-ins (last 30 days), 0 exceptions.
Result: Control operating effectively.
```

---

### **GDPR: Right to Erasure**
```
Requirement: Delete user data upon request (Article 17).

Implementation:
- User removed from sync scope → auto-deprovision within 24 hours
- 30-day soft delete period
- Permanent deletion after 30 days
- Manual deletion via M365 DSR tool (if immediate)

Evidence Attached:
1. Deprovision-Logs-Q1-2025.csv
2. DSR-Handling-Procedure.pdf

Testing: 5 test deletions, average time 18 hours.
Result: Compliant with 72-hour requirement.
```

---

### **HIPAA: Encryption**
```
Standard: 164.312(e)(1) - Transmission Security

Implementation:
- TLS 1.2+ enforced (M365 default)
- AES-256 encryption at rest (M365 default)
- No unencrypted transmission allowed

Evidence Attached:
1. SSL-Labs-Report-A+.pdf
2. M365-Encryption-Validation.pdf

Testing: SSL Labs scan (A+ rating), M365 encryption report.
Result: Compliant.
```

---

## 🚨 **Emergency Audit Prep (Last-Minute)**

```powershell
# Run this script if auditor shows up unexpectedly!

# 1. Export CA policies
Get-MgIdentityConditionalAccessPolicy -All | ConvertTo-Json -Depth 10 > "CA-Policies.json"

# 2. Export MFA logs (last 30 days)
$start = (Get-Date).AddDays(-30).ToString("yyyy-MM-dd")
Get-MgAuditLogSignIn -Filter "createdDateTime ge $start" -Top 5000 | 
  Where-Object { $_.AuthenticationRequirement -eq 'multiFactorAuthentication' } |
  Export-Csv "MFA-Logs.csv"

# 3. Export audit logs (last 90 days)
$start = (Get-Date).AddDays(-90).ToString("yyyy-MM-dd")
Search-UnifiedAuditLog -StartDate $start -EndDate (Get-Date).ToString("yyyy-MM-dd") -ResultSize 5000 |
  Export-Csv "AuditLogs-90days.csv"

# 4. Export user list
Get-MgUser -All -Property "DisplayName,UserPrincipalName,AccountEnabled" |
  Select-Object DisplayName, UserPrincipalName, AccountEnabled |
  Export-Csv "UserList.csv"

# 5. Export access reviews
Get-MgIdentityGovernanceAccessReview -All | 
  Select-Object DisplayName, Status, CreatedDateTime |
  Export-Csv "AccessReviews.csv"

Write-Host "✅ Emergency evidence package created!" -ForegroundColor Green
Write-Host "Files:" -ForegroundColor Cyan
Get-ChildItem *.json, *.csv | Select-Object Name, Length, LastWriteTime | Format-Table
```

---

## 💰 **Compliance Cost Breakdown**

| Item | Cost | Notes |
|------|------|-------|
| **Microsoft 365 E5** | $57/user/month | Includes all features (Identity Protection, Intune, audit logs) |
| **Compliance automation** | $0 | Included in E5 (M365 Compliance Center) |
| **Audit log retention (7 years)** | $0 | Included in E5 |
| **Access reviews** | $0 | Included in E5 (Entra ID Governance) |
| **SOC 2 audit (external auditor)** | $10,000-$50,000 | Optional (if seeking certification) |
| **Total (self-managed)** | **$57/user/month** | No additional compliance costs |

---

## 📞 **Quick Support**

| Question | Answer |
|----------|--------|
| **"Where's the full compliance doc?"** | [COMPLIANCE-MAPPING.md](COMPLIANCE-MAPPING.md) |
| **"How do I run validation?"** | `pwsh validate-cpa-tenant-e5.ps1` |
| **"I need SOC 2 certification"** | See [COMPLIANCE-MAPPING.md Section 8.2](#) |
| **"What's my gap analysis?"** | [COMPLIANCE-MAPPING.md Section 7](#) |
| **"State board requirements?"** | [COMPLIANCE-MAPPING.md Section 10](#) |

---

<p align="center">
  <strong>Audit-Ready in Minutes! 📊</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/SOX-✅-success" alt="SOX">
  <img src="https://img.shields.io/badge/GDPR-✅-success" alt="GDPR">
  <img src="https://img.shields.io/badge/HIPAA-✅-success" alt="HIPAA">
  <img src="https://img.shields.io/badge/SOC_2-Ready-blue" alt="SOC 2">
</p>
