# The Sorting Bat / BatBuilder
### A RetroBat Directory Shortcut Wizard & Folder Organizer

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

An automated post-install setup script to structure directory hierarchies, configure standard shortcuts, and prep launch pipelines for RetroBat quickly to save you tons of time and energy

---

> ### 📦 Just want to run the tool?
> **Do not download files individually from the general file list!**  
> Grab the ready-to-run package directly from the **[Latest Release](../../releases/latest)**, extract `TheSortingBat.zip`, and run the launcher.

## What It Does
* **Automated Hub Scaffolding:** Instantly constructs a clean `_GamingQuickAccess` master directory on your system root.
* **No-Bloat Direct Shortcuts:** Generates clean `.lnk` pointers for the most known and utilized standalone emulators, console ROMs, save directories, and backups without clutter.
* **Auxiliary Support:** Implements dedicated drop-zones for mods, texture packs, game tools, and controller utilities with built-in helper text files.
* **Dynamic Game Detection:** Automatically detects existing local installations of games like Minecraft (including Prism Launcher) and Terraria to map direct user-data paths without breaking if you don't have them.

> ### 🛡️ Clean, Transparent & Non-Invasive
> * **No Background Daemons:** Does not install persistent background services, startup entries, or background tasks.
> * **Zero Binary Bloat:** Runs strictly native Windows Batch and PowerShell scripts; no hidden `.exe`, `.dll`, or bundled payload files.
> * **Purely Additive:** Builds standard directory structures and shortcut pointers (`.lnk`); does not alter, patch, or overwrite existing game files or emulators.
> * **Fully Auditable:** 100% human-readable source code. Inspect [`src/SortingBatBackend.ps1`](src/SortingBatBackend.ps1) before running to see exactly what every line touches.

---

## Prerequisites & Upstream Projects Recommended:
* [RetroBat Official](https://www.retrobat.org) - EmulationStation frontend
* [HidHide (Nefarius)](https://github.com/nefarius/HidHide) - Controller device cloaking
* [XOutput](https://github.com/csutorasa/XOutput) - DirectInput to XInput wrapper
* [Prism Launcher](https://prismlauncher.org) - Custom Minecraft instance management

---

## Quickstart Guide

1. Install RetroBat via its official setup installer to the default drive location (`C:\RetroBat`).
2. Clone or download this repository to your system.
3. Unzip `TheSortingBat.zip`.
4. Right-click `TheSortingBat.bat` and select **Run as Administrator** *(REQUIRED to create shortcuts and folders in the root drive)*.
5. Populate your game folders and run your titles through the `_GamingQuickAccess` master folder (`C:\_GamingQuickAccess`).

### 📺 Setup Walkthrough & Demo
[![Watch the Setup Guide](https://img.youtube.com/vi/jMe_oAwhhF0/hqdefault.jpg)](https://www.youtube.com/watch?v=jMe_oAwhhF0)

> **Tip:** Want to skip the theatrical CLI intro? Run `GottaGoFast/FastBatBuild.bat` instead for an instant build.
---
> p.s. Shame on you, I worked really hard on that UX... /hj

---

## License
Distributed under the **GNU General Public License v3.0 (GPLv3)**. See [`LICENSE`](LICENSE) for more information.

---
Intended and tested for Windows systems
---
Created by **Hypro**
