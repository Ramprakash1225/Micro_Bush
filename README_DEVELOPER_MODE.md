# Fixing Flutter Symlink Support on Windows

## Quick Fix (Temporary - Current Session Only)

Run this command in your terminal:
```powershell
$env:_FLUTTER_WINDOWS_SYMLINKS='1'; flutter pub get
```

## Permanent Fix Options

### Option 1: Enable Developer Mode (Recommended)

1. **Open Windows Settings:**
   - Press `Win + I` or run: `start ms-settings:developers`
   - Or double-click `enable_developer_mode.ps1` (run as Administrator)

2. **Enable Developer Mode:**
   - Toggle "Developer Mode" to **ON**
   - Click "Yes" when prompted
   - Wait for installation to complete

3. **Restart your terminal/IDE**

### Option 2: Set Environment Variable (User Level)

Run this PowerShell command (no admin needed):
```powershell
[System.Environment]::SetEnvironmentVariable("_FLUTTER_WINDOWS_SYMLINKS", "1", "User")
```

Then restart your terminal/IDE.

### Option 3: Set Environment Variable (System Level - Requires Admin)

Run PowerShell as Administrator:
```powershell
[System.Environment]::SetEnvironmentVariable("_FLUTTER_WINDOWS_SYMLINKS", "1", "Machine")
```

Then restart your terminal/IDE.

## Verify Fix

After applying the fix, run:
```bash
flutter pub get
```

If it works without the symlink error, you're all set!

## Note

The environment variable method (`_FLUTTER_WINDOWS_SYMLINKS=1`) is a workaround that allows Flutter to work without Developer Mode, but enabling Developer Mode is the recommended solution for full Windows development support.

