<#
.SYNOPSIS
    The Sorting Bat Cleanup & Rollback Utility | Sorting Bat / BatCave Suite
.DESCRIPTION
    Safely uninstalls and removes the scaffolding directory (_GamingQuickAccess) 
    created by The Sorting Bat. Deletes only generated system shortcuts and access 
    links; original game directories, emulators, and saves remain intact.
.AUTHOR
    Caden B. (Hypro / HyproLink)
.LICENSE
    GNU General Public License v3.0
.LEGAL DISCLAIMER & PARODY NOTICE
    The Sorting Bat is an independent, open-source parody utility built 
    for the retro-gaming and PC gaming community. It is not affiliated with, endorsed 
    by, or associated with Warner Bros., Nintendo, or any of their official 
    properties, characters, or franchises.
#>

Write-Host "WARNING: This will remove the '_GamingQuickAccess' hub and its generated shortcuts." -ForegroundColor Yellow
$confirm = Read-Host "Are you sure you want to uninstall and remove this directory? (Y/N)"
if ($confirm -notmatch '^[Yy]$') {
    Write-Host "Uninstallation aborted by user."
    exit
}

[Console]::ResetColor()
Write-Host "==========================================================" -ForegroundColor DarkGray
Write-Host " The Sorting Bat: Hub Teardown & Uninstall Utility         " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor DarkGray
Write-Host ""

# 1. Resolve Target _GamingQuickAccess Location
$targetHub = "$env:USERPROFILE\_GamingQuickAccess"

if (-not (Test-Path $targetHub)) {
    # Check secondary drives if relocated
    $driveFallback = Get-PSDrive -PSProvider FileSystem | 
        ForEach-Object { "$($_.Root)_GamingQuickAccess" } | 
        Where-Object { Test-Path $_ } | 
        Select-Object -First 1

    if ($driveFallback) {
        $targetHub = $driveFallback
    }
}

# 2. Check Existence
if (-not (Test-Path $targetHub)) {
    Write-Host "_GamingQuickAccess folder not yet installed." -ForegroundColor Red
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor DarkGray
    Write-Host "Press any key to exit..." -NoNewline
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Host ""
    exit 0
}

# 3. Direct Deletion of Directory
Write-Host "Located active hub: $targetHub" -ForegroundColor White

try {
    Write-Host "Removing $targetHub..." -ForegroundColor Yellow
    Remove-Item -Path $targetHub -Recurse -Force -ErrorAction Stop
    Write-Host "Successfully removed _GamingQuickAccess directory!" -ForegroundColor Green
    Write-Host "All external saves, emulators, and RetroBat directories remain intact." -ForegroundColor Gray
} catch {
    Write-Error "Failed to delete directory: $_"
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Red
Write-Host "                 [ MANUAL ACTION REQUIRED ]              " -ForegroundColor Red
Write-Host "==========================================================" -ForegroundColor Red
Write-Host "Ensure you remove _GamingQuickAccess from the Quick Access" -ForegroundColor Yellow
Write-Host "menu manually:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Open File Explorer." -ForegroundColor White
Write-Host "  2. Right-click '_GamingQuickAccess' on the left sidebar." -ForegroundColor White
Write-Host "  3. Select 'Unpin from Quick access' (or 'Unpin from Home')." -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Red
Write-Host ""
Write-Host "Teardown complete. Press any key to exit..." -NoNewline
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""