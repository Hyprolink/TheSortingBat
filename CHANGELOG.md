# Changelog

All notable changes to **The Sorting Bat** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v0.9-Beta] - 2026-10-16

### 🚀 Core Engine & User Experience
* **MiniBat Fast Engine (`FastBatBuild.bat`):** Headless, instant setup that builds the entire hub in 5 seconds flat with no introductory fluff or dialogue delays
* **Auto-Elevation (Double-Click Ready):** Builder batch files now self-elevate permissions automatically—no manual "Run as Administrator" right-click required
* **Drive-Letter Portability:** Automatically scans and detects RetroBat across all connected internal and external drives, building correctly even if games aren't installed on your `C:\` drive
* **User-Profile Staging:** Master directory defaults cleanly to your user profile folder (`%USERPROFILE%\_GamingQuickAccess`) and automatically pins itself directly to the File Explorer sidebar for one-click access
* **Custom Dark-Mode Berry Sorter Icon:** Packaged with an offline `.ico` featuring a die-cut white border designed by MapleTheMage, keeping the folder icon sharp and visible against Windows 10/11 dark themes

### 🎮 Smart Game & Launcher Detection
* **Smart Scout System:** Dynamically scans common locations (Desktop, Start Menu, User Folders) for installed game shortcuts (`.lnk`/`.url`), ignoring duplicate clutter like text files or broken links
* **Minecraft & Prism Launcher Handling:**
  * Detects if Prism Launcher is installed
  * If Prism is found, cleanly stages standard Minecraft into a `Classic Minecraft` folder and creates an instant shortcut directly to your buried `%appdata%` Prism instances folder
* **Terraria & tModLoader OneDrive-Safe Routing:**
  * Automatically separates vanilla Terraria and tModLoader into dedicated launch folders
  * Uses native NTFS directory junctions (`mklink /J`) rather than symbolic links to bypass OneDrive desktop-sync looping bugs and permission crashes
* **Dedicated Launchers Hub:** Promoted `_Launchers` straight to the root of `_GamingQuickAccess` to keep Steam, Epic Games, GOG, and custom launchers accessible in one spot
* **Non-Gaming Creator Separation:** Added an `_OtherTools` drop-zone so creative and development software (like Blender or editing tools) doesn't clutter up gaming storefronts

### 🕹️ RetroBat & Emulation Integration
* **Conditional Folder Scaffolding:** Emulation folders (`saves`, `roms`, `backups`, and `_Firmware`) only map to RetroBat if RetroBat is actually installed on your system—keeping your directory clean if you only play standalone PC games
* **Custom Media Routing:** Automatically hooks into RetroBat's theme, metadata, shader, and background music folders, placing an easy-access `Custom Media` hub inside `_ToolsForGames` for drag-and-drop manual scraping
* **Expansion Drop-Zones:** Added clean, placeholder drop-zones equipped with helper `.txt` instructions for ROM patches, firmware updates, DLC, and mods (`_Mods` routes right to `_QuickMods`)

### 🛡️ Safety, Transparency & Security
* **Non-Destructive Safe Rollback (`Uninstall\Uninstall.bat`):** Completely deletes the generated `_GamingQuickAccess` hub with zero leftover clutter without ever touching your original game installs, RetroBat roots, or save files. Prompts with clear manual instructions on how to unpin from the sidebar.
* **Separated Engine Architecture:** Codebase restructured into dedicated `_engine` subfolders (`BackEnd`, `_assets`, `Uninstall`), keeping maintenance modular and scripts easy to audit
* **Cryptographic Verification:** Every release includes SHA-256 integrity checksum files and a PowerShell check command so users can verify their download hasn't been tampered with or modified in transit
* **Legal & Parody Notice:** Full GPLv3 open-source licensing, community disclaimers, and clear mascot attribution

---

## [v0.1-Alpha] - 2026-10-06
- Initial proof-of-concept batch script and folder taxonomy mapping