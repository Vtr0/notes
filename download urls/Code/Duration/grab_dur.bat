@echo off
setlocal enabledelayedexpansion

rem === Input and output files ===
set "INPUT_FILE=input.txt"
set "OUTPUT_FILE=output.txt"

rem === Clear old output ===
if exist "%OUTPUT_FILE%" del "%OUTPUT_FILE%"

echo Processing MP3 durations...
echo -------------------------------------

for /f "tokens=1,* delims= " %%A in (%INPUT_FILE%) do (
    set "NAME=%%A"
    set "URL=%%B"
    echo Getting duration for !NAME!...

    rem Run curl and ffprobe as a single line
	rem orginal command which can run on cmd window: curl -L -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"  -e "https://radiotruyen.me"  "https://files.radiotruyen.me/4817--vdck/BvEMe46abfYCX9AIjFdTfg==.mp3" | ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 -
    for /f "usebackq tokens=* delims=" %%D in (`
	curl -L -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"  -e "https://radiotruyen.me" "!URL!" ^| ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 - 2^>nul
      `) do (
        set "DURATION=%%D"
    )

    if not defined DURATION (
        echo !NAME! ERROR >> "%OUTPUT_FILE%"
        echo   Failed to get duration for !NAME!
    ) else (
        rem --- Convert seconds to H:MM:SS ---
        for /f "tokens=1,2 delims=." %%m in ("!DURATION!") do set /a "SEC=%%m"
        set /a "HOUR=SEC/3600"
        set /a "MIN=(SEC%%3600)/60"
        set /a "SEC=SEC%%60"

        rem Format with leading zeros
        if !MIN! lss 10 set "MIN=0!MIN!"
        if !SEC! lss 10 set "SEC=0!SEC!"

        if !HOUR! gtr 0 (
            set "TIME=!HOUR!:!MIN!:!SEC!"
        ) else (
            set "TIME=!MIN!:!SEC!"
        )

        echo {"tit": "!NAME!", "dur": "!TIME!"},>>"%OUTPUT_FILE%"
        echo   SUCCESS !NAME! : !TIME!
    )

    set "DURATION="
)

echo -------------------------------------
echo Results saved to "%OUTPUT_FILE%"
pause
