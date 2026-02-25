# PowerShell script to enable Developer Mode for Flutter symlink support
# Run this script as Administrator

Write-Host "Enabling Developer Mode for Flutter symlink support..." -ForegroundColor Yellow

# Method 1: Enable Developer Mode via Registry
try {
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
    
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }
    
    Set-ItemProperty -Path $registryPath -Name "AllowDevelopmentWithoutDevLicense" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $registryPath -Name "AllowAllTrustedApps" -Value 1 -Type DWord -Force
    
    Write-Host "✓ Registry settings updated" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to update registry (may need admin): $($_.Exception.Message)" -ForegroundColor Red
}

# Method 2: Set environment variable (User level - works without admin)
try {
    [System.Environment]::SetEnvironmentVariable("_FLUTTER_WINDOWS_SYMLINKS", "1", "User")
    $env:_FLUTTER_WINDOWS_SYMLINKS = "1"
    Write-Host "✓ Environment variable set for current user" -ForegroundColor Green
    Write-Host "  Note: Restart terminal/IDE for permanent effect" -ForegroundColor Yellow
} catch {
    Write-Host "✗ Failed to set environment variable: $($_.Exception.Message)" -ForegroundColor Red
}

# Method 3: Open Settings page for manual enable
Write-Host "`nOpening Windows Settings..." -ForegroundColor Cyan
Start-Process "ms-settings:developers"

Write-Host "`nPlease follow these steps:" -ForegroundColor Yellow
Write-Host "1. In the Settings window that opened, toggle 'Developer Mode' to ON" -ForegroundColor White
Write-Host "2. Click 'Yes' when prompted" -ForegroundColor White
Write-Host "3. Wait for the installation to complete" -ForegroundColor White
Write-Host "4. Restart your terminal/IDE" -ForegroundColor White
Write-Host "`nAfter enabling Developer Mode, run: flutter pub get" -ForegroundColor Cyan

