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

## Download batch urls
Single window prompt to download a file. Note that curl can download a file even if the link preven cross-origin, even if the link does not work when paste directly into browser
* Most simple form
```batch
curl -L -H "User-Agent: Mozilla/5.0" -O "https://archive.org/download/dai-chua-te_202202/[1-70].mp3"
```
* Specify output directory, specify output filename from the value in the range
```batch
curl -L -H "User-Agent: Mozilla/5.0" --create-dirs --output-dir "temp-dir" -o "#1.mp3" "https://archive.org/download/dai-chua-te_202202/[1-70].mp3"
```
* Range with leading `0` (aware the range `[001-100]`, the same as we use `padding size = 3` for auto-increasing number.)
```batch
curl -L -H "User-Agent: Mozilla/5.0" -O "https://archive.org/download/dai-chua-te_202202/dct-[001-100].mp3"
```
* Specify output directory, specify output filename from the value in the range and overcome cross-origin (for example here, the link from `audiosite.net` - which has very strick `block-cross-origin` policy)  
Here, we have to simulate a full browser request from same origin. Of course, for `audiosite.net`, the sample url below is just a part of a full-chapter mp3
```batch
curl -L --create-dirs --output-dir "temp-dir" -o "3.mp3" \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0 Safari/537.36" \
  -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
  -H "Accept-Language: en-US,en;q=0.5" \
  -H "Referer: https://truyen.audiosite.net/" \
  -H "Origin: https://audiosite.net/" \
  "https://truyen.audiosite.net/?mode=VN&token=aHR0cHM6Ly9hcmNoaXZlLm9yZy9kb3dubG9hZC9naWEtdGhpZW4vNC5tcDN8MTc2NzI1MzI2NHxiNzYwZjcyMzY5MGFkZDQ0ODNkNzMyMWNiMTMyNTFhYzBhNjNkMTM1NGVkM2FjNjZmMTVlZTNlYzQxNmE3ODZk"   
```
**Where**:
* `-L`: follow redirects
* `-H` stands for Header: It lets us manually add any HTTP header to the request.
* `--output-dir "temp-dir"`: put downloaded files in the folder
* `--create-dirs`: force to create folder it it not yet existed
* `-o "#1.mp3"`: the output filenames (`#1`) will take from the wildcarted range, in this case is `[1-70]`. 
* `-O`: save file using the remote filename
* `[1-70]`: The range to create batch download. The range can be other form such as `[1:10:2]`, `[a-z:2]`, `{one,two,three}`
* If you have multiple `range` in the url, the output file can do multiple replacement `#1`, `#2`,... on output filenames as example below (in which, `#1` will get value from `{site,host}`, `#2` get value from the range `[1-5]`):
```
curl "http://{site,host}.host[1-5].example" -o "#1_#2.htm"
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
`.\Code\download_mp3.bat`
```batch
REM download_mp3.bat
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
```
### Code modification
For some other host that prevent cross-origin, even when you paste the direct link to browser's addressbar, you should change the `referer` to corresponding host, that is, change following part of the code:
```
-H "Referer: https://radiotruyen.me"
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
`.\Code\Duration\grab_dur.bat`
```batch
@echo off
setlocal enabledelayedexpansion

echo ================================
echo Grab the duration of mp3 from list of links
echo Overcome cross-origin restrictions
echo ================================

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
### Code modification
For some other host that prevent cross-origin, even when you paste the direct link to browser's addressbar, you should change the `referer` to corresponding host, that is, change following part of the code:
```
-H "Referer: https://radiotruyen.me"
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
Using python to get the duration of all mp3 files in the same folder.

__Requirement__  
we need Mutagen - which is a Python library used for handling audio metadata, also known as tags. It supports a wide range of audio formats, including MP3, Ogg Vorbis, FLAC, and others.
```command
pip install mutagen
```

### Python code file
`.\Code\Duration\get_dur.py`
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
-------------------------------
# FREE DOWNLOAD MANAGER links generator
```javascript
/*
link: the links with asterik * at the number, such as https://archive.org/download/gia-thien/*.mp3
f: from number; t: to number
pad: number of "0" to pad at start of the number
*/
fdmLink = (link,f,t, pad = 0) => {
	let links=[];
	for(let i=f; i<=t; i++) links.push(link.replace("*", (i+"").padStart(pad,"0") ));
	let ret = links.join("\n");
	copy(ret);
	return ret;
}
```

## Example Usage:
Paste above code into `Console` in Chrome/Firefox `Developer Tool`, then run  the following command:
```javascript
fdmLink("http://example.com/page-*", 1, 141, 5)
```
## Example Output:
For the above command, the output will be. This output was already copied into clipboard:
```
http://example.com/page-00001
http://example.com/page-00002
http://example.com/page-00003
...
http://example.com/page-00141