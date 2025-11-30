# BATCH DOWNLOAD FILES USING CURL

## Install cURL
Curl is a command-line tool for transferring data from or to a server using URLs. You can go [github](https://github.com/curl/curl) or [https://curl.se/](https://curl.se/). To install cURL on window
```batch
winget install curl
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
`download_mp3.bat`
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
grab_dur.bat will get durations of all url stored in `"input.txt"` and save to `"output.txt"`
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
`grab_dur.bat`
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

# create `input.txt`
```batch
@echo off
setlocal enabledelayedexpansion

:: Check if required arguments are passed
if "%~4"=="" (
    echo Usage: %0 base_url start_number end_number padding_size
    exit /b
)

:: Get the arguments
set baseURL=%1
set start=%2
set end=%3
set paddingSize=%4

:: Check if the base URL contains a wildcard (*)
echo %baseURL% | findstr /C:"*" >nul
if errorlevel 1 (
    echo Error: Base URL must contain a wildcard (*) in the place of the number.
    exit /b
)

:: Loop from start to end
for /L %%i in (%start%, 1, %end%) do (
    :: Get the current number and the padding size
    set /a number=%%i
    set "formattedNumber=%%i"

    :: Check if the number length is less than the padding size, if so, pad with leading zeros
    set "numberLength=0"
    for /l %%j in (1,1,10) do (
        set /a "div=%%i / 10"
        if "!div!"=="0" (
            goto endLoop
        )
        set /a "numberLength+=1"
        set /a "i=div"
    )
    
    :endLoop
    set /a "numberLength+=1"

    if !numberLength! lss %paddingSize% (
        set "formattedNumber=000000000%%i"
        set "formattedNumber=!formattedNumber:~-!paddingSize!"
    )

    :: Replace the wildcard in the base URL with the formatted number
    set URL=!baseURL:*=!formattedNumber!
    echo !URL!
)

endlocal
pause
```
## Key Steps:
Argument Parsing:  
`%1, %2, %3, and %4` are used for the `base_url, start_number, end_number, and padding_size` respectively.
## Padding Logic:
- We calculate the number of digits in the current  number (numberLength).
If the number of digits is less than the specified padding size, we pad the number with leading zeros.
- The line set `"formattedNumber=000000000%%i"` ensures enough leading zeros are added before extracting the required number of digits with `!formattedNumber:~-!paddingSize!`.
- Wildcard Replacement:
We replace the * in the base URL with the formatted number.
## Example Usage:
Save the batch file as `generate_urls_with_padding.bat`.
Run it with the following command:
```
generate_urls_with_padding.bat "http://example.com/page-*" 1 141 5
```
## Example Output:
For the command `generate_urls_with_padding.bat "http://example.com/page-*" 1 141 5`, the output will be:
```
http://example.com/page-00001
http://example.com/page-00002
http://example.com/page-00003
...
http://example.com/page-00141
```
**Explanation of Output:**
* With padding size 5, numbers like 1 are padded to 00001, 2 becomes 00002, and so on.
* For larger numbers (e.g., 141), the number isn't truncated and will be displayed as 00141 because it fits within the 5-character width.
## Key Features:
* Padding size is flexible. If the number is smaller than the padding size, leading zeros will be added.
* Larger numbers (that exceed the padding size) are left intact without truncation.

# gen links for above format
```python
def generate_links(base_url, start_index, end_index, padding_size):
    links = []
    
    # Iterate through the range from start_index to end_index
    for i in range(start_index, end_index + 1):
        # Format the index with padding
        formatted_index = str(i).zfill(padding_size)
        
        # Replace '*' with the formatted index in the base URL
        link = base_url.replace('*', formatted_index)
        
        # Add the generated link to the list
        links.append(link)
    
    return links

# Ask the user to input the required arguments
base_url = input("Enter the base URL (use '*' as the placeholder for the index): ")
start_index = int(input("Enter the starting index: "))
end_index = int(input("Enter the ending index: "))
padding_size = int(input("Enter the padding size (e.g., 3 for 001, 002, etc.): "))

# Generate the links
links = generate_links(base_url, start_index, end_index, padding_size)

# Print the generated links
print("\nGenerated Links:")
for link in links:
    print(link)
```
### Explanation:
1) input(): The program uses input() to ask the user for:
	* `Base URL`: The URL template with `*` as the placeholder for the index (e.g., `https://example.com/page-*.html`).
	* `Start Index`: The starting index of the range.
	* `End Index`: The ending index of the range.
	* `Padding Size`: The padding size for the index (e.g., 3 for 001, 002, etc.).
2) The rest of the code remains the same and generates the list of links based on user input.
### Example Input and Output:
#### Example Input:
```batch
Enter the base URL (use '*' as the placeholder for the index): https://example.com/page-*.html
Enter the starting index: 1
Enter the ending index: 5
Enter the padding size (e.g., 3 for 001, 002, etc.): 3
```
#### Example Output:
```
Generated Links:
https://example.com/page-001.html
https://example.com/page-002.html
https://example.com/page-003.html
https://example.com/page-004.html
https://example.com/page-005.html
```
