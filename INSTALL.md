# Web Installation & Execution

## Quick Start - Download and Run

**Replace `YOUR_URL_HERE` with your actual script hosting URL**

### PowerShell Commands

**Interactive Mode (Review before deleting)**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1"
```

**Auto-Delete Mode (Automatically delete all found files)**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1 1"
```

**Execute directly from memory (no file download)**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-WebRequest -Uri 'YOUR_URL_HERE' -UseBasicParsing).Content"
```

**Execute from memory with Auto-Delete**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$env:SC_AUTODELETE='1'; Invoke-Expression (Invoke-WebRequest -Uri 'YOUR_URL_HERE' -UseBasicParsing).Content"
```

### CMD (Command Prompt) Commands

**Interactive Mode**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile %TEMP%\sccleaner.ps1; & %TEMP%\sccleaner.ps1"
```

**Auto-Delete Mode**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile %TEMP%\sccleaner.ps1; & %TEMP%\sccleaner.ps1 1"
```

**Execute directly from memory**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-WebRequest -Uri 'YOUR_URL_HERE' -UseBasicParsing).Content"
```

**Execute from memory with Auto-Delete**
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$env:SC_AUTODELETE='1'; Invoke-Expression (Invoke-WebRequest -Uri 'YOUR_URL_HERE' -UseBasicParsing).Content"
```

## Hosting Options

### Option 1: GitHub Raw URL
1. Upload `sccleaner.ps1` to a GitHub repository
2. Use the raw file URL: `https://raw.githubusercontent.com/username/repo/main/sccleaner.ps1`

### Option 2: GitHub Gist
1. Create a new Gist at https://gist.github.com
2. Upload `sccleaner.ps1`
3. Use the raw file URL: `https://gist.githubusercontent.com/username/gist-id/raw/sccleaner.ps1`

### Option 3: Your Own Web Server
1. Host `sccleaner.ps1` on your web server
2. Ensure it's accessible via HTTPS
3. Use the direct URL to the file

### Option 4: Pastebin / Similar Services
1. Upload the script content to a paste service
2. Use the raw/direct link URL

## Example URLs (Replace with your actual URL)

```powershell
# Replace YOUR_URL_HERE with your actual script URL
$scriptUrl = 'https://raw.githubusercontent.com/yourusername/sccleaner/main/sccleaner.ps1'

# Download and execute
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '$scriptUrl' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1"
```

## Security Considerations

- Always verify the source URL before executing
- Consider hosting on a trusted domain
- Use HTTPS to prevent MITM attacks
- Review the script content before running
- Test in a non-production environment first

## Troubleshooting

### Execution Policy Errors
If you encounter execution policy errors, use:
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File script.ps1
```

### SSL/TLS Certificate Errors
If you get certificate errors, you can temporarily bypass (NOT RECOMMENDED for production):
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest ...
```

### Proxy Issues
If behind a proxy, configure proxy settings:
```powershell
$proxy = New-Object System.Net.WebProxy('http://proxy:port')
$proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
[System.Net.WebRequest]::DefaultWebProxy = $proxy
```
