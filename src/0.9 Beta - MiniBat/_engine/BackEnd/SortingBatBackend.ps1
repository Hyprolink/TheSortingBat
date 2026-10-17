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
.LEGAL DISCLAIMER & PARODY NOTICE
    The Sorting Bat is an independent, open-source parody utility built 
    for the retro-gaming and PC gaming community. It is not affiliated with, endorsed 
    by, or associated with Warner Bros., Nintendo, or any of their official 
    properties, characters, or franchises.
#>

param (
    [string]$RetroBatPath = "$env:SystemDrive\RetroBat",
    [string]$BasePath = ""
)

# 1. Dynamic RetroBat Detection across active filesystems
$retroBatInstalled = $false

if (Test-Path "$RetroBatPath\retrobat.exe") {
    $retroBatInstalled = $true
} else {
    $detectedRetroBat = Get-PSDrive -PSProvider FileSystem | 
        ForEach-Object { "$($_.Root)RetroBat" } | 
        Where-Object { Test-Path "$_\retrobat.exe" } | 
        Select-Object -First 1

    if ($detectedRetroBat) {
        $RetroBatPath = $detectedRetroBat
        $retroBatInstalled = $true
        Write-Host "Detected RetroBat installation at $RetroBatPath"
    } else {
        Write-Host "RetroBat not detected. Scaffolding standalone Gaming Quick Access hub."
    }
}

# 2. Co-locate the hub: Root of secondary game drive OR directly in User Profile
if (-not $BasePath) {
    if ($retroBatInstalled) {
        $targetDrive = (Get-Item $RetroBatPath -ErrorAction SilentlyContinue).PSDrive.Name
        if ($targetDrive -and $targetDrive -ne $env:SystemDrive.TrimEnd(':')) {
            # Secondary drive (D:, E:, etc.) -> Safe at root of game drive
            $BasePath = "${targetDrive}:\_GamingQuickAccess"
        } else {
            # RetroBat is on OS drive (C:) -> Keep inside User Profile
            $BasePath = "$env:USERPROFILE\_GamingQuickAccess"
        }
    } else {
        # Fallback when RetroBat is not detected -> User Profile default
        $BasePath = "$env:USERPROFILE\_GamingQuickAccess"
    }
    Write-Host "Target access hub located at: $BasePath"
}

# 2A. Auto-Pin Master Folder Function
function Pin-ToQuickAccess ($folderPath) {
    try {
        $shell = New-Object -ComObject Shell.Application
        $parent = Split-Path $folderPath
        $leaf = Split-Path $folderPath -Leaf
        $item = $shell.Namespace($parent).ParseName($leaf)
        $pinVerb = $item.Verbs() | Where-Object { $_.Name -match 'pin.*quick' -or $_.Name -match 'pintohome' }
        if ($pinVerb) {
            $pinVerb.DoIt()
            Write-Host "Successfully pinned $folderPath to Quick Access sidebar."
        }
    } catch {
        Write-Warning "Could not pin to Quick Access automatically."
    }
}

