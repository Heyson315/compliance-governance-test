# Contributing to Compliance-Governance-Test

Thank you for your interest in contributing! This repository contains documentation and templates for Microsoft 365 E5 cross-tenant collaboration and compliance automation.

---

## 🎯 **How to Contribute**

### **Types of Contributions Welcome:**

| Type | Examples |
|------|----------|
| 🐛 **Bug Fixes** | Typos, incorrect GUIDs, broken links |
| 📚 **Documentation** | Clarifications, additional examples, translations |
| 🔧 **Templates** | New policy templates, automation scripts |
| 💡 **Enhancements** | Additional compliance frameworks, new features |
| ⚠️ **Security** | Security vulnerabilities, best practice improvements |

---

## 📋 **Contribution Guidelines**

### **1. Before You Start**

- [ ] Check [existing issues](https://github.com/Heyson315/compliance-governance-test/issues) to avoid duplicates
- [ ] Review the [README](README.md) to understand the project scope
- [ ] Read this contributing guide thoroughly

### **2. Making Changes**

#### **For Documentation Updates:**

```bash
# 1. Fork the repository
# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/compliance-governance-test.git
cd compliance-governance-test

# 3. Create a feature branch
git checkout -b docs/improve-e5-guide

# 4. Make your changes
# Edit files in docs/ directory

# 5. Commit with descriptive message
git commit -m "docs: Add Azure Gov Cloud considerations to E5 guide"

# 6. Push to your fork
git push origin docs/improve-e5-guide

# 7. Open a Pull Request
```

#### **For YAML Templates:**

```yaml
# Template Contribution Checklist:
- [ ] Follow existing YAML structure and naming conventions
- [ ] Include comments explaining each section
- [ ] Add metadata section with:
      - created_by
      - version
      - compliance_frameworks
      - tags
- [ ] Test YAML syntax (no tabs, proper indentation)
- [ ] Add to README.md documentation section
- [ ] Include validation checklist
- [ ] Document prerequisites
```

#### **For PowerShell Scripts:**

```powershell
# Script Contribution Checklist:
- [ ] Use PowerShell 7+ compatible syntax
- [ ] Include detailed comments
- [ ] Add error handling (try/catch)
- [ ] Use Write-Host with colors for output
- [ ] Include usage examples at top of file
- [ ] Test on Windows 10/11
- [ ] Follow existing script style
```

---

## 📝 **Commit Message Guidelines**

Use conventional commits format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### **Types:**

| Type | Use For |
|------|---------|
| `feat` | New feature or template |
| `fix` | Bug fix or correction |
| `docs` | Documentation changes |
| `style` | Formatting, no code change |
| `refactor` | Code restructuring |
| `test` | Adding tests |
| `chore` | Maintenance tasks |

### **Examples:**

```bash
# Good ✅
feat(e5): Add Identity Protection deployment script
docs(readme): Update E5 license cost table
fix(ca-policy): Correct device state GUID in E5 template

# Bad ❌
Update stuff
Fixed things
Changes
```

---

## 🔍 **Pull Request Process**

### **PR Checklist:**

- [ ] **Title**: Clear, descriptive (follows commit message format)
- [ ] **Description**: What changes and why
- [ ] **Testing**: How you tested the changes
- [ ] **Documentation**: Updated if needed
- [ ] **Breaking Changes**: Clearly noted if any

### **PR Template:**

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Breaking change

## Testing
How these changes were tested

## Compliance Impact
Does this affect compliance requirements? (SOX, GDPR, etc.)

## Checklist
- [ ] YAML syntax validated
- [ ] Documentation updated
- [ ] No credentials/secrets committed
- [ ] Follows style guidelines
```

---

## 🚫 **What NOT to Contribute**

### **❌ Do NOT commit:**

- Tenant-specific GUIDs (keep placeholders)
- Real email addresses
- Actual domain names
- Credentials or secrets
- Production configuration files
- Personal information

### **✅ DO commit:**

- Generic templates with placeholders
- Documentation improvements
- Example configurations (anonymized)
- Scripts with parameterization

---

## 🎨 **Style Guidelines**

### **YAML Files:**

```yaml
# ✅ Good
name: Policy-Name-With-Hyphens
display_name: "Human Readable Policy Name"
description: |
  Multi-line description
  with proper indentation

# ❌ Bad
name: policy_with_underscores  # Use hyphens
display_name: NoQuotesOrSpaces  # Use quotes for strings
description: "Single line that's way too long and hard to read"
```

### **Markdown Files:**

```markdown
# Use ATX-style headers (# ## ###)
# Not Setext-style (===== -----)

## Add blank lines around headers

Use **bold** for emphasis, not *italic* overuse.

Use `code blocks` for:
- Commands
- Configuration snippets
- File names

Use tables for comparisons:
| Column 1 | Column 2 |
|----------|----------|
| Data     | Data     |
```

### **PowerShell Scripts:**

```powershell
# ✅ Good
function Get-ComplianceStatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$TenantId
    )
    
    try {
        # Clear, descriptive variable names
        $ComplianceResults = Get-TenantCompliance -Id $TenantId
        Write-Host "✅ Compliance check passed" -ForegroundColor Green
        return $ComplianceResults
    }
    catch {
        Write-Host "❌ Error: $_" -ForegroundColor Red
        throw
    }
}

