@echo off
:: ==============================================================================
:: The Sorting Bat / BatCave Suite
:: Copyright (c) 2026 Caden B. (Hypro / HyproLink).
:: Licensed under the GNU General Public License v3.0 (https://www.gnu.org/licenses/gpl-3.0)
:: ==============================================================================
title The Sorting Bat (Fast Build)
cls

:: Consolidated single-line instant render
powershell -NoProfile -Command "Write-Host '========================================================' -ForegroundColor DarkYellow; Write-Host '          \"Ah! Right then... Hmm... Right. ' -ForegroundColor DarkYellow; Write-Host '     Plenty of ' -ForegroundColor DarkYellow -NoNewline; Write-Host 'COURAGE' -ForegroundColor Green -NoNewline; Write-Host ', I see. Great ' -ForegroundColor DarkYellow -NoNewline; Write-Host 'WISDOM' -ForegroundColor Blue -NoNewline; Write-Host ', and ' -ForegroundColor DarkYellow -NoNewline; Write-Host 'POWER' -ForegroundColor Red -NoNewline; Write-Host ' too... ' -ForegroundColor DarkYellow; Write-Host '         There''s talent, oh my goodness, yes... ' -ForegroundColor DarkYellow; Write-Host '    ...But where to put you? Let''s see: ' -ForegroundColor DarkYellow -NoNewline; Write-Host 'RETROBAT!\"' -ForegroundColor Magenta; Write-Host '========================================================' -ForegroundColor DarkYellow"

echo.
echo The Sorting Bat is analyzing your system architectures...
echo.

:: Launches the backend script and waits for execution to complete
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\SortingBatBackend.ps1"

echo.
powershell -NoProfile -Command "Write-Host '========================================================' -ForegroundColor Yellow; Write-Host '     \"Better be... ' -ForegroundColor Yellow -NoNewline; Write-Host 'GAMING QUICK ACCESS!\"' -ForegroundColor Green; Write-Host '========================================================' -ForegroundColor Yellow; Write-Host ''; Write-Host 'This script was made for ' -ForegroundColor White -NoNewline; Write-Host 'YOU' -ForegroundColor DarkYellow -NoNewline; Write-Host ' by ' -ForegroundColor White -NoNewline; Write-Host 'Hypro' -ForegroundColor Cyan"
echo.

echo Execution complete. You may close this window (X) or press any key to exit.
pause >nul
exit
