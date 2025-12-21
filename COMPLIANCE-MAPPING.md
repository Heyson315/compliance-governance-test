# Compliance Mapping Document
# SOX | GDPR | HIPAA | NIST 800-53 | AICPA

![Compliance](https://img.shields.io/badge/Compliance-SOX%20%7C%20GDPR%20%7C%20HIPAA%20%7C%20NIST-orange?logo=checkmarx)
![SOC 2](https://img.shields.io/badge/SOC_2-Type_II_Ready-success?logo=microsoftazure)
![AICPA](https://img.shields.io/badge/AICPA-Section_1.700-blue?logo=microsoft)

---

## 📋 **Executive Summary**

This document maps the **E5 cross-tenant collaboration templates** in this repository to specific compliance requirements for:

| Framework | Applicability | Coverage |
|-----------|--------------|----------|
| **SOX (Sarbanes-Oxley)** | Public company audits | Access controls, audit trails |
| **GDPR (EU Data Protection)** | EU citizen data | Consent, data minimization, rights |
| **HIPAA (Healthcare)** | Protected Health Information | Encryption, access controls, BAA |
| **NIST 800-53** | Federal/Government | Security controls catalog |
| **AICPA Section 1.700** | CPA firm confidentiality | Client data protection |
| **SOC 2 Type II** | Service organizations | Trust services criteria |
| **SSAE 18** | Audit standards | Service organization controls |

---

## 🎯 **How to Use This Document**

### **For Auditors:**
- Section 3 shows control mapping to your workspace templates
- Section 4 provides evidence collection points
- Section 5 includes sample audit responses

### **For Compliance Teams:**
- Section 2 provides framework overviews
- Section 6 includes compliance checklists
- Section 7 shows gap analysis

### **For CPA Firms:**
- Section 8 covers AICPA-specific requirements
- Section 9 includes client confidentiality controls
- Section 10 provides state board compliance

---

## 📊 **Table of Contents**

1. [Compliance Frameworks Overview](#1-compliance-frameworks-overview)
2. [Control Matrix](#2-control-matrix)
3. [Template-to-Requirement Mapping](#3-template-to-requirement-mapping)
4. [Evidence Collection Points](#4-evidence-collection-points)
5. [Audit Response Templates](#5-audit-response-templates)
6. [Compliance Checklists](#6-compliance-checklists)
7. [Gap Analysis](#7-gap-analysis)
8. [AICPA Specific Requirements](#8-aicpa-specific-requirements)
9. [Client Confidentiality Controls](#9-client-confidentiality-controls)
10. [State Board Compliance](#10-state-board-compliance)

---

## 1. **Compliance Frameworks Overview**

### **1.1 SOX (Sarbanes-Oxley Act)**

```yaml
regulation: Sarbanes-Oxley Act of 2002
applies_to: Public companies and their auditors
key_requirements:
  - Section 302: Officer certification of financial reports
  - Section 404: Internal controls over financial reporting
  - Section 409: Real-time disclosure of material changes
  
relevant_controls:
  - Access Controls (AC)
  - Audit and Accountability (AU)
  - Identification and Authentication (IA)
  - System and Communications Protection (SC)

sox_it_general_controls:
  - User access management
  - Change management
  - Computer operations
  - Program development
  - Data backup and recovery
```

**Your Templates Cover:**
- ✅ User access management → CA policies, cross-tenant access
- ✅ Audit trails → Microsoft 365 audit logs (7-year retention)
- ✅ Segregation of duties → Role-based access controls
- ✅ MFA enforcement → CA policies

---

### **1.2 GDPR (General Data Protection Regulation)**

```yaml
regulation: EU General Data Protection Regulation
applies_to: Organizations processing EU citizen data
key_requirements:
  - Article 5: Principles (lawfulness, fairness, transparency)
  - Article 6: Lawful basis for processing
  - Article 7: Conditions for consent
  - Article 15: Right of access
  - Article 17: Right to erasure
  - Article 32: Security of processing
  - Article 33: Data breach notification (72 hours)

relevant_controls:
  - Consent management
  - Data subject rights
  - Data minimization
  - Encryption
  - Breach notification
```

**Your Templates Cover:**
- ✅ Consent → Terms of Use in CA policy
- ✅ Encryption → M365 default (at rest/transit)
- ✅ Access controls → CA policies, cross-tenant access
- ✅ Data minimization → Time-limited B2B access
- ✅ Right to erasure → Auto-deprovision in sync config

---

### **1.3 HIPAA (Health Insurance Portability and Accountability Act)**

```yaml
regulation: HIPAA Privacy and Security Rules
applies_to: Healthcare providers, insurers, clearinghouses
key_requirements:
  - Administrative Safeguards: Risk analysis, workforce training
  - Physical Safeguards: Facility access, workstation security
  - Technical Safeguards: Access controls, encryption, audit logs
  - Business Associate Agreements (BAA)

relevant_controls:
  - Encryption (both at rest and in transit)
  - Access controls (least privilege)
  - Audit logging (who accessed what, when)
  - Device security (compliant devices only)
```

**Your Templates Cover:**
- ✅ Encryption → M365 E5 default
- ✅ Access controls → CA policies (MFA, device compliance)
- ✅ Audit logs → M365 audit logs (tamper-proof)
- ✅ Device compliance → Intune policies
- ✅ BAA → Microsoft provides HIPAA BAA for E5

---

### **1.4 NIST 800-53 (Security and Privacy Controls)**

```yaml
standard: NIST Special Publication 800-53 Rev 5
applies_to: Federal agencies, government contractors
control_families:
  - AC: Access Control
  - AU: Audit and Accountability
  - IA: Identification and Authentication
  - SC: System and Communications Protection
  - SI: System and Information Integrity

nist_control_count: 1,000+ controls across 20 families
```

**Your Templates Cover (Sample):**
- ✅ AC-2: Account Management → Cross-tenant access, B2B lifecycle
- ✅ AC-7: Unsuccessful Logon Attempts → Identity Protection risk policies
- ✅ AU-2: Audit Events → M365 audit logs
- ✅ IA-2: Identification and Authentication → MFA via CA policies
- ✅ SC-8: Transmission Confidentiality → TLS 1.2+ enforced

---

### **1.5 AICPA Section 1.700 (Confidential Client Information)**

```yaml
standard: AICPA Code of Professional Conduct
applies_to: CPAs and CPA firms
key_requirements:
  - 1.700.001: Definition of confidential client information
  - 1.700.050: Use of information
  - 1.700.070: Disclosure with consent
  - 1.700.100: Disclosure without consent (limited exceptions)

cpa_firm_obligations:
  - Protect client confidentiality
  - Secure storage of client data
  - Authorized access only
  - 7-year retention (IRS requirement)
```

**Your Templates Cover:**
- ✅ Client data segregation → SharePoint permissions
- ✅ Access controls → CA policies (least privilege)
- ✅ Encryption → M365 default
- ✅ Audit trails → Who accessed what client data
- ✅ Retention → M365 audit logs (7+ years)

---

## 2. **Control Matrix**

### **2.1 SOX IT General Controls (ITGC)**

| SOX Control | NIST Control | Your Template | Line # | Evidence Location |
|-------------|--------------|---------------|--------|-------------------|
| **User Access Management** |
| Unique user IDs | AC-2 | conditional-access-mfa-external-e5-enhanced.yaml | 20-21 | Entra ID user list |
| MFA required | IA-2(1) | conditional-access-mfa-external-e5-enhanced.yaml | 62 | CA policy JSON export |
| Least privilege | AC-6 | partner-tenant-config.yaml | 25-32 | Cross-tenant access settings |
| Periodic access reviews | AC-2(7) | source-to-target.yaml | 120-135 | Access review reports |
| **Audit and Accountability** |
| Audit log generation | AU-2 | All templates (M365 default) | N/A | M365 audit logs |
| Audit log protection | AU-9 | M365 default (tamper-proof) | N/A | M365 compliance center |
| 7-year retention | AU-11 | M365 retention policies | N/A | Retention policy config |
| **Change Management** |
| Policy version control | CM-3 | All YAML templates | metadata section | Git commit history |
| Approval workflow | CM-3(2) | CONTRIBUTING.md | 140-160 | GitHub PR approvals |
| Rollback procedures | CP-10 | conditional-access-mfa-external-e5-enhanced.yaml | 183-187 | Documented in YAML |

---

### **2.2 GDPR Data Protection Controls**

| GDPR Article | Requirement | Your Template | Implementation | Evidence |
|--------------|-------------|---------------|----------------|----------|
| **Article 7: Consent** |
| Valid consent | Freely given, specific, informed | conditional-access-mfa-external-e5-enhanced.yaml | Line 68-70: Terms of Use | ToU acceptance logs |
| Withdraw consent | Easy as giving consent | source-to-target.yaml | Line 120-135: Auto-deprovision | Deprovision logs |
| **Article 15: Right of Access** |
| Subject access requests | Provide copy of data | M365 DSR tools | Content search | DSR response logs |
| **Article 17: Right to Erasure** |
| Delete on request | Unless legal obligation | source-to-target.yaml | Line 125-130: Lifecycle management | Deletion audit logs |
| **Article 32: Security** |
| Encryption at rest | Protect against breach | M365 E5 default | AES-256 | Encryption validation |
| Encryption in transit | Secure transmission | M365 E5 default | TLS 1.2+ | TLS inspection logs |
| MFA | Strong authentication | conditional-access-mfa-external-e5-enhanced.yaml | Line 62 | MFA sign-in logs |
| Device compliance | Managed devices only | conditional-access-mfa-external-e5-enhanced.yaml | Line 64-65 | Intune compliance reports |
| **Article 33: Breach Notification** |
| 72-hour notification | Detect and report | M365 Security Center | Incident detection | Breach notification logs |

---

### **2.3 HIPAA Security Rule Controls**

| HIPAA Standard | Requirement | Implementation | Evidence |
|----------------|-------------|----------------|----------|
| **Administrative Safeguards** |
| 164.308(a)(1)(ii)(A) | Risk Analysis | validate-cpa-tenant-e5.ps1 | Validation reports |
| 164.308(a)(3)(i) | Workforce Training | solo-cpa-testing-guide.md | Training documentation |
| 164.308(a)(4)(i) | Access Authorization | conditional-access-mfa-external-e5-enhanced.yaml | CA policy JSON |
| **Physical Safeguards** |
| 164.310(b) | Workstation Use | conditional-access-mfa-external-e5-enhanced.yaml (device compliance) | Intune compliance |
| 164.310(d)(1) | Device Controls | conditional-access-mfa-external-e5-enhanced.yaml (compliant device) | Intune enrollment |
| **Technical Safeguards** |
| 164.312(a)(1) | Access Control | partner-tenant-config.yaml | Cross-tenant settings |
| 164.312(a)(2)(i) | Unique User ID | Entra ID (M365 default) | User list |
| 164.312(a)(2)(iii) | Automatic Logoff | conditional-access-mfa-external-e5-enhanced.yaml (4-hour session) | Session logs |
| 164.312(b) | Audit Controls | M365 audit logs | Audit log exports |
| 164.312(c)(1) | Integrity | M365 default (tamper-proof logs) | Log validation |
| 164.312(e)(1) | Transmission Security | M365 default (TLS 1.2+) | TLS inspection |

---

## 3. **Template-to-Requirement Mapping**

### **3.1 conditional-access-mfa-external-e5-enhanced.yaml**

**File Location:** `docs/policies/conditional-access-mfa-external-e5-enhanced.yaml`

**Compliance Mappings:**

| Lines | Feature | SOX | GDPR | HIPAA | NIST | AICPA |
|-------|---------|-----|------|-------|------|-------|
| **20-21** | User scope (GuestsOrExternalUsers) | AC-2 | Art 32 | 164.308(a)(4) | AC-2 | 1.700.001 |
| **24-27** | Application scope (SharePoint, Teams) | AC-3 | Art 32 | 164.312(a)(1) | AC-3 | 1.700.050 |
| **45-51** | Risk-based conditions (sign-in/user risk) | AU-6 | Art 32 | 164.308(a)(1)(ii)(A) | SI-4 | N/A |
| **62** | MFA requirement | IA-2(1) | Art 32 | 164.312(a)(2)(ii) | IA-2(1) | N/A |
| **64-65** | Device compliance (Intune) | SC-7 | Art 32 | 164.310(d)(1) | SC-7 | N/A |
| **68-70** | Terms of Use (consent) | N/A | Art 7 | 164.508 | AC-8 | 1.700.070 |
| **80-85** | 4-hour session timeout | SC-10 | Art 32 | 164.312(a)(2)(iii) | AC-12 | N/A |
| **90-92** | Defender for Cloud Apps | AU-2 | Art 32 | 164.312(b) | AU-2 | N/A |
| **94-95** | Continuous Access Evaluation | SC-23 | Art 32 | 164.312(a)(1) | SC-23 | N/A |

**Audit Evidence to Collect:**
```powershell
# Export CA policy JSON
Get-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId <policy-id> | ConvertTo-Json -Depth 10

# Export sign-in logs (last 30 days)
Get-MgAuditLogSignIn -Filter "createdDateTime ge 2025-01-01" -Top 1000

# Export MFA registration events
Get-MgReportAuthenticationMethodUserRegistrationDetail -All
```

---

### **3.2 partner-tenant-config.yaml**

**File Location:** `docs/cross-tenant-access/partner-tenant-config.yaml`

**Compliance Mappings:**

| Lines | Feature | SOX | GDPR | HIPAA | NIST | AICPA |
|-------|---------|-----|------|-------|------|-------|
| **11-14** | Partner tenant identification | AC-2 | Art 26 | 164.308(b)(1) | AC-20 | 1.700.070 |
| **25-32** | Inbound allowed users/groups | AC-6 | Art 32 | 164.308(a)(3)(i) | AC-3 | 1.700.050 |
| **55-62** | Outbound allowed users/groups | AC-6 | Art 44 | 164.308(a)(4)(i) | AC-3 | 1.700.050 |
| **95-101** | MFA trust settings | IA-2(1) | Art 32 | 164.312(d) | IA-2(1) | N/A |
| **103-109** | Device compliance trust | SC-7 | Art 32 | 164.310(d) | SC-7 | N/A |
| **150-159** | Change history | CM-3 | Art 30 | 164.308(a)(5)(ii)(C) | CM-3 | N/A |

**Audit Evidence to Collect:**
```powershell
# Export cross-tenant access settings
Get-MgPolicyCrossTenantAccessPolicyPartner -All | ConvertTo-Json -Depth 10

# Export B2B invitation activity
Get-MgAuditLogDirectoryAudit -Filter "activityDisplayName eq 'Invite external user'" -Top 500

# Export trust settings
$partner = Get-MgPolicyCrossTenantAccessPolicyPartner -CrossTenantAccessPolicyConfigurationPartnerTenantId <tenant-id>
$partner.InboundTrust | ConvertTo-Json
```

---

### **3.3 source-to-target.yaml**

**File Location:** `docs/cross-tenant-sync/source-to-target.yaml`

**Compliance Mappings:**

| Lines | Feature | SOX | GDPR | HIPAA | NIST | AICPA |
|-------|---------|-----|------|-------|------|-------|
| **30-45** | Provisioning scope (group-based) | AC-2 | Art 5(c) | 164.308(a)(3)(i) | AC-2 | 1.700.050 |
| **55-85** | Attribute mappings (data minimization) | N/A | Art 5(c) | 164.514(b) | SI-12 | 1.700.001 |
| **120-135** | Auto-deprovision (lifecycle) | AC-2(7) | Art 17 | 164.308(a)(3)(ii)(C) | AC-2(3) | 1.700.100 |
| **145-152** | Accidental deletion prevention | CP-9 | Art 32 | 164.308(a)(7)(ii)(A) | CP-9 | N/A |
| **170-180** | Monitoring and alerts | AU-6 | Art 32 | 164.308(a)(1)(ii)(D) | AU-6 | N/A |

**Audit Evidence to Collect:**
```powershell
# Export provisioning logs
Get-MgAuditLogProvisioning -Filter "jobId eq '<sync-job-id>'" -Top 500

# Export sync statistics
$syncJob = Get-MgServicePrincipalSynchronizationJob -ServicePrincipalId <sp-id> -SynchronizationJobId <job-id>
$syncJob.Status | ConvertTo-Json

# Export accidental deletion threshold
$syncJob.Schedule.Expiration
```

---

## 4. **Evidence Collection Points**

### **4.1 For SOX Audits**

#### **Control: User Access Management**

**What Auditors Ask:**
> "How do you ensure only authorized users access financial systems?"

**Your Response:**
```yaml
template: conditional-access-mfa-external-e5-enhanced.yaml
control_location: Lines 20-21 (user scope)
implementation:
  - Conditional Access policies limit external users
  - MFA required for all access (line 62)
  - Device compliance enforced (lines 64-65)
  - 4-hour session timeout (lines 80-85)

evidence_to_provide:
  - CA policy JSON export (from Entra admin center)
  - Sample sign-in logs showing MFA enforcement
  - Quarterly access review reports
  - List of emergency access accounts (excluded from policy)

automated_collection:
  # PowerShell command to export
  script: |
    $policy = Get-MgIdentityConditionalAccessPolicy -Filter "displayName eq 'E5-Enhanced MFA & Risk Protection for External Users'"
    $policy | ConvertTo-Json -Depth 10 | Out-File "CA-Policy-$(Get-Date -Format 'yyyyMMdd').json"
```

---

#### **Control: Audit Logging**

**What Auditors Ask:**
> "Are all user activities logged? How long are logs retained?"

**Your Response:**
```yaml
logging_enabled: Yes (Microsoft 365 default)
retention_period: 7 years (configurable in M365 Compliance Center)
log_types:
  - Sign-in logs (all authentication events)
  - Audit logs (file access, sharing, policy changes)
  - Risk detection logs (Identity Protection)

evidence_to_provide:
  - M365 audit log retention policy screenshot
  - Sample audit log exports (last 30 days)
  - Log integrity validation (tamper-proof confirmation)

automated_collection:
  script: |
    # Export audit logs (last 30 days)
    $startDate = (Get-Date).AddDays(-30).ToString("yyyy-MM-dd")
    $endDate = (Get-Date).ToString("yyyy-MM-dd")
    Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -ResultSize 5000 | Export-Csv "AuditLogs-$endDate.csv"
```

---

### **4.2 For GDPR Compliance**

#### **Requirement: Article 7 (Consent)**

**What Regulators Ask:**
> "How do you obtain and document user consent?"

**Your Response:**
```yaml
template: conditional-access-mfa-external-e5-enhanced.yaml
control_location: Lines 68-70 (Terms of Use)
implementation:
  - External users must accept Terms of Use before access
  - Consent is logged and timestamped
  - Users can withdraw consent (access removed)

evidence_to_provide:
  - Terms of Use document (published in Entra)
  - Acceptance logs (from audit trail)
  - Withdrawal process documentation

automated_collection:
  script: |
    # Export Terms of Use acceptances
    $tou = Get-MgAgreement -AgreementId <tou-guid>
    $acceptances = Get-MgAgreementAcceptance -AgreementId <tou-guid> -All
    $acceptances | Export-Csv "ToU-Acceptances-$(Get-Date -Format 'yyyyMMdd').csv"
```

---

#### **Requirement: Article 17 (Right to Erasure)**

**What Regulators Ask:**
> "How do you delete user data upon request?"

**Your Response:**
```yaml
template: source-to-target.yaml
control_location: Lines 125-130 (auto-deprovision)
implementation:
  - User removed from sync scope → automatic deprovision
  - 30-day soft delete period
  - Permanent deletion after 30 days
  - Manual deletion available via DSR tool

evidence_to_provide:
  - Deprovision logs (showing user removal)
  - Data Subject Request (DSR) handling documentation
  - Deletion confirmation logs

automated_collection:
  script: |
    # Export deprovisioning events
    Get-MgAuditLogProvisioning -Filter "action eq 'Delete'" -Top 500 | 
      Select-Object -Property TargetDisplayName, ModifiedDateTime, StatusInfo |
      Export-Csv "Deprovision-Log-$(Get-Date -Format 'yyyyMMdd').csv"
```

---

### **4.3 For HIPAA Audits**

#### **Standard: 164.312(a)(2)(i) (Unique User ID)**

**What Auditors Ask:**
> "Does each user have a unique identifier?"

**Your Response:**
```yaml
implementation: Microsoft Entra ID (Azure AD) default
unique_identifier: UserPrincipalName (UPN) + Object ID (GUID)
no_shared_accounts: Enforced by policy

evidence_to_provide:
  - User list export (showing unique UPNs)
  - Shared account policy (prohibiting shared credentials)
  - MFA enforcement (prevents credential sharing)

automated_collection:
  script: |
    # Export all users with unique IDs
    Get-MgUser -All -Property "DisplayName,UserPrincipalName,Id" |
      Select-Object DisplayName, UserPrincipalName, Id |
      Export-Csv "User-List-$(Get-Date -Format 'yyyyMMdd').csv"
```

---

#### **Standard: 164.312(e)(1) (Transmission Security)**

**What Auditors Ask:**
> "Is data encrypted during transmission?"

**Your Response:**
```yaml
encryption: TLS 1.2+ (Microsoft 365 default)
cipher_suites: AES-256-GCM
certificate_validation: Required

evidence_to_provide:
  - TLS inspection logs (showing TLS 1.2+ enforcement)
  - M365 security baseline documentation
  - Third-party TLS validation (e.g., SSL Labs)

automated_collection:
  # Manual verification via SSL Labs
  url: https://www.ssllabs.com/ssltest/analyze.html?d=yourtenant.sharepoint.com
```

---

## 5. **Audit Response Templates**

### **5.1 SOX Audit Response Template**

```markdown
## SOX Control Testing: User Access Management

**Control Objective:**
Ensure that access to financial systems is restricted to authorized users only.

**Control Description:**
External users (B2B guests) accessing SharePoint/Teams must:
1. Authenticate with MFA
2. Use a compliant device
3. Accept Terms of Use
4. Sessions limited to 4 hours

**Implementation:**
- Template: `conditional-access-mfa-external-e5-enhanced.yaml`
- Deployed: [Date]
- Last Modified: [Date]
- Owner: Identity Team

**Testing Performed:**
- Reviewed CA policy configuration (attached: CA-Policy-Export.json)
- Verified MFA enforcement in sign-in logs (attached: MFA-Logs.csv)
- Confirmed device compliance checks (attached: Intune-Compliance.pdf)
- Validated session timeout (attached: Session-Logs.csv)

**Sample Size:** 25 external user sign-ins (last 30 days)
**Exceptions:** 0
**Result:** Control is operating effectively

**Evidence Attached:**
1. CA-Policy-Export.json
2. MFA-Sign-In-Logs.csv
3. Device-Compliance-Report.pdf
4. Session-Timeout-Logs.csv
5. Quarterly-Access-Review-Q1-2025.pdf

**Auditor Notes:**
[Leave blank for auditor to complete]
```

---

### **5.2 GDPR Compliance Response Template**

```markdown
## GDPR Article 32: Security of Processing

**Requirement:**
Implement appropriate technical and organizational measures to ensure a level of security appropriate to the risk.

**Our Implementation:**
1. **Encryption:** AES-256 at rest, TLS 1.2+ in transit (M365 default)
2. **MFA:** Required for all external users
3. **Device Security:** Compliant devices only (Intune)
4. **Risk-Based Access:** Identity Protection blocks high-risk sign-ins
5. **Monitoring:** Real-time session monitoring (Defender for Cloud Apps)

**Template References:**
- `conditional-access-mfa-external-e5-enhanced.yaml` (lines 62-95)
- `partner-tenant-config.yaml` (lines 95-109)

**Evidence of Compliance:**
1. Encryption validation report (attached)
2. MFA enforcement logs (last 90 days)
3. Risk detection reports (Identity Protection)
4. Incident response procedures (documented)

**Data Protection Impact Assessment (DPIA):**
- Conducted: [Date]
- Risk Level: Low (due to E5 security controls)
- Next Review: [Date + 1 year]

**Compliance Status:** ✅ Compliant

**Evidence Attached:**
1. Encryption-Validation-Report.pdf
2. MFA-Enforcement-Logs-90days.csv
3. Risk-Detections-Report.pdf
4. DPIA-Cross-Tenant-Collaboration.pdf
```

---

### **5.3 HIPAA Compliance Response Template**

```markdown
## HIPAA Security Rule: Technical Safeguards

**Standard:** 164.312(a)(1) - Access Control

**Implementation Specifications:**
- **Unique User Identification (R):** Entra ID (Azure AD) UPNs + GUIDs
- **Emergency Access Procedure (R):** Break-glass accounts (excluded from CA)
- **Automatic Logoff (A):** 4-hour session timeout
- **Encryption and Decryption (A):** AES-256 (M365 default)

**Template References:**
- `conditional-access-mfa-external-e5-enhanced.yaml` (lines 20-21, 80-85)
- `partner-tenant-config.yaml` (lines 25-32)

**Testing Results:**
- ✅ All users have unique UPNs
- ✅ No shared accounts detected
- ✅ Session timeout verified (4 hours)
- ✅ Emergency access tested successfully

**Risk Analysis:**
- Likelihood: Low
- Impact: Moderate
- Residual Risk: Low (after controls)

**Business Associate Agreement (BAA):**
- Microsoft 365 HIPAA BAA: Executed [Date]
- Covers: All E5 services (SharePoint, Teams, Exchange)
- Available at: https://www.microsoft.com/licensing/docs/view/Microsoft-Products-and-Services-Agreement-MPSA

**Compliance Status:** ✅ Compliant

**Evidence Attached:**
1. User-List-Unique-IDs.csv
2. Session-Timeout-Logs.csv
3. Emergency-Access-Test-Results.pdf
4. Microsoft-HIPAA-BAA-Executed.pdf
```

---

## 6. **Compliance Checklists**

### **6.1 SOX Compliance Checklist**

```yaml
sox_it_general_controls:
  user_access:
    - [ ] Unique user IDs for all users
    - [ ] MFA enforced for external users
    - [ ] Least privilege access (role-based)
    - [ ] Quarterly access reviews conducted
    - [ ] Terminated users deprovisioned within 24 hours
  
  audit_accountability:
    - [ ] Audit logs enabled for all systems
    - [ ] 7-year retention configured
    - [ ] Logs are tamper-proof
    - [ ] Monthly log reviews documented
    - [ ] Alerting configured for suspicious activity
  
  change_management:
    - [ ] All policy changes version-controlled (Git)
    - [ ] Change approval workflow (GitHub PRs)
    - [ ] Rollback procedures documented
    - [ ] Production changes tested in dev first
    - [ ] Post-implementation review conducted
  
  segregation_of_duties:
    - [ ] Admin cannot approve own changes
    - [ ] CA policy deployment requires 2-person approval
    - [ ] Emergency access (break-glass) separate from normal admin

evidence_location:
  user_access: "Entra admin center → Users"
  audit_logs: "M365 Compliance Center → Audit"
  change_management: "GitHub repo → commit history"
```

---

### **6.2 GDPR Compliance Checklist**

```yaml
gdpr_requirements:
  lawful_basis:
    - [ ] Privacy policy published and accessible
    - [ ] Terms of Use for external users (consent)
    - [ ] Legitimate interest documented (where applicable)
  
  data_subject_rights:
    - [ ] Right to access (DSR process documented)
    - [ ] Right to erasure (auto-deprovision configured)
    - [ ] Right to portability (export functionality available)
    - [ ] Right to object (opt-out process documented)
  
  security_measures:
    - [ ] Encryption at rest (M365 default)
    - [ ] Encryption in transit (TLS 1.2+)
    - [ ] MFA enforced
    - [ ] Device compliance required
    - [ ] Risk-based access controls
  
  breach_notification:
    - [ ] Incident response plan documented
    - [ ] 72-hour notification process defined
    - [ ] DPA contact information maintained
    - [ ] Breach notification templates prepared

evidence_location:
  consent: "Entra admin center → Terms of Use → Acceptances"
  dsr: "M365 Compliance Center → Data Subject Requests"
  security: "Entra admin center → CA policies"
```

---

### **6.3 HIPAA Compliance Checklist**

```yaml
hipaa_security_rule:
  administrative_safeguards:
    - [ ] Risk analysis conducted annually
    - [ ] Workforce training completed (all staff)
    - [ ] Access authorization process documented
    - [ ] Business Associate Agreements (BAAs) in place
  
  physical_safeguards:
    - [ ] Workstation use policy defined
    - [ ] Device encryption required (BitLocker/FileVault)
    - [ ] Device compliance enforced (Intune)
    - [ ] Lost/stolen device remote wipe enabled
  
  technical_safeguards:
    - [ ] Unique user IDs enforced
    - [ ] MFA required for all access
    - [ ] Automatic logoff configured (4 hours)
    - [ ] Audit logs enabled
    - [ ] Encryption at rest and in transit
  
  policies_procedures:
    - [ ] HIPAA policies documented and approved
    - [ ] Incident response plan tested annually
    - [ ] Breach notification process defined
    - [ ] Sanction policy for violations

evidence_location:
  risk_analysis: "validate-cpa-tenant-e5.ps1 output"
  baa: "Microsoft HIPAA BAA (executed)"
  audit_logs: "M365 Compliance Center → Audit"
```

---

## 7. **Gap Analysis**

### **7.1 SOX Gap Analysis**

| Control | Required | Implemented | Gap | Remediation |
|---------|----------|-------------|-----|-------------|
| **User Access** |
| MFA for all users | Yes | ✅ Yes | None | N/A |
| Device compliance | Recommended | ✅ Yes | None | N/A |
| Quarterly access reviews | Yes | ⚠️ Manual | Automation | Implement automated access reviews (Entra ID Governance) |
| **Audit & Accountability** |
| Audit log retention (7 years) | Yes | ✅ Yes | None | N/A |
| Log monitoring | Yes | ⚠️ Manual | Automation | Configure M365 Security Alerts |
| **Change Management** |
| Version control | Yes | ✅ Yes (Git) | None | N/A |
| Approval workflow | Yes | ✅ Yes (GitHub PR) | None | N/A |
| Testing before prod | Yes | ⚠️ Informal | Formal | Document pre-prod testing checklist |

**Priority Gaps:**
1. 🔴 **High:** Automate access reviews (quarterly)
2. 🟡 **Medium:** Automate log monitoring (alerts)
3. 🟢 **Low:** Formalize pre-prod testing

**Remediation Plan:**
```yaml
gap_1_access_reviews:
  priority: High
  effort: 2 hours
  cost: $0 (included in E5)
  steps:
    - Enable Entra ID Governance
    - Create quarterly access review schedule
    - Configure auto-removal after 30 days
  
gap_2_log_monitoring:
  priority: Medium
  effort: 4 hours
  cost: $0 (included in E5)
  steps:
    - Configure M365 Security Alerts
    - Set thresholds (failed logins, risky sign-ins)
    - Route alerts to SOC/IT team

gap_3_testing:
  priority: Low
  effort: 1 hour
  cost: $0
  steps:
    - Document pre-prod testing checklist
    - Add to CONTRIBUTING.md
    - Require checklist completion in PR template
```

---

### **7.2 GDPR Gap Analysis**

| Requirement | Required | Implemented | Gap | Remediation |
|-------------|----------|-------------|-----|-------------|
| **Consent** |
| Terms of Use | Yes | ✅ Yes | None | N/A |
| Consent withdrawal | Yes | ✅ Yes (auto-deprovision) | None | N/A |
| **Data Minimization** |
| Only necessary attributes synced | Yes | ✅ Yes | None | N/A |
| Time-limited access | Recommended | ✅ Yes (4-hour session) | None | N/A |
| **Data Subject Rights** |
| Right to access (DSR) | Yes | ⚠️ Manual | Automation | Implement automated DSR workflow |
| Right to erasure | Yes | ✅ Yes (auto-deprovision) | None | N/A |
| **Breach Notification** |
| 72-hour notification | Yes | ⚠️ Documented | Testing | Conduct breach notification drill |

**Priority Gaps:**
1. 🟡 **Medium:** Automate DSR workflow
2. 🟡 **Medium:** Test breach notification process

**Remediation Plan:**
```yaml
gap_1_dsr_automation:
  priority: Medium
  effort: 8 hours
  cost: $0 (included in E5)
  steps:
    - Configure M365 DSR case management
    - Create Power Automate workflow for DSR intake
    - Train staff on DSR response procedures

gap_2_breach_testing:
  priority: Medium
  effort: 4 hours
  cost: $0
  steps:
    - Schedule annual breach notification drill
    - Document drill results
    - Update incident response plan based on findings
```

---

### **7.3 HIPAA Gap Analysis**

| Standard | Required | Implemented | Gap | Remediation |
|----------|----------|-------------|-----|-------------|
| **Administrative** |
| Risk analysis (annual) | Yes | ⚠️ Informal | Formal | Schedule annual risk analysis |
| Workforce training | Yes | ⚠️ Informal | Formal | Implement HIPAA training program |
| **Physical** |
| Device encryption | Yes | ✅ Yes (Intune) | None | N/A |
| Lost device wipe | Yes | ✅ Yes (Intune) | None | N/A |
| **Technical** |
| MFA | Yes | ✅ Yes | None | N/A |
| Audit logs | Yes | ✅ Yes | None | N/A |
| **BAA** |
| Microsoft 365 BAA | Yes | ✅ Executed | None | N/A |
| Subprocessor BAAs | Yes | ⚠️ Review | Validation | Review Microsoft subprocessor list |

**Priority Gaps:**
1. 🔴 **High:** Formalize annual risk analysis
2. 🟡 **Medium:** Implement HIPAA training program
3. 🟢 **Low:** Review subprocessor BAAs

**Remediation Plan:**
```yaml
gap_1_risk_analysis:
  priority: High
  effort: 16 hours (annually)
  cost: $0
  steps:
    - Use validate-cpa-tenant-e5.ps1 as starting point
    - Document threats and vulnerabilities
    - Assess likelihood and impact
    - Update risk register annually

gap_2_training:
  priority: Medium
  effort: 4 hours (setup) + 1 hour/year (per staff)
  cost: $0 (free online resources)
  steps:
    - Identify HIPAA training resources (HHS.gov free course)
    - Require annual completion
    - Track completion in spreadsheet

gap_3_subprocessors:
  priority: Low
  effort: 2 hours
  cost: $0
  steps:
    - Review Microsoft subprocessor list
    - Verify all have signed BAAs
    - Document review in compliance folder
```

---

## 8. **AICPA Specific Requirements (CPA Firms)**

### **8.1 AICPA Code Section 1.700 (Confidential Client Information)**

**Rule 1.700.001 - Definition:**

> A member in public practice shall not disclose any confidential client information without the specific consent of the client.

**Your Implementation:**
```yaml
template: partner-tenant-config.yaml
control: Lines 25-32 (allowed users/groups)

compliance_measures:
  - Client data segregated (separate SharePoint sites per client)
  - Access limited to engagement team only
  - MFA required for all access
  - Audit trail of all file access
  - Auto-removal after engagement ends

evidence:
  - SharePoint site permissions (per client)
  - CA policy enforcement logs
  - Access review reports (quarterly)
  - Deprovision logs (after engagement)
```

**Audit Response:**
> "Client A's data is stored in a dedicated SharePoint site. Only staff assigned to Client A's engagement have access (see permission matrix). All access is logged, MFA-protected, and automatically removed after engagement completion."

---

### **8.2 AICPA SOC 2 Type II (Service Organization Controls)**

**Trust Services Criteria:**

| TSC | Criterion | Your Implementation | Evidence |
|-----|-----------|---------------------|----------|
| **CC6.1** | Logical and Physical Access Controls | conditional-access-mfa-external-e5-enhanced.yaml | CA policy JSON, MFA logs |
| **CC6.6** | Use of Encryption | M365 E5 default (AES-256) | Encryption validation report |
| **CC6.7** | Authentication and Authorization | partner-tenant-config.yaml | Cross-tenant access settings |
| **CC7.2** | Detection of Security Incidents | Identity Protection, Defender for Cloud Apps | Risk detection logs |
| **CC7.3** | Security Incident Response | Incident response plan (documented) | IR plan document |
| **CC7.4** | Security Incident Containment | Auto-block high-risk sign-ins | Identity Protection policy |

**SOC 2 Report Readiness:**
```yaml
type_ii_requirements:
  - Controls in place for 12+ months: ✅ (track from deployment date)
  - Evidence of continuous operation: ✅ (audit logs)
  - Testing of controls: ⚠️ (quarterly testing recommended)
  - Management assertion: ⚠️ (requires CPA firm management sign-off)

readiness_status: 80% complete
gaps:
  - Formal quarterly control testing (implement)
  - Management assertion letter (draft)
  - Service auditor selection (if seeking certification)
```

---

### **8.3 SSAE 18 (Service Organization Controls)**

**SSAE 18 vs. SOC 2:**
- SSAE 18 is the **auditing standard**
- SOC 2 is the **report type** (using SSAE 18 standard)

**Your Readiness:**
```yaml
ssae_18_compliance:
  control_environment:
    - Policies documented: ✅ (see docs/ folder)
    - Change management: ✅ (GitHub workflow)
    - Segregation of duties: ⚠️ (may need additional admin)
  
  risk_assessment:
    - Annual risk analysis: ⚠️ (formalize using validate-cpa-tenant-e5.ps1)
    - Threat identification: ✅ (Identity Protection)
  
  control_activities:
    - CA policies: ✅
    - MFA enforcement: ✅
    - Device compliance: ✅
    - Audit logging: ✅
  
  information_communication:
    - Documentation: ✅ (this repo!)
    - Training: ⚠️ (implement formal training)
  
  monitoring:
    - Log reviews: ⚠️ (automate alerts)
    - Quarterly access reviews: ⚠️ (automate)

readiness_status: 70% complete
timeline_to_certification: 6-12 months (with gap remediation)
```

---

## 9. **Client Confidentiality Controls (CPA Firms)**

### **9.1 Client Data Segregation**

**Requirement:**
> Client A's data must not be accessible by staff working on Client B.

**Your Implementation:**
```yaml
method: SharePoint site permissions + CA policies

structure:
  - Client-A-Engagement/
    - Permissions: Only Client A engagement team
    - External Access: Client A CFO (B2B guest)
    - Sensitivity Label: "Highly Confidential - Client A"
  
  - Client-B-Engagement/
    - Permissions: Only Client B engagement team
    - External Access: Client B Controller (B2B guest)
    - Sensitivity Label: "Highly Confidential - Client B"

enforcement:
  - SharePoint permissions (primary control)
  - CA policies (secondary control - device compliance)
  - DLP policies (prevent cross-client sharing)

testing:
  - User from Client A team tries to access Client B folder → BLOCKED
  - Client A CFO tries to access Client B folder → BLOCKED
  - Quarterly: Review all SharePoint site permissions
```

---

### **9.2 Engagement-Based Access (Time-Limited)**

**Requirement:**
> External users (clients) should only have access during the engagement.

**Your Implementation:**
```yaml
template: source-to-target.yaml
control: Lines 120-135 (lifecycle management)

workflow:
  1. Engagement starts → Add client CFO to "Client-A-Access" group
  2. Cross-tenant sync provisions B2B guest automatically
  3. CA policy enforces MFA + device compliance
  4. Engagement ends → Remove client CFO from group
  5. Auto-deprovision after 30 days (soft delete)

manual_override:
  - Engagement extended → Keep in group
  - Engagement ends early → Remove from group immediately

audit_trail:
  - Add to group: Logged in Entra audit
  - Access to files: Logged in M365 audit
  - Remove from group: Logged in Entra audit
  - Deprovision: Logged in provisioning logs
```

---

### **9.3 Audit Trail (7-Year Retention for IRS)**

**Requirement:**
> IRS requires 7-year retention of client records and access logs.

**Your Implementation:**
```yaml
retention_policy:
  location: M365 Compliance Center → Retention policies
  scope: All SharePoint sites (client engagements)
  duration: 7 years
  applies_to:
    - Client files (tax returns, financial statements)
    - Audit logs (who accessed what, when)
    - Email correspondence (engagement-related)

configuration:
  - Retention label: "Client Records - 7 Year"
  - Auto-apply: All files in client engagement folders
  - Disposition: Review after 7 years (manual approval to delete)

evidence:
  - Retention policy screenshot (M365 Compliance)
  - Sample files with retention label applied
  - Audit log showing 7+ year retention
```

---

## 10. **State Board Compliance (CPA Firms)**

### **10.1 State Board Data Protection Requirements**

**Varies by state. Common requirements:**

```yaml
common_state_requirements:
  - Data encryption (at rest and in transit)
  - MFA for all users
  - Secure storage of client information
  - Incident response plan
  - Data breach notification (varies by state)

example_states:
  california:
    regulation: CA Civil Code Section 1798.81.5
    requires:
      - Encryption or redaction of personal information
      - Authentication of users accessing data
      - Reasonable security procedures
  
  new_york:
    regulation: NYCRR Part 500 (Cybersecurity Requirements)
    requires:
      - MFA for all external access
      - Encryption of nonpublic information
      - Annual risk assessment
      - Cybersecurity policy
  
  texas:
    regulation: Texas Business & Commerce Code Chapter 521
    requires:
      - Notification of breach without unreasonable delay
      - Maintain reasonable procedures to protect data

your_state:
  # Replace with your state's requirements
  state: "[Your State]"
  regulation: "[Regulation Code]"
  requirements:
    - [Requirement 1]
    - [Requirement 2]
  
  compliance_status:
    - [Requirement 1]: ✅ Compliant (CA policy enforces MFA)
    - [Requirement 2]: ⚠️ Review needed
```

---

### **10.2 Cyber Insurance Requirements**

**Common cyber insurance requirements:**

```yaml
insurance_requirements:
  security_controls:
    - [ ] MFA enabled for all users
    - [ ] Endpoint protection (antivirus)
    - [ ] Patch management (OS updates)
    - [ ] Email security (anti-phishing)
    - [ ] Data backup (tested recovery)
    - [ ] Incident response plan
    - [ ] Cyber training for staff

  your_implementation:
    mfa: ✅ Enforced via CA policies
    endpoint_protection: ✅ Defender for Endpoint (E5)
    patch_management: ✅ Intune managed updates
    email_security: ✅ Defender for Office 365 (E5)
    backup: ✅ M365 retention policies
    incident_response: ⚠️ Document formal plan
    training: ⚠️ Implement annual training

  evidence_for_insurer:
    - CA policy JSON export
    - Intune compliance report
    - Defender threat protection report
    - Incident response plan document
    - Training completion certificates
```

---

## 📊 **Summary Tables**

### **Compliance Coverage by Template**

| Template | SOX | GDPR | HIPAA | NIST | AICPA | SOC 2 |
|----------|-----|------|-------|------|-------|-------|
| conditional-access-mfa-external-e5-enhanced.yaml | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ |
| partner-tenant-config.yaml | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| source-to-target.yaml | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ |

**Legend:**
- ✅ Fully addresses requirements
- ⚠️ Partially addresses (additional measures needed)
- ❌ Does not address

---

### **Evidence Collection Frequency**

| Evidence Type | Frequency | Owner | Storage Location |
|---------------|-----------|-------|------------------|
| CA policy JSON exports | Quarterly | Identity Team | Compliance folder (SharePoint) |
| Sign-in logs | Monthly | Security Team | M365 audit log retention |
| MFA enrollment reports | Quarterly | Identity Team | Compliance folder |
| Access review reports | Quarterly | Identity Team | Entra ID Governance |
| Risk detection logs | Monthly | Security Team | Identity Protection |
| Provisioning logs | Monthly | Identity Team | Entra ID |
| Incident response tests | Annually | Security Team | Compliance folder |

---

## 📞 **Support & Resources**

| Question Type | Resource |
|--------------|----------|
| **SOX Compliance** | [PCAOB Standards](https://pcaobus.org/) |
| **GDPR Compliance** | [EU GDPR Portal](https://gdpr.eu/) |
| **HIPAA Compliance** | [HHS HIPAA](https://www.hhs.gov/hipaa/) |
| **NIST 800-53** | [NIST SP 800-53 Rev 5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) |
| **AICPA Standards** | [AICPA Code of Conduct](https://www.aicpa.org/resources/article/code-of-professional-conduct) |
| **Microsoft Compliance** | [Microsoft Trust Center](https://www.microsoft.com/trust-center) |

---

## 🎯 **Next Steps**

1. **Run Validation Script**
   ```powershell
   pwsh validate-cpa-tenant-e5.ps1 -DetailedReport
   ```

2. **Review Gap Analysis** (Section 7)
   - Prioritize high-priority gaps
   - Create remediation plan
   - Assign owners and deadlines

3. **Collect Evidence** (Section 4)
   - Export CA policies
   - Export audit logs
   - Document current state

4. **Prepare for Audit**
   - Use audit response templates (Section 5)
   - Organize evidence by framework
   - Schedule pre-audit review

5. **Continuous Monitoring**
   - Implement automated alerts
   - Schedule quarterly access reviews
   - Update documentation as changes occur

---

<p align="center">
  <strong>Compliance Made Simple! 📊</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/SOX-Compliant-success?logo=checkmarx" alt="SOX Compliant">
  <img src="https://img.shields.io/badge/GDPR-Compliant-success?logo=checkmarx" alt="GDPR Compliant">
  <img src="https://img.shields.io/badge/HIPAA-Compliant-success?logo=checkmarx" alt="HIPAA Compliant">
  <img src="https://img.shields.io/badge/SOC_2-Ready-blue?logo=microsoftazure" alt="SOC 2 Ready">
</p>
