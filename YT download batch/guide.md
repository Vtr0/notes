# Install dependencies
### ✅ Prerequisites

Ensure `yt-dlp` is installed and updated, and ffmpeg is available in your system's `PATH`.

### Install by winget
bash/cmd:	`winget install yt-dlp`  
Upgrade `yt-dlp`: `winget install upgrade yt-dlp` or `yt-dlp -U`

Install `ffmpeg` : `winget install ffmpeg`

See [yt-dlp dependencies](https://github.com/Vtr0/notes/blob/main/YT%20download%20batch/guide.md#quiet-mode) for more.
### Links
YT-DLP on github: https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file
	
YT-DLP_GUI
	https://github.com/kannagi0303/yt-dlp-gui

### Troubleshoot
If somehow `yt-dlp` fails to download mp3, you should upgrade it.

# Run batch file to Download
* The batch file should be used: **`ytd.bat`**
* All downloaded MP3 from YouTube Video will be embbed withFull `ID3 Tags`

## Argument
You can run `ytd.bat` with argument(s) as follows
```
ytd.bat -n
ytd.bat -v
ytd.bat -nv
```
* `-n`: The program will NOT ask for choosing too many settings when downloading, this is the same as set to `Y` when be asking in (`Quiet mode`)[#quiet-mode] below.
* `-v` meaning verbose, adding argument `--console-title --verbose` to the `yt-dl`, the terminal will
	* `--console-title`: Display progress in console titlebar
	* `--verbose`: Print various debugging information

## Choose general settings

### Bitrate menu
First, you should choose the bitrate from 64kbps, 128kbps, 192kbps (default), 256kbps, 320kbps

### Quiet mode
Choose if the quiet mode:
```
Enable quiet mode? (Y/N) [Y]: 
```
if you choose anything other than `n/N`, the programm will take that as a `Yes` - `Quiet mode ENABLED` meaning you will not have to choose too many setting for each download mode. The asking for `start-index`, `padding-size`, filename `ordinal` format will be suppressed and take the default setting.

Except for the `Playlist` download mode, to avoid to automatically download too many videos in a playlist, the program still ask for the `playlist-start` and `playlist-end`
### id3 tag
Choose to add id3 tag to output mp3 files or not
### Output filename format
Choose the basic filename format, as in follows menu
```makefile
---------------------------------------
Choose the desired filename format (default is option 1):
    1. <title>.<ext> [default]
    2. <artist> - <title>.<ext>
    3. <title> - [<id>].<ext>
    4. <title> - [<duration>].<ext>
    5. <artist> - <title> - [<duration>].<ext>
---------------------------------------
```

## Choose download mode.
Ater choosing some general setting, we will have a menu as follows
```makefile
---------------------------------------
YouTube to MP3 Downloader
---------------------------------------
Settings:
  Quiet mode DISABLED.
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

### 🔽 Single file mode
Even the name, you can pass multiple urls for downloading, for example, you can past in urls separeted by a space like this:
`https://www.youtube.com/watch?v=pytdWKT-NV4 https://www.youtube.com/watch?v=eBaGlo1b3ZY`

After type in url(s), you have to choose the filename mode  
```makefile
    [1] Use default filenames (Title.mp3) - [default]
    [2] Use indexed filenames (01 - Title.mp3)
```
[1] ➤ Without Index in Filename: without the ordinal (default)  
With this mode, we have downloaded files as follows:
```makefile
LXNGVX, Warriyo - Mortals Funk Remix ｜ NCS - Copyright Free Music.mp3
MXZI, sk3tch01, X972 - Montagem Toma ｜ Funk ｜ NCS - Copyright Free Music.mp3
```

[2] ➤ With Index in Filename: with the ordinal number at the start of file name.
With this mode, you have to type in the `start index` and `padding size`, for example with `start index = 5` and `padding size = 3`, we have output file name as follows:
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
#### Choose items to download
You will be asked to type in the list of items that you want to download:
```text
Choose the range of videos to download from the playlist:
---------------------------------------
Press Enter to download whole playlist.
-------------------
Or specify a range in one of the following formats:
   + Format: "item, item, item". Example: 2,4,6 to download item 2, 4, 6
   + Format: "[START]-[STOP]". Example: "3-5" to download items 3, 4, 5 
   + Format: "[START]:[STOP][:STEP]". Example: "1:6:2" (downloads items 1, 3, 5). "-5::2" to download items from 5th last item to the last item with step size of 2. "::2" to download every even item in the playlist. There can also be missing [START] or [STOP] such as ":5", ":5:3", "139:", "139::2".
   + "[START]-" or "[START]:" to download from [START] to the end. Example: "5-" or "5:" to download from item 5 to the end. 
-------------------
Or comprise of ranges with commas:
   Example: 1-3,5:7:2,9- to download items 1,2,3,5,7,and 9 to end
```
There are lots of ways to quickly specify which items you want to download, but the most simple way is to type in the item number, such as `1,2,4,9`, or just type `Enter` to download whole playlist, be you should be careful when some playlist have large amount of videos.

Some mote examples:
| Syntax                 |  Meaning  |
|------------------------|-------------------------|
| `1,2,5, -1, -5`         | item `1, 2, 5`, `last item` and the `5th last item` |
| `1-3` or `1:3`          | item `1, 2, 3`     |
| `140-` or `140:`        | item 140 to the end   |
| `:5`                    | item `1, 2, 3, 4, 5` (note that `-5` not work, since it is mistaken with `minus 5`)  |
| `:3:2`                  | item `1, 3` (from 1 to 3, step 2) |
| `-5::2`                 | from the 5th last item to the last item, step 2 (e.g., in a 15-item playlist: items `11, 13, 15`)  |
| `::2`                   | every 2nd item starting at 1 → items `1, 3, 5...` (i.e., all odd-indexed items) |
| `1-3, 4:5:2, 140-`        | combination of the above forms, separated by commas |
<!-- 
```
`1,2,5`	item 1,2,5
`1-3` or `1:3`	item 1,2,3 
`:3:2`		item 1, 3 (from 1 to 3, step 2)
`140-` or `140:`	item 140 to the end
`-5::2`		item form the 5th last item to the very last item, step 2. For example, if playlist has 15 items, this will download item 11, 13, 15
`::2`		download `even` items 2,4,6... to the last item
`1-3, 4:5:2, 140-`	Comprises of aabove, separeted with `,`
``` -->

#### Choose `Ordinal` for filename
Finally, choose the style for `ordinal` indexed number at the start of filename.
```makefile
[1] Use default filenames[default]
[2] Use indexed filenames (Index of the video in the playlist)
[3] Use indexed filenames (Position of the video in the playlist download queue)
Choose filename indexed style (1-3): 
```
Detailed meaning of each option as follows:
| Option | Description  (Example with `padding size = 3`) | `yt-dlp` argument
|--------|-------------|-------------|
| `[1]` Use default filenames [default] | no ordinal number | use nothing |
| `[2]` Use indexed filenames (Index of the video in the playlist) | use the index of video in Playlist to be the ordinal. For example, you download item `8, 11`, the `ordinal` prefix of the file name is `008 - `, `011 -` | using the parameter `playlist_index` (numeric): Index of the video in the playlist padded with leading zeros according the final index |
| `[3]` Use indexed filenames (Position of the video in the playlist **download queue**) | Use the position of downloaded mp3 file. So the video item number 4 in playlist can be set the ordinal of '01' if it is the first items being choosen to download. For example, you download item `8, 11, 35`, the `ordinal` prefix of the file name is `001 - `, `002 -`, `003 - ` | using the parameter `playlist_autonumber` (numeric): Position of the video in the playlist download queue padded with leading zeros according to the total length of the playlist |

**Choose padding size**: If you choose option [2] or [3], you have to do one more step to set the `padding size`  
# Code customization
### 🎯 Set Download Directory
#### Change Download directory
	set "DOWNLOAD_DIR=%userprofile%\Downloads\YouTube-MP3"
Or simply  

	set "DOWNLOAD_DIR=.\YouTube-MP3"
If the output directory not yet existed, the program will create it for you.

#### Separate folders for different `Uploader` and `Playlist`
Go to line that call `yt-dlp` which looks as follows:
```
yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% --yes-playlist ^
....
```
to replace 
```
%DOWNLOAD_DIR%\
```
with to put downloaded mp3 in corresponding foler of its `uploader`, for example `NoCopyrightSounds\`
```
%DOWNLOAD_DIR%\%%(uploader)s\
```
or with (only for `Playlist` download mode) to put downloaded mp3 into sub-folder `<uploader>\<playlist title>`, for example `NoCopyrightSounds\NCS The Best of 2025\`
```
%DOWNLOAD_DIR%\%%(uploader)s\%%(playlist)s\
```
## Command explain
### Basic download command
Most simple command:
```batch
yt-dlp -x --audio-format mp3 --audio-quality 5 ^
    --embed-metadata --embed-thumbnail --add-metadata ^
    -o "%DOWNLOAD_DIR%\%%(autonumber+0)02d - %%(title)s.%%(ext)s" %VIDEO_URL%
```

Following to Download One (or few youtube video whose url separate by a space) YouTube Video as MP3 with Full ID3 Tags
```batch
yt-dlp -x --audio-format mp3 --audio-quality 192 ^
	--embed-metadata --embed-thumbnail --add-metadata ^
	-o "%DOWNLOAD_DIR%\%%(autonumber+!SG_START_INDEX!)0!SG_PAD_SIZE!d - !FNAME_FORMAT!" %VIDEO_URL%
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
* `!FNAME_FORMAT!`: the format of output mp3 files that the program ask user to choose. The default value is `%%(title)s.%%(ext)s` meaning `<video title>.mp3`
* `!SG_START_INDEX!`: is batch variable to set the first `ordinal number` that the programm will ask user to type in. The default value is `1`
* `!SG_PAD_SIZE!`: the batch variable to define the `padding size` of `ordinal number` that the programm will ask user to type in. The default value is `2`
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
