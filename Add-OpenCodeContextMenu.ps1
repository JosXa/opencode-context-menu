# Add-OpenCodeContextMenu.ps1
# Adds "Open in OpenCode" context menu entry for folders in Windows Explorer
#
# PREREQUISITES:
# - Administrator privileges
# - Windows Terminal with an "OpenCode" profile configured
#
# USAGE:
#   Run as administrator:
#   powershell -ExecutionPolicy Bypass -File .\Add-OpenCodeContextMenu.ps1
#
# NOTES:
# - Direct command execution from Explorer context menu doesn't work due to 
#   non-interactive process context. We use a batch file launcher as a workaround.
# - The "OpenCode" profile in Windows Terminal must be configured with your
#   preferred shell and the opencode command.

$registryPaths = @(
    "Registry::HKEY_CLASSES_ROOT\Directory\shell\OpenInOpenCode",
    "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\OpenInOpenCode"
)

$batchFile = Join-Path $PSScriptRoot "open-opencode.bat"

try {
    # Create the batch file launcher
    $batchContent = @"
@echo off
wt.exe -p "OpenCode" -d "%~1"
"@
    Set-Content -Path $batchFile -Value $batchContent -Encoding ASCII

    foreach ($registryPath in $registryPaths) {
        $commandPath = "$registryPath\command"
        
        # Create the main registry key
        if (-not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force | Out-Null
        }
        
        # Set the display name
        Set-ItemProperty -Path $registryPath -Name "(Default)" -Value "Open in OpenCode"
        
        # Set the OpenCode icon
        $iconPath = Join-Path $PSScriptRoot "opencode-icon.ico"
        Set-ItemProperty -Path $registryPath -Name "Icon" -Value $iconPath
        
        # Create the command subkey
        if (-not (Test-Path $commandPath)) {
            New-Item -Path $commandPath -Force | Out-Null
        }
        
        # Set the command to execute via batch file
        # %V is replaced with the selected folder path
        # We use a batch file because direct wt.exe commands don't work from Explorer's non-interactive context
        $command = "`"$batchFile`" `"%V`""
        Set-ItemProperty -Path $commandPath -Name "(Default)" -Value $command
    }
    
    Write-Host "Successfully added 'Open in OpenCode' to context menu!" -ForegroundColor Green
    Write-Host "Right-click any folder in Windows Explorer to see the new option." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "REMINDER: Ensure you have an 'OpenCode' profile configured in Windows Terminal." -ForegroundColor Yellow
    Write-Host "See README.md for profile configuration examples." -ForegroundColor Yellow
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "Make sure you are running this script as Administrator." -ForegroundColor Yellow
}
