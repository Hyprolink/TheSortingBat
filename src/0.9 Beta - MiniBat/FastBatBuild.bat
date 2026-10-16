@echo off
@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)
:: ==============================================================================
:: The Sorting Bat / BatCave Suite
:: ==============================================================================
:: The Sorting Bat / BatCave Suite
:: Copyright (c) 2026 Caden B. (Hypro / HyproLink).
:: Licensed under the GNU General Public License v3.0 (https://www.gnu.org/licenses/gpl-3.0)
:: ==============================================================================
:: LEGAL DISCLAIMER & PARODY NOTICE:
:: The Sorting Bat is an independent, open-source parody utility built 
:: for the retro-gaming community. It is not affiliated with, endorsed 
:: by, or associated with Warner Bros., Nintendo, or any of their official 
:: properties, characters, or franchises.
:: ============================================================================
title The Sorting Bat (Fast Build)
cls

echo ========================================================
echo The Sorting Bat is analyzing your system architectures...
echo.
echo.
echo Berry Sorter is sniffing out fruit... and file directories...
echo ========================================================
echo.

:: Launches the backend script from the sibling BackEnd directory
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0_engine\BackEnd\SortingBatBackend.ps1"

echo.
echo ========================================================
echo Execution complete. You may close this window (X) or press any key to exit.
echo ========================================================
pause >nul
exit