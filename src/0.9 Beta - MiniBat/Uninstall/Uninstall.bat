@echo off
:: LEGAL DISCLAIMER & PARODY NOTICE:
:: The Sorting Bat is an independent, open-source parody utility built 
:: for the retro-gaming community. It is not affiliated with, endorsed 
:: by, or associated with Warner Bros., Nintendo, or any of their official 
:: properties, characters, or franchises.
title The Sorting Bat (Uninstall)
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\_engine\BackEnd\RollbackBat.ps1"