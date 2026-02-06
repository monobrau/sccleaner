# Download and Run Script - Helper script for web deployment
# This script downloads sccleaner.ps1 from a URL and executes it

param(
    [Parameter(Mandatory=$false)]
    [string]$ScriptUrl = '',
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoDelete,
    
    [Parameter(Mandatory=$false)]
    [switch]$InMemory
)

# Default script URL (update this with your actual hosting URL)
$defaultUrl = 'https://raw.githubusercontent.com/yourusername/sccleaner/main/sccleaner.ps1'

if ([string]::IsNullOrWhiteSpace($ScriptUrl)) {
    $ScriptUrl = $defaultUrl
}

Write-Host "Downloading SCCleaner from: $ScriptUrl" -ForegroundColor Cyan

try {
    if ($InMemory) {
        # Execute directly from memory without saving to disk
        Write-Host "Executing script in memory..." -ForegroundColor Yellow
        $scriptContent = (Invoke-WebRequest -Uri $ScriptUrl -UseBasicParsing).Content
        
        if ($AutoDelete) {
            $env:SC_AUTODELETE = '1'
        }
        
        Invoke-Expression $scriptContent
    } else {
        # Download to temp file and execute
        $tempFile = Join-Path $env:TEMP "sccleaner-$(Get-Date -Format 'yyyyMMdd-HHmmss').ps1"
        Write-Host "Downloading to: $tempFile" -ForegroundColor Yellow
        
        Invoke-WebRequest -Uri $ScriptUrl -OutFile $tempFile -UseBasicParsing
        
        Write-Host "Executing script..." -ForegroundColor Green
        
        if ($AutoDelete) {
            & $tempFile 1
        } else {
            & $tempFile
        }
        
        # Clean up temp file
        if (Test-Path $tempFile) {
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        }
    }
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "Failed to download or execute script from: $ScriptUrl" -ForegroundColor Red
    exit 1
}
