<#
.SYNOPSIS
    The Sorting Bat Directory Organizing Wizard | Sorting Bat / BatCave Suite
.DESCRIPTION
    Automated environment scaffolding, save backup architecture, 
    and directory shortcut generator for RetroBat and PC gaming setups.
.AUTHOR
    Caden B. (Hypro / HyproLink)
.COPYRIGHT
    Copyright (c) 2026 Caden B. a.k.a. HyproLink.
.LICENSE
    Licensed under the GNU General Public License v3.0. See LICENSE file in the
    project root for full license information, or visit https://www.gnu.org/licenses/gpl-3.0
#>

param (
    [string]$RetroBatPath = "$env:SystemDrive\RetroBat",
    [string]$BasePath = ""
)

# 1. Dynamic installation check: scan root directories of active filesystems if default path is not found
if (-not (Test-Path "$RetroBatPath\retrobat.exe")) {
    $detectedRetroBat = Get-PSDrive -PSProvider FileSystem | 
        ForEach-Object { "$($_.Root)RetroBat" } | 
        Where-Object { Test-Path "$_\retrobat.exe" } | 
        Select-Object -First 1

    if ($detectedRetroBat) {
        $RetroBatPath = $detectedRetroBat
        Write-Host "Detected RetroBat installation at $RetroBatPath" -ForegroundColor DarkCyan
    } else {
        Write-Warning "Could not detect retrobat.exe across active drives. Falling back to default: $RetroBatPath"
    }
}

# 2. Co-locate the hub on the same drive partition as RetroBat (or OS root if uninstalled)
if (-not $BasePath) {
    $targetDrive = (Get-Item $RetroBatPath -ErrorAction SilentlyContinue).PSDrive.Name
    if (-not $targetDrive) { $targetDrive = $env:SystemDrive.TrimEnd(':') }
    $BasePath = "${targetDrive}:\_GamingQuickAccess"
    Write-Host "Target access hub co-located on drive ${targetDrive}: -> $BasePath" -ForegroundColor DarkCyan
}

# 0. Theatrical delay so users can read the initial terminal banner
Start-Sleep -Seconds 2

# 1. Standardize console folders as a list (Mainline Classics & Modern Systems).
$consoles = @(
    # Arcade & PC
    "mame", "windows", "epic", "gog", "steam", "dolphin",
    
    # Sony
    "psx", "ps2", "ps3", "ps4", "psp", "psvita",
    
    # Microsoft
    "xbox", "xbox360",
    
    # Nintendo
    "nes", "snes", "n64", "gamecube", "wii", "wiiu", "switch",
    "gb", "gbc", "gba", "gba2players", "nds", "3ds",
    
    # Sega
    "mastersystem", "megadrive", "megacd", "sega32x", "saturn", "dreamcast", "gamegear"
)

# 2. Build overarching access directories
Write-Host "Constructing Gaming Quick Access directory structure..." -ForegroundColor Cyan
$directories = @(
    "$BasePath\_QuickEmulators",
    "$BasePath\_QuickMods",
    "$BasePath\_QuickRoms",
    "$BasePath\_QuickSaves",
    "$BasePath\_TexturePacks",
    "$BasePath\_ToolsForGames",
    "$BasePath\_ToolsForPeripherals",
    "$BasePath\Games"
)
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# 2A. User instructions placed within empty drop zones
New-Item -Path "$BasePath\Games\README.txt" -ItemType File -Value "Place shortcuts to game executables here." -Force | Out-Null

$quickModsText = @"
Place shortcuts to your game mods folders or loose mod files here.
Supports textures, patches, and custom community files.
"@
New-Item -Path "$BasePath\_QuickMods\_Drop_Mods_Shortcuts_Here.txt" -ItemType File -Value $quickModsText -Force | Out-Null

$gameToolsText = @"
Place shortcuts to tools that help with your games here.
Supports mod managers, cheat engines, and save editors.
"@
New-Item -Path "$BasePath\_ToolsForGames\_Drop_Game_Tools_Here.txt" -ItemType File -Value $gameToolsText -Force | Out-Null

$peripheralToolsText = @"
Place shortcuts for peripherals like PC lighting, keyboard/mouse software, and controller mapping here.
"@
New-Item -Path "$BasePath\_ToolsForPeripherals\_Drop_Peripheral_Tools_Here.txt" -ItemType File -Value $peripheralToolsText -Force | Out-Null

