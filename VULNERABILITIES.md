# ConnectWise ScreenConnect Known Vulnerabilities

This document lists the known vulnerabilities that SCCleaner addresses by deleting potentially vulnerable installer files.

## Critical Vulnerabilities

### CVE-2024-1709 & CVE-2024-1708
- **Severity**: CRITICAL (CVSS 10.0)
- **Affected Versions**: ScreenConnect 23.9.7 and earlier
- **Patch Version**: 23.9.8
- **Patch Release Date**: February 19, 2024
- **Description**: 
  - CVE-2024-1709: Authentication bypass vulnerability allowing unauthenticated attackers to gain remote access
  - CVE-2024-1708: Path traversal vulnerability (ZipSlip) leading to remote code execution
- **Impact**: Attackers could bypass authentication, create administrator accounts, and execute remote code
- **Status**: Actively exploited in ransomware campaigns

## High Severity Vulnerabilities

### CVE-2025-3935
- **Severity**: HIGH (CVSS 9.0)
- **Affected Versions**: ScreenConnect 25.2.3 and earlier
- **Patch Version**: 2025.4
- **Patch Release Date**: April 25, 2025
- **Description**: ViewState code injection vulnerability requiring compromised machine keys for remote code execution
- **Impact**: Remote code execution on the server component
- **Note**: Vulnerability stems from ASP.NET platform behavior

### CVE-2025-14265
- **Severity**: HIGH (CVSS 8.0)
- **Affected Versions**: ScreenConnect versions prior to 25.8
- **Patch Version**: 25.8
- **Patch Release Date**: December 11, 2025
- **Description**: Insufficient server-side validation in extension subsystem allowing authorized users to install and execute untrusted extensions
- **Impact**: Custom code execution on server or unauthorized access to configuration data
- **Note**: Requires authorized/administrative user access to exploit

## Cutoff Date Rationale

**Cutoff Date: December 11, 2025 23:59:59**

This date represents the latest vulnerability patch release (CVE-2025-14265 fixed in version 25.8). Any installer file (`.exe` or `.msi`) with a `LastWriteTime` before or on this date may contain vulnerable versions and should be deleted.

Installers downloaded or modified after December 11, 2025 are likely to be version 25.8 or later, which includes all security patches.

## References

- [ConnectWise Security Bulletins](https://www.connectwise.com/company/trust/security-bulletins)
- [CVE-2024-1709 Details](https://nvd.nist.gov/vuln/detail/CVE-2024-1709)
- [CVE-2024-1708 Details](https://nvd.nist.gov/vuln/detail/CVE-2024-1708)
- [CVE-2025-3935 Details](https://www.rapid7.com/db/vulnerabilities/connectwise-screenconnect-cve-2025-3935/)
- [CVE-2025-14265 Details](https://www.rapid7.com/db/vulnerabilities/connectwise-screenconnect-cve-2025-14265/)
