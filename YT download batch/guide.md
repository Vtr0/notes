# INSTALL
	bash/cmd:	winget install yt-dlp
	upgrade yt-dlp: winget install upgrade yt-dlp

	Install ffmpeg (not necessary): winget install ffmpeg
	
YT-DLP on github: https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file
	
YT-DLP_GUI
	https://github.com/kannagi0303/yt-dlp-gui


# Download

### Output template
Go to [gitHub](https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#output-template) for exmaple of output filename which can be extrachted from mp3 file tags

### ✅ Prerequisites

Ensure yt-dlp is installed and updated, and ffmpeg is available in your system's PATH.
You can update yt-dlp via:	yt-dlp -U

### 🎯 Set Download Directory
set DOWNLOAD_DIR=%userprofile%\Downloads

### Download using batch
🔽 Download One YouTube Video as MP3 with Full ID3 Tags
```batch
	yt-dlp -x --audio-format mp3 --audio-quality 5 ^
	  --embed-metadata --embed-thumbnail --add-metadata ^
	  -o "%DOWNLOAD_DIR%\%(title)s.%(ext)s" <VIDEO_URL>
```

Explanation of Key Options:
* `--embed-metadata`: Adds metadata (ID3 tags) like title, artist, album, etc.
* `--embed-thumbnail`: Embeds the video's thumbnail as the album art.
* `--add-metadata`: Adds metadata to the output filename (helpful for certain formats).
* `-x`: Extract audio.
* `--audio-format mp3`: Convert to MP3.
* `--audio-quality 5`: Medium-high quality (0 = best, 9 = worst).
* `-o`: Output filename template.

### 🔁 Batch Download Using a urls.txt File
urls.txt Example:
```text
https://www.youtube.com/watch?v=VIDEO_ID1
https://www.youtube.com/watch?v=VIDEO_ID2
https://www.youtube.com/watch?v=VIDEO_ID3
```

➤ Without Index in Filename
```batch
yt-dlp -x --audio-format mp3 --audio-quality 5 ^
	--embed-metadata --embed-thumbnail --add-metadata ^
	-o "%DOWNLOAD_DIR%\%(title)s.%(ext)s" -a urls.txt
```

➤ With Index in Filename
```batch
yt-dlp -x --audio-format mp3 --audio-quality 5 ^
	--embed-metadata --embed-thumbnail --add-metadata ^
	-o "%DOWNLOAD_DIR%\%(autonumber)02d - %(title)s.%(ext)s" -a urls.txt
```
where
* `%autonumber%`: Automatically numbers files (01, 02, 03...).
* You can change `%(autonumber)02d` to `03d`, `04d` for more 0 start-padding 

### 📂 Download an Entire Playlist as MP3
Download entire playlist with index at beginning of filename
```batch
yt-dlp -x --audio-format mp3 --audio-quality 5 ^
	--embed-metadata --embed-thumbnail --add-metadata ^
	-o "%DOWNLOAD_DIR%\%(playlist_index)s - %(title)s.%(ext)s" "<PLAYLIST_URL>"
```

### 🧪 Optional (Advanced Metadata Customization)

You can further enhance metadata tagging with custom output templates:  
	`-o "%DOWNLOAD_DIR%\%(artist)s - %(title)s.%(ext)s"`


Or use:  
	`-o "%DOWNLOAD_DIR%\%(album)s/%(track_number)02d - %(title)s.%(ext)s"`

(if metadata is consistently available from the source).
	
--------------------------

### Mapping of bitrate
Here's the typical mapping for MP3 VBR quality settings (--audio-quality 0 to 9):

--audio-quality	Approximate Bitrate	Description
* 0	~245 kbps	Highest quality
* 1	~225 kbps	Very high quality
* 2	~190 kbps	High quality
* 3	~175 kbps	Good quality
* 4	~165 kbps	Near transparency
* 5	~130 kbps	Medium quality
* 6	~115 kbps	Lower quality
* 7	~100 kbps	Low quality
* 8	~85 kbps	Very low quality
* 9	~65 kbps	Lowest quality
