# Quick Start - Run Commands

## PowerShell Commands

### Interactive Mode (Review before deleting)
```powershell
.\sccleaner.ps1
```

### Auto-Delete Mode (Automatically delete all found files)
```powershell
.\sccleaner.ps1 1
```

### With Execution Policy Bypass (if needed)
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\sccleaner.ps1
```

### Auto-Delete with Execution Policy Bypass
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\sccleaner.ps1 1
```

## CMD (Command Prompt) Commands

### Interactive Mode
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -File sccleaner.ps1
```

### Auto-Delete Mode
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -File sccleaner.ps1 1
```

### If script is in a different directory
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\path\to\sccleaner\sccleaner.ps1"
```

### Auto-Delete from different directory
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\path\to\sccleaner\sccleaner.ps1" 1
```

## Web Download and Run (PowerShell)

### Interactive Mode
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1"
```

### Auto-Delete Mode
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile $env:TEMP\sccleaner.ps1; & $env:TEMP\sccleaner.ps1 1"
```

## Web Download and Run (CMD)

### Interactive Mode
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile %TEMP%\sccleaner.ps1; & %TEMP%\sccleaner.ps1"
```

### Auto-Delete Mode
```cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'YOUR_URL_HERE' -OutFile %TEMP%\sccleaner.ps1; & %TEMP%\sccleaner.ps1 1"
```

## Using Environment Variable for Auto-Delete

### PowerShell
```powershell
$env:SC_AUTODELETE = '1'
.\sccleaner.ps1
```

### CMD
```cmd
set SC_AUTODELETE=1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File sccleaner.ps1
```

## Notes

- **Interactive Mode**: Script will show found files and ask which ones to delete
- **Auto-Delete Mode**: Script will automatically delete all found files without prompting
- **Execution Policy**: Use `-ExecutionPolicy Bypass` if you get execution policy errors
- **NoProfile**: `-NoProfile` speeds up execution by skipping profile loading
- Replace `YOUR_URL_HERE` with your actual script hosting URL for web execution
