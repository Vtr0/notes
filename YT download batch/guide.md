# Install dependencies
### ✅ Prerequisites

Ensure `yt-dlp` is installed and updated, and ffmpeg is available in your system's `PATH`.

### Install by winget
bash/cmd:	`winget install yt-dlp`  
Upgrade `yt-dlp`: `winget install upgrade yt-dlp` or `yt-dlp -U`

Install `ffmpeg` (not necessary): `winget install ffmpeg`

### Links
YT-DLP on github: https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file
	
YT-DLP_GUI
	https://github.com/kannagi0303/yt-dlp-gui

### Troubleshoot
If somehow `yt-dlp` fails to download mp3, you should upgrade it.

# Run batch file to Download
* The batch file should be used: **`ytd.bat`**
* All downloaded MP3 from YouTube Video will be embbed withFull `ID3 Tags`

## Guide

### Choose general settings
### id3 tag
Choose to add id3 tag to output mp3 files or not
### Output filename format
Choose the basic filename format, as in follows menu
```makefile
---------------------------------------
Choose the desired filename format (default is option 1):
1. <title>.<ext> (default)
2. <artist> - <title>.<ext>
3. <title> - [<id>].<ext>
4. <title> - [<duration>].<ext>
5. <artist> - <title> - [<duration>].<ext>
---------------------------------------
```

#### Bitrate menu
First, you should choose the bitrate from 64kbps, 128kbps, 192kbps (default), 256kbps, 320kbps

Ater choosing some general setting, we will have a menu as follows
```makefile
---------------------------------------
YouTube to MP3 Downloader
---------------------------------------
Settings:
  Download Directory: "C:\youtbe-MP3"
  Embed ID3 Metadata: "Yes"
  Filename Format: "%%(title)s - [%%(id)s].%%(ext)s"
  Audio Bitrate: "192kbps"
---------------------------------------
Select download mode:
  [1] Download single videos (loop)
  [2] Download from urls.txt
  [3] Download playlist
  [4] Exit
---------------------------------------
Choose an option (1-4): 
```

### Choose mode to download
### 🔽 Single file mode
Even the name, you can pase multiple urls for downloading. After type in url(s), you have to choose the filename mode  
[1] ➤ Without Index in Filename: without the ordinal  
[2] ➤ With Index in Filename: with the ordinal number at the start of file name.

With mode [1], we have downloaded files as follows:
```makefile
LXNGVX, Warriyo - Mortals Funk Remix ｜ NCS - Copyright Free Music.mp3
MXZI, sk3tch01, X972 - Montagem Toma ｜ Funk ｜ NCS - Copyright Free Music.mp3
```

With mode [2], you have to type in the `start index` and `padding size`, for example with `START_INDEX = 5` and `PADDING_SIZE=3`, we have output file name as follows:
```makefile
005 - LXNGVX, Warriyo - Mortals Funk Remix ｜ NCS - Copyright Free Music.mp3
006 - MXZI, sk3tch01, X972 - Montagem Toma ｜ Funk ｜ NCS - Copyright Free Music.mp3
```

### 🔁 Batch Download Using a `urls.txt` File
Example of a `urls.txt`	 file:
```makefile
https://www.youtube.com/watch?v=VIDEO_ID1
https://www.youtube.com/watch?v=VIDEO_ID2
https://www.youtube.com/watch?v=VIDEO_ID3
```
```makefile
https://www.youtube.com/watch?v=pytdWKT-NV4
https://www.youtube.com/watch?v=eBaGlo1b3ZY
```
Other user choice the same as for single download

### 📂 Download an Entire Playlist as MP3
Download entire playlist with index at beginning of filename.
You will be asked to type in `start index` (default `1`) and `end index` (default the very last video of the playlist)

Then you have to set the `padding size`  

Finally, choose the style for `ordinal` indexed number at the start of filename.
```makefile
[1] Use default filenames <-- no ordinal number
[2] Use indexed filenames (Index of the video in the playlist) <-- use the index of video in Playlist to be the ordinal
[3] Use indexed filenames (Position of the video in the playlist download queue) <-- Use the position of downloaded mp3 file. So the video item number 4 in playlist can be set the ordinal of '01' if it is the first items being choosen to download
Choose filename indexed style (1-3): 
```

Each option using following parameter of `yt-dlp`:
* [1]: use nothing
* [2]: using the parameter `playlist_index` (numeric): Index of the video in the playlist padded with leading zeros according the final index
* [3]: using the parameter `playlist_autonumber` (numeric): Position of the video in the playlist download queue padded with leading zeros according to the total length of the playlist

## Code customization
### 🎯 Set Download Directory
	set "DOWNLOAD_DIR=%userprofile%\Downloads"
Or simply  

	set "DOWNLOAD_DIR=.\YouTube-MP3"