# ❌ Bad
function gcs($t) {  # Cryptic names
    $r = Get-TenantCompliance $t  # No error handling
    echo $r  # Use Write-Host with colors
}
```

---

## 🔒 **Security Guidelines**

### **If You Find a Security Issue:**

**🚨 DO NOT open a public issue.**

Instead:
1. Email: security@hassanrahman.com (or create private security advisory on GitHub)
2. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### **Security Review Checklist:**

Before submitting changes:
- [ ] No hardcoded credentials
- [ ] No sensitive GUIDs/IDs
- [ ] No real tenant information
- [ ] Scripts require user input for sensitive data
- [ ] Templates use placeholders (e.g., `00000000-0000-0000-0000-000000000000`)

---

## 📊 **Testing Your Changes**

### **Documentation Changes:**

```bash
# 1. Preview Markdown locally
# Use VS Code with Markdown Preview Enhanced extension
# Or: https://dillinger.io/ (online preview)

# 2. Check links
# Ensure all relative links work

# 3. Verify Mermaid diagrams
# GitHub renders Mermaid automatically
# Or use: https://mermaid.live/
```

### **YAML Template Changes:**

```bash
# 1. Syntax validation
# Use yamllint or online validators

# 2. Test with actual tenant (non-production)
# Create test policy in report-only mode first

# 3. Run workspace health check
pwsh workspace-health-check.ps1
```

### **PowerShell Script Changes:**

```powershell
# 1. Syntax check
Get-Command -Syntax YourFunction

# 2. Test in isolated environment
# Use PowerShell 7+ in Windows Sandbox

# 3. Test error handling
# Intentionally trigger errors to verify catch blocks
```

---

## 🏆 **Recognition**

Contributors will be:
- Listed in [CONTRIBUTORS.md](CONTRIBUTORS.md) (coming soon)
- Mentioned in release notes for significant contributions
- Credited in documentation where applicable

---

## 📞 **Questions?**

- **General Questions**: Open a [Discussion](https://github.com/Heyson315/compliance-governance-test/discussions)
- **Bug Reports**: Open an [Issue](https://github.com/Heyson315/compliance-governance-test/issues)
- **Feature Requests**: Open an [Issue](https://github.com/Heyson315/compliance-governance-test/issues) with `enhancement` label

---

## 📄 **Code of Conduct**

### **Our Standards:**

✅ **Do:**
- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards others

❌ **Don't:**
- Use offensive language
- Troll or harass others
- Publish others' private information
- Engage in unprofessional conduct

### **Enforcement:**

Violations may result in:
1. Warning
2. Temporary ban
3. Permanent ban

Report issues to: conduct@hassanrahman.com

---

## 🎓 **Learning Resources**

New to contributing? Check these out:

- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [GitHub Flow Guide](https://guides.github.com/introduction/flow/)
- [Markdown Guide](https://www.markdownguide.org/)
- [YAML Syntax](https://yaml.org/spec/1.2/spec.html)
- [Microsoft Entra ID Docs](https://learn.microsoft.com/entra/)

---

## 📅 **Release Process**

We follow [Semantic Versioning](https://semver.org/):

```
MAJOR.MINOR.PATCH
1.0.0

MAJOR: Breaking changes
MINOR: New features (backward compatible)
PATCH: Bug fixes
```

Releases are tagged and documented in [CHANGELOG.md](CHANGELOG.md) (coming soon).

---

<p align="center">
  <strong>Thank you for contributing! 🎉</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen" alt="PRs Welcome">
  <img src="https://img.shields.io/badge/License-MIT-blue" alt="License MIT">
</p>
