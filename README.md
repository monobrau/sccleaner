# SCCleaner

A PowerShell tool to identify and delete vulnerable versions of the ConnectWise ScreenConnect installer.

## Run commands

### Dry run (scan only — no files deleted)

Lists matching ScreenConnect/ConnectWise Control installers. Press **Enter** at the prompt to exit without deleting.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\sccleaner.ps1
```

### Delete ScreenConnect installers (auto-delete)

**Deletes all matching vulnerable installer files** (cutoff date and exclusions still apply). Use after reviewing dry-run output.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\sccleaner.ps1 1
```

Run from the repo folder, or use the full path to `sccleaner.ps1`.

### ScreenConnect command console (pull from GitHub)

Paste into the **Commands** tab on a session or machine. These download the latest script from GitHub and run it non-interactively (no prompts — required for SC command console).

**Dry run (scan only — review output in Commands tab):**

```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/monobrau/sccleaner/main/sccleaner.ps1' -UseBasicParsing -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1 dry"
```

**Delete ScreenConnect installers (auto-delete):**

```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/monobrau/sccleaner/main/sccleaner.ps1' -UseBasicParsing -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1 1"
```

## Purpose

SCCleaner scans user profiles and common download locations for old ScreenConnect/ConnectWise Control installer files (`.exe` and `.msi`) that were last modified before a cutoff date (August 31 of the current or previous year, depending on the current month). This helps remove potentially vulnerable installer files that may have been downloaded but not cleaned up.

## Features

- Scans multiple user profile locations (Downloads, Desktop, Documents, Temp folders, etc.)
- Identifies ScreenConnect/ConnectWise Control installer files by name patterns
- Filters files by last write time (cutoff date)
- Excludes protected system files (e.g., `C:\WINDOWS\LTSvc\packages\connectwisecontrol\`)
- Interactive mode: Review found files and select which to delete
- Auto-delete mode: Automatically delete all matching files (via environment variable or argument)
- Displays file size, last write time, and full path for review

## Usage

### PowerShell Commands

**Interactive Mode (Default)**
```powershell
.\sccleaner.ps1
```

**Auto-Delete Mode**
```powershell
.\sccleaner.ps1 1
```

**With Execution Policy Bypass**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\sccleaner.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\sccleaner.ps1 1
```

**Using Environment Variable**
```powershell
$env:SC_AUTODELETE = '1'
.\sccleaner.ps1
```

### CMD (Command Prompt) Commands

**Interactive Mode**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -File sccleaner.ps1
```

**Auto-Delete Mode**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -File sccleaner.ps1 1
```

**From Different Directory**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\path\to\sccleaner\sccleaner.ps1" 1
```

### How It Works

The script will:
1. Scan for matching installer files
2. Display a numbered list of found files
3. In interactive mode, prompt you to enter:
   - Index numbers (comma-separated) to delete specific files
   - `A` to delete all files
   - Press Enter to cancel
4. In auto-delete mode, automatically delete all found files

See [QUICKSTART.md](QUICKSTART.md) for more command examples.

### Cutoff Date Logic

**Cutoff Date: December 11, 2025 23:59:59**

This date corresponds to when the latest known vulnerability (CVE-2025-14265) was patched in ScreenConnect version 25.8. Any installer file (`.exe` or `.msi`) with `LastWriteTime` <= this cutoff date may contain vulnerable versions and will be considered for deletion.

**Known Vulnerabilities Covered:**
- **CVE-2024-1709 & CVE-2024-1708** (Critical, CVSS 10): Authentication bypass - Fixed in v23.9.8 (Feb 19, 2024)
- **CVE-2025-3935** (High, CVSS 9): ViewState code injection - Fixed in v2025.4 (Apr 25, 2025)
- **CVE-2025-14265** (High, CVSS 8): Extension subsystem vulnerability - Fixed in v25.8 (Dec 11, 2025)

By deleting installers before December 11, 2025, we ensure that only installers capable of installing patched (non-vulnerable) versions remain on the system.

## Exclusions

The following are **never deleted**:
- `C:\WINDOWS\LTSvc\packages\connectwisecontrol\CWControlClientInstaller.msi`
- Any file in `C:\WINDOWS\LTSvc\packages\connectwisecontrol\` directory

## Search Patterns

The script searches for files matching these name patterns (case-insensitive):
- `screenconnect`
- `connectwisecontrol`
- `cwcontrol`
- `connectwise control`

File extensions searched: `.exe`, `.msi`

## Scanned Locations

For each user profile:
- `Downloads`
- `Desktop`
- `Documents`
- `AppData\Local\Temp`
- `AppData\Local\Microsoft\Windows\INetCache`
- `AppData\Local\Microsoft\Windows\Temporary Internet Files`
- `AppData\Roaming`

System locations:
- `%TEMP%`
- `%WINDIR%\Temp`

## Web Execution

SCCleaner can be downloaded and executed directly from the web. See [INSTALL.md](INSTALL.md) for detailed instructions.

### Quick Web Execution (Interactive Mode)
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1"
```

### Quick Web Execution (Auto-Delete Mode)
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1 1"
```

### Execute from Memory (No File Download)
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-WebRequest -Uri 'YOUR_URL_HERE' -UseBasicParsing).Content"
```

**Replace `YOUR_URL_HERE` with your actual script hosting URL** (e.g., GitHub raw URL, Gist URL, or your web server).

See `oneliner.txt` for ready-to-use one-liner commands and `INSTALL.md` for hosting options.

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- Administrator privileges may be required to delete files in some locations
- Execution Policy: May need to run with `-ExecutionPolicy Bypass` if script execution is restricted
- Internet connection (for web execution mode)

## Security Notes

- The script uses `-Force` when deleting files
- Always review the list of files before deleting in interactive mode
- Test in a non-production environment first
- Consider backing up important files before running in auto-delete mode