# 3. Standardize console folders as a list (Mainline Classics & Modern Systems).
$consoles = @(
    # Arcade & PC
    "mame", "fbneo", "windows", "epic", "gog", "steam",
    
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

# 4. Build overarching access directories
Write-Host "Constructing Gaming Quick Access directory structure..."
if (-not (Test-Path $BasePath)) {
    New-Item -ItemType Directory -Path $BasePath -Force | Out-Null
}

$directories = @(
    "$BasePath\_Launchers",               # Relocated to root
    "$BasePath\_OtherTools",              # New static root folder
    "$BasePath\_QuickEmulators",
    "$BasePath\_QuickMods",
    "$BasePath\_QuickRoms",
    "$BasePath\_QuickSaves",
    "$BasePath\_TexturePacks",
    "$BasePath\_ToolsForGames",
    "$BasePath\_ToolsForGames\_Firmware", # New companion folder
    "$BasePath\_ToolsForGames\_Updates",  # New companion folder
    "$BasePath\_ToolsForGames\_DLC",      # New companion folder
    "$BasePath\_ToolsForPeripherals",
    "$BasePath\Games"
)
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# 4A. Always-Available Drop Zone Instructions
$gamesText = @"
Place shortcuts to game executables or game installation directories here.
Supports PC games, standalone titles, and direct-launch applications.
"@
New-Item -Path "$BasePath\Games\_Drop_Games_Shortcuts_Here.txt" -ItemType File -Value $gamesText -Force | Out-Null

$launchersText = @"
Place shortcuts to PC game launchers and storefront clients here.
Supports Steam, Epic Games, GOG Galaxy, EA App, Ubisoft Connect, and custom launchers.
"@
New-Item -Path "$BasePath\_Launchers\_Drop_Launcher_Shortcuts_Here.txt" -ItemType File -Value $launchersText -Force | Out-Null

$otherToolsText = @"
Place shortcuts to standalone creator and productivity tools here.
Supports applications like Blender, OBS Studio, and video editors.
"@
New-Item -Path "$BasePath\_OtherTools\_Drop_Creator_Tools_Here.txt" -ItemType File -Value $otherToolsText -Force | Out-Null

$quickModsText = @"
Place shortcuts to your game mods folders or loose mod files here.
Supports textures, patches, and custom community files.
"@
New-Item -Path "$BasePath\_QuickMods\_Drop_Mods_Shortcuts_Here.txt" -ItemType File -Value $quickModsText -Force | Out-Null

$texturePacksText = @"
Place shortcuts to texture pack folders or custom texture packs here.
Supports high-resolution replacement packs, custom textures, and UI overhauls.
"@
New-Item -Path "$BasePath\_TexturePacks\_Drop_Texture_Packs_Here.txt" -ItemType File -Value $texturePacksText -Force | Out-Null

$gameToolsText = @"
Place shortcuts to tools that help with your games here.
Supports mod managers, cheat engines, and save editors.
"@
New-Item -Path "$BasePath\_ToolsForGames\_Drop_Game_Tools_Here.txt" -ItemType File -Value $gameToolsText -Force | Out-Null

$updatesText = @"
Place loose game update packages (e.g., .nsp, .pkg, .rpx) here for staging into emulators.
"@
New-Item -Path "$BasePath\_ToolsForGames\_Updates\_Drop_Updates_Here.txt" -ItemType File -Value $updatesText -Force | Out-Null

$dlcText = @"
Place loose game DLC packages here for staging into emulators.
"@
New-Item -Path "$BasePath\_ToolsForGames\_DLC\_Drop_DLC_Here.txt" -ItemType File -Value $dlcText -Force | Out-Null

$peripheralToolsText = @"
Place shortcuts for peripherals like PC lighting, keyboard/mouse software, and controller mapping here.
Supports Azeron, Razer Synapse, Logitech G Hub, antimicrox, and reWASD.
"@
New-Item -Path "$BasePath\_ToolsForPeripherals\_Drop_Peripheral_Tools_Here.txt" -ItemType File -Value $peripheralToolsText -Force | Out-Null

# 4B. Custom Folder Icon Scaffolding (The Sorting Bat)
$iconSource = Join-Path $PSScriptRoot "..\_assets\TheSortingBat.ico"
if (Test-Path $iconSource) {
    $hubIcon = Join-Path $BasePath "TheSortingBat.ico"
    Copy-Item -Path $iconSource -Destination $hubIcon -Force

    $iniPath = Join-Path $BasePath "desktop.ini"
    $iniContent = @"
[.ShellClassInfo]
IconResource=TheSortingBat.ico,0
[ViewState]
Mode=
Vid=
FolderType=Generic
"@
    Set-Content -Path $iniPath -Value $iniContent -Encoding Ascii

    # Apply Hidden + System to desktop.ini
    (Get-Item $iniPath -Force).Attributes = 'Hidden, System'

    # Hide the copied icon so the root folder remains uncluttered
    (Get-Item $hubIcon -Force).Attributes = 'Hidden'

    # Apply ReadOnly to the directory so Explorer reads desktop.ini
    (Get-Item $BasePath).Attributes = 'ReadOnly'
}

# 5. Core Link Functions & Universal Non-Admin Query Engine
$WshShell = New-Object -ComObject WScript.Shell

function Create-Link ($shortcutFile, $targetPath, $desc) {
    $link = $WshShell.CreateShortcut($shortcutFile)
    $link.TargetPath = $targetPath
    $link.Description = $desc
    $link.Save()
}

# Universal shortcut scout: Non-admin directories, handles OneDrive redirection & local paths
function Find-UserShortcut {
    param (
        [Parameter(Mandatory=$true)]
        [string]$SearchPattern,

        [string[]]$SearchRoots = @("Desktop"),

        [string[]]$AllowedExtensions = @(".lnk", ".url"),
        [switch]$Recurse
    )

    # 1. Resolve authentic physical paths (handling OneDrive & user-profile variants)
    $resolvedDirectories = [System.Collections.Generic.List[string]]::new()

    foreach ($root in $SearchRoots) {
        if (-not [string]::IsNullOrWhiteSpace($root)) {
            if (Test-Path $root) {
                $resolvedDirectories.Add($root)
            } else {
                switch ($root.ToLower()) {
                    "documents" {
                        $resolvedDirectories.Add("$env:USERPROFILE\Documents")
                        $resolvedDirectories.Add("$env:PUBLIC\Documents")
                        $regDocs = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -ErrorAction SilentlyContinue).Personal
                        if (-not [string]::IsNullOrWhiteSpace($regDocs)) { 
                            $resolvedDirectories.Add([System.Environment]::ExpandEnvironmentVariables($regDocs)) 
                        }
                    }
                    "desktop" {
                        $resolvedDirectories.Add("$env:USERPROFILE\Desktop")
                        $commonDesktop = [Environment]::GetFolderPath("CommonDesktopDirectory")
                        if (-not [string]::IsNullOrWhiteSpace($commonDesktop)) {
                            $resolvedDirectories.Add($commonDesktop)
                        }
                        $regDesk = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -ErrorAction SilentlyContinue).Desktop
                        if (-not [string]::IsNullOrWhiteSpace($regDesk)) { 
                            $resolvedDirectories.Add([System.Environment]::ExpandEnvironmentVariables($regDesk)) 
                        }
                    }
                    "downloads" {
                        $resolvedDirectories.Add("$env:USERPROFILE\Downloads")
                    }
                }
            }
        }
    }

    # Deduplicate and keep only active paths
    $validRoots = $resolvedDirectories | Where-Object { 
        (-not [string]::IsNullOrWhiteSpace($_)) -and (Test-Path $_) 
    } | Select-Object -Unique

    # 2. Match filter matches base name plus any intermediate file extensions (e.g., .txt) and/or shortcut tags ( - Shortcut)
    $escapedPattern = [regex]::Escape($SearchPattern)
    $patternRegex = "^$escapedPattern.*$"

    foreach ($dir in $validRoots) {
        $items = if ($Recurse) {
            Get-ChildItem -Path $dir -Recurse -ErrorAction SilentlyContinue
        } else {
            Get-ChildItem -Path $dir -ErrorAction SilentlyContinue
        }

        $match = $items | Where-Object {
            (-not $_.PSIsContainer) -and 
            ($AllowedExtensions -contains $_.Extension.ToLower()) -and 
            ($_.BaseName -match $patternRegex)
        } | Select-Object -First 1

        if ($match) { return $match }
    }

    return $null
}

