# BATCH DOWNLOAD FILES USING CURL

## Install cURL
Curl is a command-line tool for transferring data from or to a server using URLs. You can go [github](https://github.com/curl/curl) or [https://curl.se/](https://curl.se/). To install cURL on window
```batch
winget install cUrl
```

## Download single url
Single window prompt to download a file. Note that curl can download a file even if the link preven cross-origin, even if the link does not work when paste directly into browser
```batch
curl -L -H "User-Agent: Mozilla/5.0" -H "Referer: https://radiotruyen.me" -o "121.mp3" "https://files.radiotruyen.me/4817--vdck/vNUmXGaQ6CidTRYZOL~ViQ==.mp3"
```

## Batch download and rename
Batch file to using curl to download even if radiotruyen.me prevents cross-origin and we cannot download file directly from browser

### input.txt file format
files.txt should look as follows
```txt
119.mp3 https://files.radiotruyen.me/4817--vdck/eY2inG1vzzMsz9JbENsT0g==.mp3
120.mp3 https://files.radiotruyen.me/4817--vdck/qZ%2B74vpV54Ih8ujG4l5MOg==.mp3
```
### Batch file to run cUrl
Create batch file as follows:
```batch
REM download_mp3.bat
@echo off
setlocal enabledelayedexpansion

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
```

# GET DURATION FOR ALL MP3 FILES

## Using batch file to get duration for REMOTE mp3 links
grab_dur.bat will get durations of all url stored in "input.txt" and save to "output.txt"
Note that this using Curl and ffprobe (which part of ffmpeg - can install by "winget install ffmpeg")
Install Curl: winget install curl

__Requirement__  
```command
winget install curl ffmpeg
```
### Input file
`input.txt`
```text
25.mp3 https://archive.org/download/DPTK2_NgheAudio/25.mp3
26.mp3 https://archive.org/download/DPTK2_NgheAudio/26.mp3
27.mp3 https://archive.org/download/DPTK2_NgheAudio/27.mp3
```

### Batch file to get duration
```batch
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
```
### Output file
The output file `output.txt` will looks as following. Adding `[]` we will have a json file
```json
{"tit": "100.mp3", "dur": "1:02:14"},
{"tit": "119.mp3", "dur": "58:05"},
{"tit": "120.mp3", "dur": "48:34"},
{"tit": "121.mp3", "dur": "48:59"},
```

## Using python to get duration for LOCAL mp3 files
Using python to get the duration of all mp3 files in the same folder

__Requirement__  
we need Mutagen - which is a Python library used for handling audio metadata, also known as tags. It supports a wide range of audio formats, including MP3, Ogg Vorbis, FLAC, and others.
```command
pip install mutagen
```

### Python code file
`get_dur.py`
```python
import os
from mutagen.mp3 import MP3
from datetime import timedelta

# Path to your folder containing MP3 files
folder_path = "."

# Path to output text file
output_file = "mp3_durations.txt"

def format_duration(seconds):
    """Convert seconds to H:mm:ss or mm:ss format (omit hours if < 1 hour)."""
    td = timedelta(seconds=int(seconds))
    total_seconds = int(td.total_seconds())
    hours, remainder = divmod(total_seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    if hours > 0:
        return f"{hours}:{minutes:02}:{seconds:02}"
    else:
        return f"{minutes}:{seconds:02}"

with open(output_file, "w", encoding="utf-8") as f:
    for file_name in os.listdir(folder_path):
        if file_name.lower().endswith(".mp3"):
            file_path = os.path.join(folder_path, file_name)
            audio = MP3(file_path)
            duration = audio.info.length
            formatted_duration = format_duration(duration)
            #line = f'{{"dur": "{formatted_duration}"}},\n'
            line = f'{{"tit": "{file_name}", "dur": "{formatted_duration}"}},\n'
            f.write(line)
            print(line.strip())

print(f"\nAll durations saved to: {output_file}")
```