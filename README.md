# OpenCode Context Menu for Windows

Add "Open in OpenCode" to Windows Explorer's right-click context menu for quick access to your favorite AI coding assistant.

## Features

- Right-click any folder in Windows Explorer to open it in OpenCode
- Works from folder icons and folder backgrounds
- Uses Windows Terminal with proper PTY support
- Customizable shell integration (NuShell, PowerShell, CMD)
- Clean installation and removal scripts

## Quick Start

### Prerequisites

1. Windows Terminal installed
2. OpenCode CLI installed and accessible
3. Administrator access (for registry modifications)

### Installation

1. **Configure Windows Terminal Profile**

   Add this profile to your Windows Terminal `settings.json` (in the `profiles.list` array):

   ```json
   {
       "commandline": "powershell -Command opencode",
       "guid": "{generate-a-guid}",
       "name": "OpenCode"
   }
   ```

   Generate a GUID by running `[guid]::NewGuid()` in PowerShell, then paste it between the braces.

   Adjust `commandline` for your shell: `powershell -Command opencode`, `cmd /k opencode`, or `nu -c opencode`.

2. **Run the installation script**

   Open PowerShell as Administrator and run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Add-OpenCodeContextMenu.ps1
   ```

   Or with [gsudo](https://github.com/gerardog/gsudo):

   ```powershell
   gsudo powershell -ExecutionPolicy Bypass -File .\Add-OpenCodeContextMenu.ps1
   ```

3. **Test it out**

   Right-click any folder in Windows Explorer. You should see "Open in OpenCode" in the context menu.

### Uninstallation

Run the removal script as Administrator:

```powershell
powershell -ExecutionPolicy Bypass -File .\Remove-OpenCodeContextMenu.ps1
```

Or with [gsudo](https://github.com/gerardog/gsudo):

```powershell
gsudo powershell -ExecutionPolicy Bypass -File .\Remove-OpenCodeContextMenu.ps1
```

## How It Works

Windows Explorer spawns context menu processes in a non-interactive context, which causes CLI tools like `opencode` to hang when launched directly. 

Our solution:
1. Create a named Windows Terminal profile with `opencode` as the command
2. Launch that profile with `-p "OpenCode" -d "%V"` to override the working directory
3. This provides `opencode` with a proper interactive PTY environment

The installation script creates:
- Registry entries at `HKEY_CLASSES_ROOT\Directory\shell\OpenInOpenCode`
- Registry entries at `HKEY_CLASSES_ROOT\Directory\Background\shell\OpenInOpenCode`
- A batch file launcher at `open-opencode.bat`

## Troubleshooting

**Context menu entry doesn't appear:**
- Ensure you ran the installation script as Administrator
- Check that Windows Terminal is installed
- Verify the "OpenCode" profile exists in Windows Terminal settings

**OpenCode doesn't launch:**
- Verify the profile name in Windows Terminal is exactly "OpenCode"
- Test running `wt.exe -p "OpenCode"` from CMD to ensure the profile works
- Check that `opencode` command works in your shell

**Wrong directory opens:**
- Ensure the batch file uses `"%~1"` to properly handle the folder path
- Check that Windows Terminal receives the `-d` parameter correctly

## Files

- `Add-OpenCodeContextMenu.ps1` - Installation script
- `Remove-OpenCodeContextMenu.ps1` - Removal script  
- `open-opencode.bat` - Batch file launcher (auto-generated)
- `opencode-icon.ico` - Context menu icon

## License

MIT License - See LICENSE file for details

## Contributing

Contributions welcome! Please ensure:
- Scripts are tested on Windows 10/11
- PowerShell follows best practices
- Documentation is updated accordingly
