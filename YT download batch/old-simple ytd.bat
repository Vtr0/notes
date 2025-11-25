@echo off
REM === YT-MP3 Downloader Script ===
REM Downloads MP3s from YouTube with full ID3 metadata

REM Set the download directory
set "DOWNLOAD_DIR=%userprofile%\Downloads\YouTube MP3"

REM Create download folder if it doesn't exist
if not exist "%DOWNLOAD_DIR%" (
    mkdir "%DOWNLOAD_DIR%"
)

REM Check for yt-dlp
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo yt-dlp is not installed or not in PATH. Please install it from https://github.com/yt-dlp/yt-dlp/releases
    pause
    exit /b
)

REM ===== MAIN MENU =====
:main_menu
cls
echo ---------------------------------------
echo YouTube to MP3 Downloader
echo ---------------------------------------
echo [1] Download single videos (loop)
echo [2] Download from urls.txt
echo [3] Download playlist
echo [4] Exit
echo ---------------------------------------
set /p choice="Choose an option (1-4): "

if "%choice%"=="1" goto :single_loop
if "%choice%"=="2" goto :batch
if "%choice%"=="3" goto :playlist
if "%choice%"=="4" exit
goto :main_menu

REM ===== SINGLE VIDEO LOOP =====
:single_loop
:single_download
cls
echo === Single Video MP3 Download ===
set /p VIDEO_URL="Enter YouTube video URL (or type 'exit' to go back): "

if /i "%VIDEO_URL%"=="exit" goto :main_menu

yt-dlp -x --audio-format mp3 --audio-quality 5 ^
    --embed-metadata --embed-thumbnail --add-metadata ^
    -o "%DOWNLOAD_DIR%\%%(title)s.%%(ext)s" %VIDEO_URL%

echo.
echo ✅ Download complete.
echo.
goto :single_download

REM ===== BATCH DOWNLOAD FROM URLS.TXT =====
:batch
cls
if not exist urls.txt (
    echo ❌ File urls.txt not found in current directory.
    pause
    goto :main_menu
)
echo === Batch MP3 Download from urls.txt ===
echo [1] Use default filenames
echo [2] Use indexed filenames (01 - Title.mp3)
set /p index_choice="Choose filename style (1-2): "

if "%index_choice%"=="1" (
    yt-dlp -x --audio-format mp3 --audio-quality 5 ^
        --embed-metadata --embed-thumbnail --add-metadata ^
        -o "%DOWNLOAD_DIR%\%%(title)s.%%(ext)s" -a urls.txt
) else (
    yt-dlp -x --audio-format mp3 --audio-quality 5 ^
        --embed-metadata --embed-thumbnail --add-metadata ^
        -o "%DOWNLOAD_DIR%\%%(autonumber)02d - %%(title)s.%%(ext)s" -a urls.txt
)
echo.
echo ✅ Batch download complete.
pause
goto :main_menu

REM ===== PLAYLIST DOWNLOAD =====
:playlist
cls
echo === Playlist MP3 Download ===
set /p PLAYLIST_URL="Enter YouTube playlist URL: "

yt-dlp -x --audio-format mp3 --audio-quality 5 ^
    --embed-metadata --embed-thumbnail --add-metadata ^
    -o "%DOWNLOAD_DIR%\%%(playlist_index)s - %%(title)s.%%(ext)s" %PLAYLIST_URL%

echo.
echo ✅ Playlist download complete.
pause
goto :main_menu
