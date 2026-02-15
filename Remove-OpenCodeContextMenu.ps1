# Remove-OpenCodeContextMenu.ps1
# Removes "Open in OpenCode" context menu entry from Windows Explorer
#
# PREREQUISITES:
# - Administrator privileges
#
# USAGE:
#   Run as administrator:
#   powershell -ExecutionPolicy Bypass -File .\Remove-OpenCodeContextMenu.ps1

$registryPaths = @(
    "Registry::HKEY_CLASSES_ROOT\Directory\shell\OpenInOpenCode",
    "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\OpenInOpenCode"
)

$batchFile = Join-Path $PSScriptRoot "open-opencode.bat"
$removed = $false

try {
    foreach ($registryPath in $registryPaths) {
        if (Test-Path $registryPath) {
            Remove-Item -Path $registryPath -Recurse -Force
            Write-Host "Removed registry entry: $registryPath" -ForegroundColor Green
            $removed = $true
        }
    }
    
    # Remove the batch file if it exists
    if (Test-Path $batchFile) {
        Remove-Item -Path $batchFile -Force
        Write-Host "Removed batch file: $batchFile" -ForegroundColor Green
        $removed = $true
    }
    
    if ($removed) {
        Write-Host "`nSuccessfully removed 'Open in OpenCode' from context menu!" -ForegroundColor Green
    }
    else {
        Write-Host "'Open in OpenCode' context menu entry not found." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "Make sure you are running this script as Administrator." -ForegroundColor Yellow
}