# 2B. Target _backups folder inside RetroBat's existing saves folder
if (-not (Test-Path "$RetroBatPath\saves\_backups")) {
    New-Item -ItemType Directory -Path "$RetroBatPath\saves\_backups" -Force | Out-Null
}

# 2C. Scaffold individual console backup directories
foreach ($console in $consoles) {
    $backupConsoleDir = "$RetroBatPath\saves\_backups\$console"
    if (-not (Test-Path $backupConsoleDir)) {
        New-Item -ItemType Directory -Path $backupConsoleDir -Force | Out-Null
    }
}

# Brief pacing delay between directory construction and link generation
Start-Sleep -Milliseconds 750

# 3. COM Object for Shortcut Generation
$WshShell = New-Object -ComObject WScript.Shell

function Create-Link ($shortcutFile, $targetPath, $desc) {
    $link = $WshShell.CreateShortcut($shortcutFile)
    $link.TargetPath = $targetPath
    $link.Description = $desc
    $link.Save()
}

# 4. Generate Subdirectory Shortcuts (No suffix text)
Write-Host "Generating core RetroBat and save backup pointers..." -ForegroundColor Cyan
Create-Link "$BasePath\Run-RetroBat.lnk" "$RetroBatPath\retrobat.exe" "Launch RetroBat"
Create-Link "$BasePath\RetroBat-Folder.lnk" "$RetroBatPath" "Open RetroBat Root Directory"
Create-Link "$BasePath\_Backups.lnk" "$RetroBatPath\saves\_backups" "RetroBat Save Backups"
Create-Link "$BasePath\_QuickSaves\_Backups.lnk" "$RetroBatPath\saves\_backups" "RetroBat Save Backups"

# 4A. Populate Standalone Emulator Folders (Strict console matches only + Xenia-Manager)
Write-Host "Cataloging standalone emulators..." -ForegroundColor Cyan
$emulators = @{
    # The Backbone
    "RetroArch"     = "$RetroBatPath\emulators\retroarch"

    # PlayStation & Xbox
    "DuckStation"   = "$RetroBatPath\emulators\duckstation"
    "PCSX2"         = "$RetroBatPath\emulators\pcsx2"
    "RPCS3"         = "$RetroBatPath\emulators\rpcs3"
    "ShadPS4"       = "$RetroBatPath\emulators\shadps4"
    "PPSSPP"        = "$RetroBatPath\emulators\ppsspp"
    "Vita3K"        = "$RetroBatPath\emulators\vita3k"
    "Xemu"          = "$RetroBatPath\emulators\xemu"
    "Xenia"         = "$RetroBatPath\emulators\xenia"
    "Xenia-Canary"  = "$RetroBatPath\emulators\xenia-canary"
    "Xenia-Manager" = "$RetroBatPath\emulators\xenia-manager"

    # Nintendo
    "Mesen"         = "$RetroBatPath\emulators\mesen"
    "mGBA"          = "$RetroBatPath\emulators\mgba"
    "DeSmuME"       = "$RetroBatPath\emulators\desmume"
    "MelonDS"       = "$RetroBatPath\emulators\melonds"
    "Azahar"        = "$RetroBatPath\emulators\azahar"
    "Simple64"      = "$RetroBatPath\emulators\simple64"
    "Project64"     = "$RetroBatPath\emulators\project64"
    "RMG"           = "$RetroBatPath\emulators\rmg"
    "SNES9x"        = "$RetroBatPath\emulators\snes9x"
    "Dolphin-emu"   = "$RetroBatPath\emulators\dolphin-emu"
    "Cemu"          = "$RetroBatPath\emulators\cemu"
    "Eden"          = "$RetroBatPath\emulators\eden"
    "Ryujinx"       = "$RetroBatPath\emulators\ryujinx"
    "Suyu"          = "$RetroBatPath\emulators\suyu"
    "Sudachi"       = "$RetroBatPath\emulators\sudachi"

    # Sega & Arcade
    "Flycast"       = "$RetroBatPath\emulators\flycast"
    "Redream"       = "$RetroBatPath\emulators\redream"
    "MAME"          = "$RetroBatPath\emulators\mame"
    "YabaSanshiro"  = "$RetroBatPath\emulators\yabasanshiro"
    "MegaCD"        = "$RetroBatPath\emulators\megacd"
    "Kega-Fusion"   = "$RetroBatPath\emulators\kega-fusion"
}