### Command explain
Following to Download One (or few youtube video whose url separate by a space) YouTube Video as MP3 with Full ID3 Tags
```batch
yt-dlp -x --audio-format mp3 --audio-quality 192 ^
	--embed-metadata --embed-thumbnail --add-metadata ^
	-o "%DOWNLOAD_DIR%\%%(autonumber+!SG_START_INDEX!)0!SG_PAD_SIZE!d - %%(title)s.%%(ext)s" %VIDEO_URL%
```

Explanation of Key Options:
* `-x`: Extract audio.
* `--audio-format mp3`: Convert to MP3.
* `--audio-quality 192`: Audio bitrate is 192kbps. Can also use `--audio-quality 5`, where 5 is audio Medium-high quality (0 = best, 9 = worst). Full list see below
* `--embed-metadata`: Adds metadata (ID3 tags) like title, artist, album, etc.
* `--embed-thumbnail`: Embeds the video's thumbnail as the album art.
* `--add-metadata`: Adds metadata to the output filename (helpful for certain formats). Often used together with `--embed-metadata`.
* `-o`: Output filename template.
	* `%DOWNLOAD_DIR%` → batch variable, path where files are saved.
	* `%autonumber%`: Automatically numbers files (01, 02, 03...).	
		* You can change `%(autonumber)02d` to `03d`, `04d` for more 0 start-padding 
		* You can add number to make ordinal start from some other number (not 1), like `%(autonumber+5)02d` (note that there should be no space around the `+`)
		* Or we can do both to be `%(autonumber+!SG_START_INDEX!)0!SG_PAD_SIZE!d`
	* `%%(title)s` → the placeholder to be filled with `video title` from id3 tag.
	* `%%(ext)s` → file extension (mp3 after extraction). Similarly as `%%(title)s`
	* May add  `-o "thumbnail:%%(title)s\%%(title)s.%%(ext)s"` will put the thumbnails in a folder with the same name as the video
* `%VIDEO_URL%` This is the playlist or video URL (batch variable) that yt-dlp will download. Can be a single video, list of videos separated by a space, the text file that contains all video links (each in one line), or playlist.

Example output:
```makefile
C:\Music\01 - My Favorite Song.mp3
```

### 📂 Download an Entire Playlist as MP3
Download entire playlist with index at beginning of filename
```batch
yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
    --embed-metadata --embed-thumbnail --add-metadata ^
    -o "%DOWNLOAD_DIR%\%%(playlist_index)02d - %%(title)s.%%(ext)s" %PLAYLIST_URL%
```
OR
```batch
yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
    --embed-metadata --embed-thumbnail --add-metadata ^
    -o "%DOWNLOAD_DIR%\%%(playlist_autonumber)02d - %%(title)s.%%(ext)s" %PLAYLIST_URL%
```
where 
* `playlist_index` (numeric): Index of the video in the playlist padded with leading zeros according the final index
* `playlist_autonumber` (numeric): Position of the video in the playlist download queue padded with leading zeros according to the total length of the playlist
* Just as for single and download from list, you can customize the ordinal number as `%(playlist_index+10)03d`, `%(n_entries+1-playlist_index)d`
* `n_entries` (numeric): Total number of extracted items in the playlist

### 🧪 Optional (Advanced Metadata Customization)

You can further enhance metadata tagging with custom output templates, such as:  
	`-o "%DOWNLOAD_DIR%\%(artist)s - %(title)s.%(ext)s"`

Or use:  
	`-o "%DOWNLOAD_DIR%\%(album)s/%(track_number)02d - %(title)s.%(ext)s"`

(if metadata is consistently available from the source).

Go to [Output template](https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#output-template) on gitHub for more choices of available `mp3 tag fields` that can be included into output filename

--------------------------

### Mapping of bitrate
Here's the typical mapping for MP3 VBR quality settings (`--audio-quality` 0 to 9):

`--audio-quality`: Approximate Bitrate	Description
| Value | Bitrate    | Quality            |
|-------|------------|--------------------|
| 0     | ~245 kbps  | Highest quality    |
| 1     | ~225 kbps  | Very high quality  |
| 2     | ~190 kbps  | High quality       |
| 3     | ~175 kbps  | Good quality       |
| 4     | ~165 kbps  | Near transparency  |
| 5     | ~130 kbps  | Medium quality     |
| 6     | ~115 kbps  | Lower quality      |
| 7     | ~100 kbps  | Low quality        |
| 8     | ~85 kbps   | Very low quality   |
| 9     | ~65 kbps   | Lowest quality     |
<!-- 
* 0	~245 kbps	Highest quality
* 1	~225 kbps	Very high quality
* 2	~190 kbps	High quality
* 3	~175 kbps	Good quality
* 4	~165 kbps	Near transparency
* 5	~130 kbps	Medium quality
* 6	~115 kbps	Lower quality
* 7	~100 kbps	Low quality
* 8	~85 kbps	Very low quality
* 9	~65 kbps	Lowest quality -->
