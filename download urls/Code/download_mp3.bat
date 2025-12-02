@echo off
setlocal enabledelayedexpansion
echo ================================
echo Download Files - Overcome cross-origin restrictions
echo ================================

REM Path to your text file
set "filelist=files.txt"

REM Loop through each line in the text file
for /f "tokens=1* delims= " %%A in (%filelist%) do (
    set "output=%%A"
    set "url=%%B"
    echo Downloading !url! to !output! ...
    REM curl -L -o "!output!" "!url!"
	curl -L -H "User-Agent: Mozilla/5.0" -H "Referer: https://radiotruyen.me" -o "!output!" "!url!"

)

echo All downloads completed.
pause