# 5A. Conditional PC Game Launchers (Steam, Epic, GOG, RetroBat)
Write-Host "Cataloging installed PC game launchers..."
$launchersBase = "$BasePath\_Launchers"  # <

# Grab ready fixed/removable drives only once to prevent disk sleep timeouts
$readyDrives = [System.IO.DriveInfo]::GetDrives() | 
    Where-Object { $_.IsReady -and $_.DriveType -in @('Fixed', 'Removable') } | 
    ForEach-Object { $_.RootDirectory.FullName }

# Steam detection
$steamCandidates = [System.Collections.Generic.List[string]]::new()
$steamReg = Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue
if ($steamReg -and $steamReg.SteamExe) {
    $steamCandidates.Add(($steamReg.SteamExe -replace '/', '\'))
}
foreach ($d in $readyDrives) {
    $steamCandidates.Add("$d\Program Files (x86)\Steam\steam.exe")
    $steamCandidates.Add("$d\Program Files\Steam\steam.exe")
    $steamCandidates.Add("$d\Steam\steam.exe")
}
$resolvedSteam = $steamCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($resolvedSteam) {
    Create-Link "$launchersBase\Steam.lnk" "$resolvedSteam" "Launch Steam"
}

# Epic Games Launcher detection
$epicCandidates = [System.Collections.Generic.List[string]]::new()
$epicReg = Get-ItemProperty -Path "HKLM:\SOFTWARE\EpicGames\EpicGamesLauncher" -ErrorAction SilentlyContinue
if ($epicReg -and $epicReg.AppDataPath) {
    $epicCandidates.Add("$($epicReg.AppDataPath)\..\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe")
}
foreach ($d in $readyDrives) {
    $epicCandidates.Add("$d\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe")
    $epicCandidates.Add("$d\Program Files\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe")
    $epicCandidates.Add("$d\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe")
}
$resolvedEpic = $epicCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($resolvedEpic) {
    Create-Link "$launchersBase\Epic Games.lnk" "$resolvedEpic" "Launch Epic Games Launcher"
}

# GOG Galaxy detection
$gogCandidates = [System.Collections.Generic.List[string]]::new()
$gogReg = Get-ItemProperty -Path "HKLM:\SOFTWARE\GOG.com\GalaxyClient\paths" -ErrorAction SilentlyContinue
if ($gogReg -and $gogReg.CLIENT) {
    $gogCandidates.Add("$($gogReg.CLIENT)\GalaxyClient.exe")
}
foreach ($d in $readyDrives) {
    $gogCandidates.Add("$d\Program Files (x86)\GOG Galaxy\GalaxyClient.exe")
    $gogCandidates.Add("$d\Program Files\GOG Galaxy\GalaxyClient.exe")
    $gogCandidates.Add("$d\GOG Galaxy\GalaxyClient.exe")
}
$resolvedGog = $gogCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($resolvedGog) {
    Create-Link "$launchersBase\GOG Galaxy.lnk" "$resolvedGog" "Launch GOG Galaxy"
}

# RetroBat as a Launcher
if ($retroBatInstalled) {
    Create-Link "$launchersBase\RetroBat.lnk" "$RetroBatPath\retrobat.exe" "Launch RetroBat"
}

# 5B. Creator & Other Tools (_OtherTools)
Write-Host "Cataloging creator tools..."
$otherToolsDir = "$BasePath\_OtherTools"

$creatorApps = @{
    "OBS Studio" = @(
        "$env:ProgramFiles\obs-studio\bin\64bit\obs64.exe",
        "${env:ProgramFiles(x86)}\obs-studio\bin\32bit\obs32.exe"
    )
    "Blender"    = @(
        "$env:ProgramFiles\Blender Foundation\Blender*\blender.exe",
        "$env:LOCALAPPDATA\Programs\Blender Foundation\Blender*\blender.exe"
    )
}

foreach ($name in $creatorApps.Keys) {
    foreach ($pathPattern in $creatorApps[$name]) {
        $resolved = Resolve-Path $pathPattern -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($resolved -and (Test-Path $resolved.Path)) {
            Create-Link "$otherToolsDir\$name.lnk" $resolved.Path "Launch $name"
            break
        }
    }
}

# 5C. Game Tools Companions (_Firmware & _Mods link)
Write-Host "Configuring firmware and tool companions..."

# Generate _Mods shortcut inside _ToolsForGames pointing back to _QuickMods
if (Test-Path "$BasePath\_QuickMods") {
    Create-Link "$BasePath\_ToolsForGames\_Mods.lnk" "$BasePath\_QuickMods" "Quick Access Mods Directory"
}

# RetroBat BIOS conditional check
$firmwareDir = "$BasePath\_ToolsForGames\_Firmware"
$retroBatBios = "$RetroBatPath\bios"

if ($retroBatInstalled -and (Test-Path $retroBatBios)) {
    Create-Link "$firmwareDir\RetroBat BIOS.lnk" $retroBatBios "RetroBat BIOS & Firmware"
} else {
    $firmwareText = @"
Place standalone emulator BIOS files, system keys (e.g., prod.keys), or firmware here.
RetroBat BIOS directories will link here automatically if detected.
"@
    New-Item -Path "$firmwareDir\Firmware_Directions.txt" -ItemType File -Value $firmwareText -Force | Out-Null
}

# 6. Branching Logic: RetroBat Mode vs. Standalone Hub Mode
if ($retroBatInstalled) {
    Write-Host "Configuring RetroBat integration and backup structures..."
    
    # Target _backups folder inside RetroBat's existing saves folder
    $retroBatBackupsDir = "$RetroBatPath\saves\_backups"
    if (-not (Test-Path $retroBatBackupsDir)) {
        New-Item -ItemType Directory -Path $retroBatBackupsDir -Force | Out-Null
    }

    # Scaffold individual console backup directories inside RetroBat
    foreach ($console in $consoles) {
        $backupConsoleDir = "$retroBatBackupsDir\$console"
        if (-not (Test-Path $backupConsoleDir)) {
            New-Item -ItemType Directory -Path $backupConsoleDir -Force | Out-Null
        }
    }

    # Core RetroBat Pointers at Root Hub
    Create-Link "$BasePath\Run-RetroBat.lnk" "$RetroBatPath\retrobat.exe" "Launch RetroBat"
    Create-Link "$BasePath\RetroBat-Folder.lnk" "$RetroBatPath" "Open RetroBat Root Directory"
    Create-Link "$BasePath\_Backups.lnk" "$retroBatBackupsDir" "RetroBat Save Backups"
    # _CustomMedia Hub
    Write-Host "Scaffolding _CustomMedia integration pipeline..."
    
    # Build the physical hub safely inside RetroBat
    $customMediaDir = "$RetroBatPath\_CustomMedia"
    if (-not (Test-Path $customMediaDir)) { New-Item -ItemType Directory -Path $customMediaDir -Force | Out-Null }

    # Drop a lightweight shortcut into the Quick Access hub
    Create-Link "$BasePath\_ToolsForGames\_RetroBat-CustomMedia.lnk" "$customMediaDir" "RetroBat Custom Media Hub"

    # Block 1: FrontendMedia
    $frontendMediaDir = "$customMediaDir\FrontendMedia"
    if (-not (Test-Path $frontendMediaDir)) { New-Item -ItemType Directory -Path $frontendMediaDir -Force | Out-Null }
    $esConfigDir = "$RetroBatPath\emulationstation\.emulationstation"
    Create-Link "$frontendMediaDir\FrontendThemes.lnk" "$esConfigDir\themes" "EmulationStation Themes"
    Create-Link "$frontendMediaDir\IntroVideos.lnk" "$esConfigDir\video" "EmulationStation Intro Videos"
    Create-Link "$frontendMediaDir\BGM_Music.lnk" "$esConfigDir\music" "EmulationStation Background Music"
    Create-Link "$frontendMediaDir\CustomCollections.lnk" "$esConfigDir\collections" "Custom Game Collections"
    Create-Link "$frontendMediaDir\CollectionsBackups.lnk" "$esConfigDir\collections-Backup" "Collections Backup"

    # Block 2: Overlays
    $overlaysDir = "$customMediaDir\Overlays"
    if (-not (Test-Path $overlaysDir)) { New-Item -ItemType Directory -Path $overlaysDir -Force | Out-Null }
    $sysDir = "$RetroBatPath\system"
    Create-Link "$overlaysDir\Shaders.lnk" "$sysDir\shaders" "System Shaders"
    Create-Link "$overlaysDir\Tattoos.lnk" "$sysDir\tattoos" "System Tattoos"
    Create-Link "$overlaysDir\SystemDecorations.lnk" "$sysDir\decorations" "System Decorations"
    Create-Link "$overlaysDir\UserDecorations.lnk" "$RetroBatPath\decorations" "User Decorations"

    # Block 3: Sounds
    Create-Link "$customMediaDir\Sounds.lnk" "$RetroBatPath\sounds" "RetroBat Sounds & Achievements"

    # Block 4: Config
    Create-Link "$customMediaDir\Config.lnk" "$RetroBatPath\user" "RetroBat User Configs"

    # Block 5: The Metadata Pipeline (_GameImages & _GameVideos)
    $gameImagesDir = "$customMediaDir\_GameImages"
    $gameVideosDir = "$customMediaDir\_GameVideos"
    $commonImagesDir = "$gameImagesDir\_CommonConsoles"
    $commonVideosDir = "$gameVideosDir\_CommonConsoles"

    foreach ($dir in @($gameImagesDir, $gameVideosDir, $commonImagesDir, $commonVideosDir)) {
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    }

    $romsRootDir = "$RetroBatPath\roms"
    if (Test-Path $romsRootDir) {
        $allConsoles = Get-ChildItem -Path $romsRootDir -Directory

        foreach ($consoleFolder in $allConsoles) {
            $consoleName = $consoleFolder.Name
            $imgTarget = "$($consoleFolder.FullName)\images"
            $vidTarget = "$($consoleFolder.FullName)\videos"
            
            # Create physical target folders if they don't exist yet so shortcuts don't break
            if (-not (Test-Path $imgTarget)) { New-Item -ItemType Directory -Path $imgTarget -Force | Out-Null }
            if (-not (Test-Path $vidTarget)) { New-Item -ItemType Directory -Path $vidTarget -Force | Out-Null }

            Create-Link "$gameImagesDir\$consoleName.lnk" $imgTarget "$consoleName Images"
            Create-Link "$gameVideosDir\$consoleName.lnk" $vidTarget "$consoleName Videos"
            
            # Check against the master array for _CommonConsoles nesting
            if ($consoles -contains $consoleName) {
                Create-Link "$commonImagesDir\$consoleName.lnk" $imgTarget "$consoleName Images (Common)"
                Create-Link "$commonVideosDir\$consoleName.lnk" $vidTarget "$consoleName Videos (Common)"
            }
        }
    }
    Create-Link "$BasePath\_QuickSaves\_Backups.lnk" "$retroBatBackupsDir" "RetroBat Save Backups"

    # Populate Standalone Emulator Folders
    Write-Host "Cataloging standalone emulators..."
    $emulators = @{
        "RetroArch"     = "$RetroBatPath\emulators\retroarch"
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

    # Populate ROM and Save Pointers
    Write-Host "Sorting console ROMs and saves across platforms..."
    foreach ($console in $consoles) {
        $targetRomDir = "$RetroBatPath\roms\$console"
        if (Test-Path $targetRomDir) {
            Create-Link "$BasePath\_QuickRoms\$console.lnk" $targetRomDir "$console ROM Directory"
        }

        $targetSaveDir = "$RetroBatPath\saves\$console"
        if (Test-Path $targetSaveDir) {
            Create-Link "$BasePath\_QuickSaves\$console.lnk" $targetSaveDir "$console Save Directory"
        }
    }

    # Switch Updates Directory
    $switchUpdatesDir = "$RetroBatPath\roms\switchupdates"
    if (Test-Path $switchUpdatesDir) {
        Create-Link "$BasePath\_QuickRoms\switchupdates.lnk" $switchUpdatesDir "Switch Updates and DLC Directory"
    }
} else {
    Write-Host "Configuring standalone backup architecture..."
    
    # Create _backups directly inside GCA\_QuickSaves
    $standaloneBackupsDir = "$BasePath\_QuickSaves\_backups"
    if (-not (Test-Path $standaloneBackupsDir)) {
        New-Item -ItemType Directory -Path $standaloneBackupsDir -Force | Out-Null
    }

    # Provide a root shortcut to the backups directory
    Create-Link "$BasePath\_Backups.lnk" "$standaloneBackupsDir" "Game Save Backups"
    
    # Write drop-zone hints ONLY when RetroBat is missing (clean drop-zone mode)
    New-Item -Path "$BasePath\_QuickEmulators\_Drop_Emulator_Shortcuts_Here.txt" -ItemType File -Value "Place shortcuts to standalone emulator executables or folders here." -Force | Out-Null
    New-Item -Path "$BasePath\_QuickRoms\_Drop_Rom_Shortcuts_Here.txt" -ItemType File -Value "Place shortcuts to your external ROM folders or storage drives here." -Force | Out-Null
    New-Item -Path "$BasePath\_QuickSaves\_Drop_Save_Shortcuts_Here.txt" -ItemType File -Value "Place shortcuts to game save folders here." -Force | Out-Null
}

# 7. Conditional Minecraft Setup
$minecraftAppdata = "$env:APPDATA\.minecraft"

$prismCandidates = @(
    "$env:LOCALAPPDATA\Programs\PrismLauncher\prismlauncher.exe",
    "$env:ProgramFiles\PrismLauncher\prismlauncher.exe",
    "${env:ProgramFiles(x86)}\PrismLauncher\prismlauncher.exe"
)
$resolvedPrism = $prismCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

# Trigger if either Vanilla MC or Prism Launcher exists
if ((Test-Path $minecraftAppdata) -or $resolvedPrism) {
    Write-Host "Configuring Minecraft directory..."
    $mcBase = "$BasePath\Minecraft"
    
    if (-not (Test-Path $mcBase)) {
        New-Item -ItemType Directory -Path $mcBase -Force | Out-Null
    }

    if ($resolvedPrism) {
        Write-Host "Prism Launcher detected. Building modular layout..."
        
        # 1. Root Prism Shortcuts
        Create-Link "$mcBase\Prism Launcher.lnk" "$resolvedPrism" "Launch Prism Launcher"
        
        $prismInstances = "$env:APPDATA\PrismLauncher\instances"
        # Optional: ensure directory exists so Windows doesn't show a blank white shortcut icon
        if (-not (Test-Path $prismInstances)) {
            New-Item -ItemType Directory -Path $prismInstances -Force | Out-Null
        }
        Create-Link "$mcBase\Prism Launcher Instances.lnk" "$prismInstances" "Manage Prism Instances and Mods"

        # 2. Classic Minecraft Subfolder
        if (Test-Path $minecraftAppdata) {
            $classicMcDir = "$mcBase\Classic Minecraft"
            if (-not (Test-Path $classicMcDir)) {
                New-Item -ItemType Directory -Path $classicMcDir -Force | Out-Null
            }
            Create-Link "$classicMcDir\Minecraft Folder.lnk" "$minecraftAppdata" "Root Vanilla .minecraft Directory"
            Create-Link "$classicMcDir\Resource Packs.lnk" "$minecraftAppdata\resourcepacks" "Vanilla Resource Packs"
            Create-Link "$classicMcDir\Shaders.lnk" "$minecraftAppdata\shaderpacks" "Vanilla Shaderpacks"
            Create-Link "$classicMcDir\Worlds.lnk" "$minecraftAppdata\saves" "Vanilla World Files"
        }
    } else {
        Write-Host "Prism Launcher not found. Building classic layout..."
        
        # 1. Classic Minecraft Shortcuts at Root
        if (Test-Path $minecraftAppdata) {
            Create-Link "$mcBase\Minecraft Folder.lnk" "$minecraftAppdata" "Root .minecraft Directory"
            Create-Link "$mcBase\Resource Packs.lnk" "$minecraftAppdata\resourcepacks" "Resource Packs Drop-zone"
            Create-Link "$mcBase\Shaders.lnk" "$minecraftAppdata\shaderpacks" "Shaderpacks Drop-zone"
            Create-Link "$mcBase\Worlds.lnk" "$minecraftAppdata\saves" "World Files"
        }
    }
}

# 8. Conditional Terraria & tModLoader Setup (Dynamic Directory Scaffolding)
$terrariaDocuments = "$env:USERPROFILE\Documents\My Games\Terraria"
$tmodUserDir = Join-Path $terrariaDocuments "tModLoader"

if (Test-Path $terrariaDocuments) {
    Write-Host "Found local Terraria instance. Mapping shortcuts..."
    $terrariaBase = "$BasePath\Terraria"
    
    if (-not (Test-Path $terrariaBase)) {
        New-Item -ItemType Directory -Path $terrariaBase -Force | Out-Null
    }
    
    # Clean out any old .lnk files sitting inside Documents\My Games\Terraria
    Get-ChildItem -Path $terrariaDocuments -Filter "*.lnk" -ErrorAction SilentlyContinue | Remove-Item -Force

    # Locate vanilla Terraria.exe
    $terrariaExeCandidates = [System.Collections.Generic.List[string]]::new()
    if ($steamReg -and $steamReg.SteamPath) {
        $steamRoot = ($steamReg.SteamPath -replace '/', '\')
        $terrariaExeCandidates.Add("$steamRoot\steamapps\common\Terraria\Terraria.exe")
        $vdfPath = "$steamRoot\steamapps\libraryfolders.vdf"
        if (Test-Path $vdfPath) {
            Get-Content $vdfPath -ErrorAction SilentlyContinue | Where-Object { $_ -match '"path"\s+"([^"]+)"' } | ForEach-Object {
                $libPath = ($matches[1] -replace '\\\\', '\') -replace '/', '\'
                $terrariaExeCandidates.Add("$libPath\steamapps\common\Terraria\Terraria.exe")
            }
        }
    }
    foreach ($d in $readyDrives) {
        $terrariaExeCandidates.Add("$d\SteamLibrary\steamapps\common\Terraria\Terraria.exe")
        $terrariaExeCandidates.Add("$d\Program Files (x86)\Steam\steamapps\common\Terraria\Terraria.exe")
        $terrariaExeCandidates.Add("$d\Program Files\Steam\steamapps\common\Terraria\Terraria.exe")
        $terrariaExeCandidates.Add("$d\Games\Steam\steamapps\common\Terraria\Terraria.exe")
        $terrariaExeCandidates.Add("$d\Steam\steamapps\common\Terraria\Terraria.exe")
        $terrariaExeCandidates.Add("$d\GOG Galaxy\Games\Terraria\Terraria.exe")
    }
    $resolvedTerrariaExe = $terrariaExeCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

    # Locate tModLoader.exe
    $resolvedTmodExe = $null
    $desktopTmod = Find-UserShortcut -SearchPattern "tModLoader"
    
    if ($desktopTmod) {
        $resolvedTmodExe = "DESKTOP_SHORTCUT"
    } else {
        $tmodExeCandidates = [System.Collections.Generic.List[string]]::new()
        if ($steamReg -and $steamReg.SteamPath) {
            $steamRoot = ($steamReg.SteamPath -replace '/', '\')
            $tmodExeCandidates.Add("$steamRoot\steamapps\common\tModLoader\tModLoader.exe")
            $vdfPath = "$steamRoot\steamapps\libraryfolders.vdf"
            if (Test-Path $vdfPath) {
                Get-Content $vdfPath -ErrorAction SilentlyContinue | Where-Object { $_ -match '"path"\s+"([^"]+)"' } | ForEach-Object {
                    $libPath = ($matches[1] -replace '\\\\', '\') -replace '/', '\'
                    $tmodExeCandidates.Add("$libPath\steamapps\common\tModLoader\tModLoader.exe")
                }
            }
        }
        foreach ($d in $readyDrives) {
            $tmodExeCandidates.Add("$d\SteamLibrary\steamapps\common\tModLoader\tModLoader.exe")
            $tmodExeCandidates.Add("$d\Program Files (x86)\Steam\steamapps\common\tModLoader\tModLoader.exe")
            $tmodExeCandidates.Add("$d\Program Files\Steam\steamapps\common\tModLoader\tModLoader.exe")
            $tmodExeCandidates.Add("$d\Games\Steam\steamapps\common\tModLoader\tModLoader.exe")
            $tmodExeCandidates.Add("$d\Steam\steamapps\common\tModLoader\tModLoader.exe")
        }
        $resolvedTmodExe = $tmodExeCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
    }

    # Branching Logic
    if ((Test-Path $tmodUserDir) -or $resolvedTmodExe) {
        Write-Host "tModLoader detected. Segmenting Classic and Modded environments..."
        
        # 1. Classic Terraria Subfolder
        $classicTerrariaDir = "$terrariaBase\Classic Terraria"
        if (-not (Test-Path $classicTerrariaDir)) {
            New-Item -ItemType Directory -Path $classicTerrariaDir -Force | Out-Null
        }
        Create-Link "$classicTerrariaDir\Terraria Folder.lnk" "$terrariaDocuments" "Root Terraria User Directory"
        Create-Link "$classicTerrariaDir\Worlds.lnk" "$terrariaDocuments\Worlds" "Vanilla Terraria Worlds"
        Create-Link "$classicTerrariaDir\Players.lnk" "$terrariaDocuments\Players" "Vanilla Terraria Players"
        if (Test-Path "$terrariaDocuments\ResourcePacks") {
            Create-Link "$classicTerrariaDir\Resource Packs.lnk" "$terrariaDocuments\ResourcePacks" "Vanilla Resource Packs"
        }
        if ($resolvedTerrariaExe) {
            Create-Link "$classicTerrariaDir\Terraria.lnk" "$resolvedTerrariaExe" "Launch Terraria (Vanilla)"
        }

        # 2. tModLoader Folder
        $tmodFolderDir = "$terrariaBase\tModLoader Folder"
        if (-not (Test-Path $tmodFolderDir)) {
            New-Item -ItemType Directory -Path $tmodFolderDir -Force | Out-Null
        }
        Create-Link "$tmodFolderDir\tModLoader Folder.lnk" "$tmodUserDir" "Root tModLoader User Directory"
        Create-Link "$tmodFolderDir\Mods.lnk" "$tmodUserDir\Mods" "tModLoader Mods"
        Create-Link "$tmodFolderDir\Worlds.lnk" "$tmodUserDir\Worlds" "tModLoader Worlds"
        Create-Link "$tmodFolderDir\Players.lnk" "$tmodUserDir\Players" "tModLoader Players"

        if (Test-Path "$tmodUserDir\ModConfigs") {
            Create-Link "$tmodFolderDir\ModConfigs.lnk" "$tmodUserDir\ModConfigs" "tModLoader Mod Configurations"
        }
        if (Test-Path "$tmodUserDir\ResourcePacks") {
            Create-Link "$tmodFolderDir\Resource Packs.lnk" "$tmodUserDir\ResourcePacks" "tModLoader Resource Packs"
        }

        # 3. Root tModLoader Launcher
        if ($resolvedTmodExe -eq "DESKTOP_SHORTCUT") {
            $ext = $desktopTmod.Extension
            Copy-Item -Path $desktopTmod.FullName -Destination "$terrariaBase\tModLoader$ext" -Force
        } elseif ($resolvedTmodExe) {
            Create-Link "$terrariaBase\tModLoader.lnk" "$resolvedTmodExe" "Launch tModLoader"
        }

    } else {
        Write-Host "tModLoader not found. Building classic root layout..."
        
        # Classic Layout at Root
        Create-Link "$terrariaBase\Terraria Folder.lnk" "$terrariaDocuments" "Root Terraria User Directory"
        Create-Link "$terrariaBase\Worlds.lnk" "$terrariaDocuments\Worlds" "Vanilla Terraria Worlds"
        Create-Link "$terrariaBase\Players.lnk" "$terrariaDocuments\Players" "Vanilla Terraria Players"
        if (Test-Path "$terrariaDocuments\ResourcePacks") {
            Create-Link "$terrariaBase\Resource Packs.lnk" "$terrariaDocuments\ResourcePacks" "Vanilla Resource Packs"
        }
        if ($resolvedTerrariaExe) {
            Create-Link "$terrariaBase\Terraria.lnk" "$resolvedTerrariaExe" "Launch Terraria"
        }
    }
}

# Pin the master hub directory to Quick Access
Pin-ToQuickAccess $BasePath

Write-Host "Environment configured successfully under $BasePath!"
