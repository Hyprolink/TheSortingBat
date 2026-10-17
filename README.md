# The Sorting Bat / BatBuilder
### A Zero-Bloat Gaming Hub & Directory Organizer

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D6.svg)]()
[![Status](https://img.shields.io/badge/Release-v0.9--Beta-brightgreen.svg)](https://github.com/Hyprolink/TheSortingBat/releases)

An automated setup utility that consolidates emulators, PC storefronts, and standalone titles into a single organized launchpad (`_GamingQuickAccess`) using only native Windows shortcuts and folder drop-zones.

---

> ### 📦 Just want to run the tool?
> Grab the package directly from the **[Latest Release](../../releases/latest)**, extract `TheSortingBat_v0.9_Beta_MiniBat.zip`, and launch your preferred runner.

## 📺 Video Walkthrough
[![Watch the Setup Guide](https://img.youtube.com/vi/jMe_oAwhhF0/hqdefault.jpg)](https://www.youtube.com/watch?v=jMe_oAwhhF0)

---

## What It Does
* **Master Hub Scaffolding:** Instantly constructs a clean `_GamingQuickAccess` directory automatically pinned to File Explorer's Quick Access.
* **Smart Emulator & ROM Mapping:** Connects directly with RetroBat if present, or creates standalone organized drop-zones if you run clean.
* **Launcher & PC Game Detection:** Automatically discovers and maps shortcuts for Steam, Epic Games, GOG Galaxy, Minecraft (including Prism Launcher), and Terraria / tModLoader.
* **Auxiliary Support:** Creates structured drop-zones for mods, texture packs, game tools, and controller software with built-in helper text files.

> ### 🛡️ Clean, Transparent & Non-Invasive
> * **Zero Background Services:** Installs no persistent services, scheduled tasks, or startup bloat.
> * **Safe Shortcut Scanning:** Discovers paths via read-only queries strictly for `.lnk` and `.url` files; never alters original game directories or user binaries.
> * **Instant Rollback:** Run `Uninstall\Uninstall.bat` to instantly delete the hub directory without leaving leftover files or touching your saves.

---

## 🛠️ Recommended Ecosystem & Integrations (Optional)
The Sorting Bat works out of the box with zero external dependencies, but integrates seamlessly with:
* [RetroBat Official](https://www.retrobat.org) — Automated all-in-one EmulationStation frontend
* [Prism Launcher](https://prismlauncher.org) — Custom Minecraft instance management
* [tModLoader on Steam](https://store.steampowered.com/app/1281930/tModLoader/) — Dedicated Terraria modding engine and launcher
* [Tailscale](https://tailscale.com) — Zero-config peer-to-peer mesh VPN for zero-port-forward LAN co-op
* [Sunshine](https://github.com/LizardByte/Sunshine) — Self-hosted, low-latency game streaming host
* [Moonlight Game Streaming](https://moonlight-stream.org) — Open-source game streaming client for local and remote play
* [HidHide (Nefarius)](https://github.com/nefarius/HidHide) — Controller device cloaking to prevent double-input issues
* [XOutput](https://github.com/csutorasa/XOutput) — DirectInput to XInput controller mapping wrapper
> **Note on Navigation:** GitHub natively navigates links in the same browser window; use `Ctrl + Click` (or middle-click) on any report link to view the VirusTotal analysis in a separate browser tab.

---

## Quickstart Guide

1. Download **`TheSortingBat_v0.9_Beta_MiniBat.zip`** from the **[Latest Release](../../releases/latest)**.
2. Extract the archive to any folder on your PC.
3. Launch your preferred runner:
   * **`TheSortingBat.bat`**: Full interactive wizard with dialogue.
   * **`FastBatBuild.bat`**: Headless instant generation (5–8 seconds).
4. Access your consolidated folders directly from Windows Explorer under **`_GamingQuickAccess`**.

> **Note on Uninstalling:** Run **`Uninstall\Uninstall.bat`** to remove `_GamingQuickAccess`. After the script completes, right-click the leftover sidebar shortcut in File Explorer and select **Unpin from Quick access** (or **Unpin from Home**).

For a full historical record of version updates and fixes, see the **[Changelog](CHANGELOG.md)**.

---

## 📜 Legal Disclaimer & Parody Notice
The Sorting Bat is an independent, open-source parody utility built for the retro-gaming and PC gaming community. It is not affiliated with, endorsed by, or associated with Warner Bros., Nintendo, or any of their official properties, characters, or franchises. All trademarks belong to their respective holders.

---

## ⚖️ Attribution & License
* **Development & Architecture:** ([@Hyprolink](https://github.com/Hyprolink))
* **Mascot Design & Character Art (Berry Sorter):** MapleTheMage
* **License:** Distributed under the [GNU General Public License v3.0 (GPLv3)](LICENSE).
