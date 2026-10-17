# 🛡️ VirusTotal Clean Engine Audit

**Package Version:** `v0.9-Beta (MiniBat Engine)`  
**Audit Standard:** Zero-Bloat, Pure Plaintext Verification (No compiled `.exe` or `.dll` binaries)

---

## 📦 Master Package Analysis

| Deliverable Artifact | SHA-256 Checksum | VirusTotal Direct Audit |
| :--- | :--- | :--- |
| `TheSortingBat_v0.9_Beta_MiniBat.zip` | `DA346B7F45A08AADCE53EB534A7674762DC2BA47E33038E9064678A0CEB6897F` | [View Live Package Report](https://www.virustotal.com/gui/file/4f6c674cb89cf77a4d25dc1dd258237b18d5dcda77aec3344800dc27d24a96d1) |

---

## ⚡ Root Shell Runners & Batch Scripts

| Script Component | File Execution Scope | VirusTotal Direct Audit |
| :--- | :--- | :--- |
| `TheSortingBat.bat` | Interactive terminal UI runner & self-elevation caller | [View TheSortingBat Report](https://www.virustotal.com/gui/file/db063b31069c9b24faa0c88eec30a50940bfb9bc6cd39fc5e413a0ce940cf94b) |
| `FastBatBuild.bat` | Headless, instantaneous auto-scaffolding runner | [View FastBatBuild Report](https://www.virustotal.com/gui/file/35a609bdd9a58ba54562fc257786a513e910a1ace62623a878a12b4e1637e32e) |
| `Uninstall.bat` | Non-invasive quick access uninstaller | [View Uninstall Report](https://www.virustotal.com/gui/file/4e5acbeb0f80c659bd15e92b98c5de277aebcf698a8a768e1cb9a367abdd8954) |

---

## ⚙️ Engine Core & PowerShell Scripts

| Engine Script | Architecture Role | VirusTotal Direct Audit |
| :--- | :--- | :--- |
| `SortingBatBackend.ps1` | Environment discovery, directory mapping, and shortcut generation | [View SortingBatBackend Report](https://www.virustotal.com/gui/file/d74a448b4007100810e85ce1084e1dc5e9ff4d9b383cbb86e405debae7ab7662) |
| `RollbackBat.ps1` | Hub unpinning, desktop.ini reset, and directory removal engine | [View RollbackBat Report](https://www.virustotal.com/gui/file/dac9f65ab6c2fb4b2473bc6d89167db91603d68682f63e71fef0eba4d672ecde) |

---

> **Note on Navigation:** GitHub natively navigates links in the same browser window; use `Ctrl + Click` (or middle-click) on any report link to view the VirusTotal analysis in a separate browser tab.
