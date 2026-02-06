# Web Execution Commands

Replace `YOUR_URL_HERE` with your actual script hosting URL (e.g., GitHub raw URL, Gist URL, or web server URL).

## PowerShell - Web Download Commands

### Interactive Mode (Review before deleting)

**Download to temp file and run:**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1"
```

**Execute directly from memory (no file saved):**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-WebRequest -Uri 'YOUR_URL_HERE' -UseBasicParsing).Content"
```

### Auto-Delete Mode (Automatically delete all)

**Download to temp file and run:**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1 1"
```

**Execute from memory with auto-delete:**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$env:SC_AUTODELETE='1'; Invoke-Expression (Invoke-WebRequest -Uri 'YOUR_URL_HERE' -UseBasicParsing).Content"
```

## CMD (Command Prompt) - Web Download Commands

### Interactive Mode

**Download to temp file and run:**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile %TEMP%\sccleaner.ps1; & %TEMP%\sccleaner.ps1"
```

**Execute directly from memory:**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-WebRequest -Uri 'YOUR_URL_HERE' -UseBasicParsing).Content"
```

### Auto-Delete Mode

**Download to temp file and run:**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile %TEMP%\sccleaner.ps1; & %TEMP%\sccleaner.ps1 1"
```

**Execute from memory with auto-delete:**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$env:SC_AUTODELETE='1'; Invoke-Expression (Invoke-WebRequest -Uri 'YOUR_URL_HERE' -UseBasicParsing).Content"
```

## With Error Handling and TLS 1.2

**PowerShell:**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1 } catch { Write-Host 'Error: ' $_.Exception.Message }"
```

**CMD:**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile %TEMP%\sccleaner.ps1; & %TEMP%\sccleaner.ps1 } catch { Write-Host 'Error: ' $_.Exception.Message }"
```

## Example URLs

### GitHub Raw URL Format
```
https://raw.githubusercontent.com/username/repo/branch/sccleaner.ps1
```

**Example:**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/yourusername/sccleaner/main/sccleaner.ps1' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1"
```

### GitHub Gist Raw URL Format
```
https://gist.githubusercontent.com/username/gist-id/raw/filename.ps1
```

**Example:**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://gist.githubusercontent.com/yourusername/abc123def456/raw/sccleaner.ps1' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1"
```

### Your Own Web Server
```
https://yourdomain.com/path/to/sccleaner.ps1
```

**Example:**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://example.com/scripts/sccleaner.ps1' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1"
```

## One-Liner Examples (Copy & Paste Ready)

### Most Common - PowerShell Interactive
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1"
```

### Most Common - PowerShell Auto-Delete
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1 1"
```

### Most Common - CMD Interactive
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile %TEMP%\sccleaner.ps1; & %TEMP%\sccleaner.ps1"
```

### Most Common - CMD Auto-Delete
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile %TEMP%\sccleaner.ps1; & %TEMP%\sccleaner.ps1 1"
```

## Notes

- **Download to temp**: Script is saved to `%TEMP%\sccleaner.ps1` and then executed
- **Execute from memory**: Script runs directly without saving to disk (more secure but requires internet during execution)
- **Auto-delete mode**: Automatically deletes all found files without prompting
- **Interactive mode**: Shows found files and asks which ones to delete
- Always replace `YOUR_URL_HERE` with your actual script URL before using