foreach ($emu in $emulators.Keys) {
    if (Test-Path $emulators[$emu]) {
        Create-Link "$BasePath\_QuickEmulators\$emu.lnk" $emulators[$emu] "$emu Core Folder"
    }
}

# 5. Populate Mainline Console ROM and Save Pointers (Clean names only)
Write-Host "Sorting console ROMs and saves across platforms..." -ForegroundColor Cyan

# Exclude dolphin strictly from _QuickRoms
$romExclusions = @("dolphin")

foreach ($console in $consoles) {
    # ROM Shortcuts
    if ($console -notin $romExclusions) {
        $targetRomDir = "$RetroBatPath\roms\$console"
        if (Test-Path $targetRomDir) {
            Create-Link "$BasePath\_QuickRoms\$console.lnk" $targetRomDir "$console ROM Directory"
        }
    }

    # Save Shortcuts (Keeps full save coverage)
    $targetSaveDir = "$RetroBatPath\saves\$console"
    Create-Link "$BasePath\_QuickSaves\$console.lnk" $targetSaveDir "$console Save Directory"
}

# 5A. Special Case: Switch Updates Directory
$switchUpdatesDir = "$RetroBatPath\roms\switchupdates"
if (Test-Path $switchUpdatesDir) {
    Create-Link "$BasePath\_QuickRoms\switchupdates.lnk" $switchUpdatesDir "Switch Updates and DLC Directory"
}

# 6. Conditional Minecraft Setup
$minecraftAppdata = "$env:APPDATA\.minecraft"

if (Test-Path $minecraftAppdata) {
    Write-Host "Found local Minecraft instance. Mapping shortcuts..." -ForegroundColor DarkCyan
    $mcBase = "$BasePath\Minecraft"
    
    if (-not (Test-Path $mcBase)) {
        New-Item -ItemType Directory -Path $mcBase -Force | Out-Null
    }

    Create-Link "$mcBase\Minecraft Folder.lnk" "$minecraftAppdata" "Root .minecraft Directory"
    Create-Link "$mcBase\Resource Packs.lnk" "$minecraftAppdata\resourcepacks" "Resource Packs Drop-zone"
    Create-Link "$mcBase\Shaders.lnk" "$minecraftAppdata\shaderpacks" "Shaderpacks Drop-zone"
    Create-Link "$mcBase\Worlds.lnk" "$minecraftAppdata\saves" "World Files"

    $prismCandidates = @(
        "$env:LOCALAPPDATA\Programs\PrismLauncher\prismlauncher.exe",
        "$env:ProgramFiles\PrismLauncher\prismlauncher.exe",
        "${env:ProgramFiles(x86)}\PrismLauncher\prismlauncher.exe"
    )

    $resolvedPrism = $prismCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

    if ($resolvedPrism) {
        Create-Link "$mcBase\Prism Launcher.lnk" "$resolvedPrism" "Launch Prism"
    }
}

# 7. Conditional Terraria Setup (Dynamic Directory Scaffolding)
$terrariaDocuments = "$env:USERPROFILE\Documents\My Games\Terraria"

if (Test-Path $terrariaDocuments) {
    Write-Host "Found local Terraria instance. Mapping shortcuts..." -ForegroundColor DarkCyan
    $terrariaBase = "$BasePath\Terraria"
    
    # Creates the main Terraria root folder only if game configuration exists
    if (-not (Test-Path $terrariaBase)) {
        New-Item -ItemType Directory -Path $terrariaBase -Force | Out-Null
    }
    
    Create-Link "$terrariaBase\Terraria Folder.lnk" "$terrariaDocuments" "Root Terraria User Directory"
    Create-Link "$terrariaBase\Worlds.lnk" "$terrariaDocuments\Worlds" "Terraria Worlds Save Directory"
    Create-Link "$terrariaBase\Players.lnk" "$terrariaDocuments\Players" "Terraria Players Character Directory"
}

# Brief pause before declaring final victory
Start-Sleep -Seconds 1
Write-Host "Environment configured successfully under $BasePath!" -ForegroundColor Green