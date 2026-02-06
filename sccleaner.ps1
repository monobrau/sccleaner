# SCCleaner - Remove vulnerable ConnectWise ScreenConnect installer files
# This script scans for and optionally deletes ScreenConnect/ConnectWise Control installer files
# that may contain known vulnerabilities

# Known Vulnerabilities:
# - CVE-2024-1709 & CVE-2024-1708: Critical auth bypass (CVSS 10) - Fixed in version 23.9.8 (Feb 19, 2024)
# - CVE-2025-3935: ViewState code injection (CVSS 9) - Fixed in version 2025.4 (Apr 25, 2025)
# - CVE-2025-14265: Extension subsystem vulnerability (CVSS 8) - Fixed in version 25.8 (Dec 11, 2025)
# Latest patch date: December 11, 2025 (version 25.8)

$ErrorActionPreference = 'SilentlyContinue'

# Determine if auto-delete mode is enabled
$AUTO = ($env:SC_AUTODELETE -eq '1' -or $env:SC_AUTODELETE -eq 'true')
if ($args -and $args.Count -gt 0) {
    if ($args[0] -match '^(1|true|yes|y)$') {
        $AUTO = $true
    }
}

# Cutoff date: December 11, 2025 23:59:59
# This is the date when the latest vulnerability (CVE-2025-14265) was patched in version 25.8
# Any installer file with LastWriteTime <= this date may contain vulnerable versions
# and should be deleted to prevent installation of vulnerable software
$CUTOFF = Get-Date -Year 2025 -Month 12 -Day 11 -Hour 23 -Minute 59 -Second 59

# Files/directories to exclude from deletion
$EXACT_EXCLUDE = 'C:\WINDOWS\LTSvc\packages\connectwisecontrol\CWControlClientInstaller.msi'
$DIR_EXCLUDE = 'C:\WINDOWS\LTSvc\packages\connectwisecontrol\'

Write-Host ('Cutoff: delete files with LastWriteTime <= ' + $CUTOFF.ToString('yyyy-MM-dd HH:mm:ss'))
Write-Host ('Reason: Latest vulnerability patch date (CVE-2025-14265 fixed in v25.8 on Dec 11, 2025)')
Write-Host ('Excluding (never delete): ' + $EXACT_EXCLUDE)

# Search patterns for ScreenConnect/ConnectWise Control files
$patterns = @('screenconnect', 'connectwisecontrol', 'cwcontrol', 'connectwise control')

# Get user profiles (excluding system profiles)
$profiles = Get-ChildItem 'C:\Users' -Directory -Force | Where-Object {
    $_.Name -notin @('All Users', 'Default', 'Default User', 'DefaultAppPool', 'Public') -and
    $_.Name -notlike 'Default*'
}

# Build list of directories to scan
$roots = @()
foreach ($p in $profiles) {
    $u = $p.FullName
    $roots += @(
        "$u\Downloads",
        "$u\Desktop",
        "$u\Documents",
        "$u\AppData\Local\Temp",
        "$u\AppData\Local\Microsoft\Windows\INetCache",
        "$u\AppData\Local\Microsoft\Windows\Temporary Internet Files",
        "$u\AppData\Roaming\"
    )
}
$roots += @($env:TEMP, $env:WINDIR + '\Temp')
$roots = $roots | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique

Write-Host ('Scanning ' + $roots.Count + ' locations across ' + $profiles.Count + ' user profiles...')

# Scan for matching files
$hits = foreach ($r in $roots) {
    Get-ChildItem -Path $r -Recurse -Force -File -Include '*.exe', '*.msi' -ErrorAction SilentlyContinue | Where-Object {
        $full = $_.FullName
        $n = $_.Name.ToLowerInvariant()
        $match = (($patterns | ForEach-Object { $n -like ('*' + $_.ToLowerInvariant() + '*') }) -contains $true)
        $old = ($_.LastWriteTime -le $CUTOFF)
        $excluded = ($full -ieq $EXACT_EXCLUDE) -or ($full.ToLowerInvariant().StartsWith($DIR_EXCLUDE.ToLowerInvariant()))
        $match -and $old -and (-not $excluded)
    } | Select-Object FullName, Length, LastWriteTime
}

# Sort by LastWriteTime descending
$hits = $hits | Sort-Object LastWriteTime -Descending

if (-not $hits) {
    Write-Host 'No ScreenConnect/ConnectWise Control installer EXE/MSI files found (with cutoff + exclusions) under user profiles.'
    exit 0
}

# Index the hits for user selection
$i = 0
$indexed = $hits | ForEach-Object {
    $o = [pscustomobject]@{
        Index    = $i
        SizeMB   = [math]::Round($_.Length / 1MB, 2)
        LastWrite = $_.LastWriteTime
        Path     = $_.FullName
    }
    $script:i++
    $o
}

# Display found files
$indexed | Format-Table -AutoSize

# Auto-delete mode
if ($AUTO) {
    Write-Host 'AUTO-DELETE enabled. Deleting (cutoff-filtered, exclusions enforced) files...'
    $ok = 0
    $fail = 0
    foreach ($f in $indexed) {
        if (Test-Path $f.Path) {
            Remove-Item -LiteralPath $f.Path -Force -ErrorAction SilentlyContinue
            if (-not (Test-Path $f.Path)) {
                $ok++
                Write-Host ('Deleted: ' + $f.Path)
            } else {
                $fail++
                Write-Host ('FAILED:  ' + $f.Path)
            }
        }
    }
    Write-Host ('Done. Deleted=' + $ok + ' Failed=' + $fail)
    exit 0
}

# Interactive mode - prompt user for selection
Write-Host ''
$resp = Read-Host 'Enter indexes to delete (comma-separated), A for ALL, or press Enter to cancel'

if ([string]::IsNullOrWhiteSpace($resp)) {
    Write-Host 'Cancelled. No files deleted.'
    exit 0
}

# Parse user input
$toDelete = @()
if ($resp.Trim().ToUpperInvariant() -eq 'A') {
    $toDelete = $indexed
} else {
    $nums = $resp -split '[, ]+' | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ } | Select-Object -Unique
    $toDelete = $indexed | Where-Object { $nums -contains $_.Index }
}

if (-not $toDelete) {
    Write-Host 'No valid indexes selected. No files deleted.'
    exit 0
}

# Delete selected files
$ok = 0
$fail = 0
foreach ($f in $toDelete) {
    if (Test-Path $f.Path) {
        Remove-Item -LiteralPath $f.Path -Force -ErrorAction SilentlyContinue
        if (-not (Test-Path $f.Path)) {
            $ok++
            Write-Host ('Deleted: ' + $f.Path)
        } else {
            $fail++
            Write-Host ('FAILED:  ' + $f.Path)
        }
    }
}

Write-Host ('Done. Deleted=' + $ok + ' Failed=' + $fail)
