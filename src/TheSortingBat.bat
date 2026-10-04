@echo off
:: ==============================================================================
:: The Sorting Bat / BatCave Suite
:: Copyright (c) 2026 Caden B. (Hypro / HyproLink).
:: Licensed under the GNU General Public License v3.0 (https://www.gnu.org/licenses/gpl-3.0)
:: ==============================================================================
title The Sorting Bat
cls

:: ========================================================
:: CONFIGURABLE TIMERS (In seconds: 0, 0.5, 1, 1.5, 2, etc.)
:: Set any variable to 0 to bypass its delay entirely.
:: ========================================================
set DELAY_INTRO=0.8
set DELAY_THINKING=1
set DELAY_HOUSE_REVEAL=1.5
set DELAY_ANNOUNCEMENT=0.5
set DELAY_SORTING=1.5
set DELAY_REVEAL=1
set DELAY_SUSPENSE=1.5

:: 6 = Yellow/Mustard, 2 = Green, 1 = Blue, 4 = Red, 5 = Magenta, 14 = Bright Gold
powershell -Command "Write-Host '========================================================' -ForegroundColor DarkYellow"
:: The Sorting Bat Appears
powershell -Command "Write-Host '           /\                 /\' -ForegroundColor DarkGray"
powershell -Command "Write-Host '          / \''._   (\_/)   _.''/ \' -ForegroundColor DarkGray"
powershell -Command "Write-Host '         /_.''''._''--(''.'')--''_.''''._\' -ForegroundColor DarkGray"
powershell -Command "Write-Host '                 \___/' -ForegroundColor DarkGray"
:: 6 = Yellow/Mustard, 2 = Green, 1 = Blue, 4 = Red, 5 = Magenta, 14 = Bright Gold
powershell -Command "Write-Host '========================================================' -ForegroundColor DarkYellow"
powershell -Command "Write-Host '          \"Ah! Right then... Hmm... Right. ' -ForegroundColor DarkYellow"
powershell -Command "Start-Sleep -Seconds %DELAY_INTRO%"

powershell -Command "Write-Host '     Plenty of ' -ForegroundColor DarkYellow -NoNewline; Write-Host 'COURAGE' -ForegroundColor Green -NoNewline; Write-Host ', I see. Great ' -ForegroundColor DarkYellow -NoNewline; Write-Host 'WISDOM' -ForegroundColor Blue -NoNewline; Write-Host ', and ' -ForegroundColor DarkYellow -NoNewline; Write-Host 'POWER' -ForegroundColor Red -NoNewline; Write-Host ' too... ' -ForegroundColor DarkYellow"
powershell -Command "Start-Sleep -Seconds %DELAY_THINKING%"

powershell -Command "Write-Host '         There''s talent, oh my goodness, yes... ' -ForegroundColor DarkYellow"
powershell -Command "Start-Sleep -Seconds %DELAY_THINKING%"

:: Suspense build-up for the house reveal
powershell -Command "Write-Host '    ...But where to put you? Let''s see: ' -ForegroundColor DarkYellow -NoNewline"
powershell -Command "Start-Sleep -Seconds %DELAY_HOUSE_REVEAL%"

:: The reveal
powershell -Command "Write-Host 'RETROBAT!\"' -ForegroundColor Magenta"
powershell -Command "Write-Host '========================================================' -ForegroundColor DarkYellow"
powershell -Command "Start-Sleep -Seconds %DELAY_ANNOUNCEMENT%"

echo.
echo The Sorting Bat is analyzing your system architectures...
echo.
powershell -Command "Start-Sleep -Seconds %DELAY_SORTING%"

:: Launches the backend script and waits for execution to complete
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0SortingBatBackend.ps1"

powershell -Command "Start-Sleep -Seconds %DELAY_REVEAL%"
echo.
powershell -Command "Write-Host '========================================================' -ForegroundColor Yellow"
powershell -Command "Write-Host '     \"Better be... ' -ForegroundColor Yellow -NoNewline"
powershell -Command "Start-Sleep -Seconds %DELAY_SUSPENSE%"
powershell -Command "Write-Host 'GAMING QUICK ACCESS!\"' -ForegroundColor Green"
powershell -Command "Write-Host '========================================================' -ForegroundColor Yellow"
echo.

:: Author signature stamp
powershell -Command "Write-Host 'This script was made for ' -ForegroundColor White -NoNewline; Write-Host 'YOU' -ForegroundColor DarkYellow -NoNewline; Write-Host ' by ' -ForegroundColor White -NoNewline; Write-Host 'Hypro' -ForegroundColor Cyan"
echo.

echo Execution complete. You may close this window (X) or press any key to exit.
pause >nul
exit
