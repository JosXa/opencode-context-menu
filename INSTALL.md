# Installation Guide

Complete step-by-step instructions for installing the OpenCode Context Menu on Windows.

## System Requirements

- Windows 10 or Windows 11
- Windows Terminal (comes pre-installed on Windows 11)
- OpenCode CLI installed and working
- Administrator privileges

## Step 1: Install Windows Terminal (if needed)

Windows 11 users already have this. Windows 10 users can install from:
- Microsoft Store: Search for "Windows Terminal"
- Or download from: https://github.com/microsoft/terminal/releases

## Step 2: Configure Windows Terminal Profile

1. Open Windows Terminal
2. Press `Ctrl+,` to open settings (or click the dropdown arrow → Settings)
3. Click "Open JSON file" in the bottom-left corner
4. Find the `"profiles"` section, then the `"list"` array
5. Add this profile (adjust the shell path for your system):

```json
{
    "commandline": "powershell -Command opencode",
    "guid": "{generate-a-guid}",
    "name": "OpenCode"
}
```

**Important Notes:**
- The `name` field MUST be exactly `"OpenCode"` (case-sensitive)
- Generate a GUID by running `[guid]::NewGuid()` in PowerShell, then paste it between the braces
- Adjust `commandline` for your shell: `powershell -Command opencode`, `cmd /k opencode`, or `nu -c opencode`

6. Save the file and close the editor
7. Verify the profile works by running in CMD or PowerShell:
   ```
   wt.exe -p "OpenCode"
   ```
   This should open Windows Terminal with OpenCode running.

## Step 3: Download the Scripts

Clone or download this repository to a location on your computer. For example:
```
D:\tools\opencode-context-menu\
```

The folder should contain:
- `Add-OpenCodeContextMenu.ps1`
- `Remove-OpenCodeContextMenu.ps1`
- `opencode-icon.ico`
- `README.md`

## Step 4: Run the Installation Script

### Option A: Using PowerShell as Administrator

1. Right-click the Windows Start button
2. Select "Windows Terminal (Admin)" or "PowerShell (Admin)"
3. Navigate to the folder containing the scripts:
   ```powershell
   cd "D:\tools\opencode-context-menu"
   ```
4. Run the installation script:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Add-OpenCodeContextMenu.ps1
   ```

### Option B: Using gsudo (if installed)

If you have gsudo installed:
```powershell
gsudo powershell -ExecutionPolicy Bypass -File .\Add-OpenCodeContextMenu.ps1
```

### Expected Output

You should see:
```
Removed registry entry: Registry::HKEY_CLASSES_ROOT\Directory\shell\OpenInOpenCode
Successfully added 'Open in OpenCode' to context menu!
Right-click any folder in Windows Explorer to see the new option.

REMINDER: Ensure you have an 'OpenCode' profile configured in Windows Terminal.
See README.md for profile configuration examples.
```

## Step 5: Test the Installation

1. Open File Explorer (Windows + E)
2. Navigate to any folder
3. Right-click the folder
4. You should see "Open in OpenCode" in the context menu
5. Click it - Windows Terminal should open with OpenCode running in that directory

## Troubleshooting

### "Access Denied" Error
- Make sure you're running PowerShell as Administrator
- Check that your user account has admin rights

### Context Menu Entry Doesn't Appear
- Try refreshing File Explorer (F5) or restart it via Task Manager
- Verify the registry entries were created:
  - Press Windows + R
  - Type `regedit` and press Enter
  - Navigate to `HKEY_CLASSES_ROOT\Directory\shell\OpenInOpenCode`
  - The entry should exist with a "command" subkey

### OpenCode Doesn't Launch
- Verify the Windows Terminal profile exists and is named exactly "OpenCode"
- Test the profile manually: `wt.exe -p "OpenCode"`
- Ensure `opencode` command works in your shell
- Check that the batch file was created: `open-opencode.bat` should exist in the script folder

### Wrong Directory Opens
- This is rare, but verify `open-opencode.bat` contains:
  ```batch
  @echo off
  wt.exe -p "OpenCode" -d "%~1"
  ```

## Uninstallation

To remove the context menu entry:

1. Open PowerShell as Administrator
2. Navigate to the script folder
3. Run:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Remove-OpenCodeContextMenu.ps1
   ```

This will:
- Remove all registry entries
- Delete the batch file
- Clean up completely

## Advanced Configuration

### Custom Icon

Replace `opencode-icon.ico` with your own icon file (must be .ico format). Run the installation script again to apply the change.

### Custom Menu Text

Edit `Add-OpenCodeContextMenu.ps1` and change this line:
```powershell
Set-ItemProperty -Path $registryPath -Name "(Default)" -Value "Open in OpenCode"
```

Change `"Open in OpenCode"` to your preferred text.

### Changing the Shell

Edit your Windows Terminal profile's `commandline` field and re-run the installation script (no need to uninstall first).
