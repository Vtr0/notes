@echo off
:: Turns on delayed variable expansion, which lets you safely use !VAR! to get the current value of a variable inside loops or code blocks.
setlocal enabledelayedexpansion

REM === YT-MP3 Downloader Script ===
REM Downloads MP3s from YouTube with full ID3 metadata

REM Set the download directory
set "DOWNLOAD_DIR=%userprofile%\Downloads\YouTube MP3"
rem set "DOWNLOAD_DIR=.\YouTube MP3"

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

REM ===== CHOOSE BITRATE =====
:: Display bitrate options
echo ---------------------------------------
echo Choose the desired audio bitrate (default is 192 kbps):
echo 1. 64 kbps
echo 2. 128 kbps
echo 3. 192 kbps (default)
echo 4. 256 kbps
echo 5. 320 kbps
echo ---------------------------------------

:: Ask user for choice
set /p choice=Enter your choice (1/2/3/4/5) or press Enter to use the default: 

:: Map the choice to the corresponding bitrate or use default (192)
set "BITRATE=192k"
if "%choice%"=="1" set "BITRATE=64k"
if "%choice%"=="2" set "BITRATE=128k"
if "%choice%"=="4" set "BITRATE=256k"
if "%choice%"=="5" set "BITRATE=320k"
:: Inform user of the selected bitrate
echo Downloading audio are all set at bitrate of %BITRATE% kbps...

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
if "%choice%"=="4" exit /b
goto :main_menu

REM ===== SINGLE VIDEO LOOP =====
:single_loop
:single_download
cls
echo === Single Video MP3 Download ===
set /p VIDEO_URL="Enter YouTube video URL (or type 'e' to go back): "

if /i "%VIDEO_URL%"=="e" goto :main_menu

echo [1] Use default filenames
echo [2] Use indexed filenames (01 - Title.mp3)
set /p sg_index_choice="Choose filename style (1-2): "

if "%sg_index_choice%"=="1" (
    yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
        --embed-metadata --embed-thumbnail --add-metadata ^
        -o "%DOWNLOAD_DIR%\%%(title)s.%%(ext)s" %VIDEO_URL%
) else (
    rem ----------------------------
    rem Ask for Padding size (number of digits for padding (3 -> 001, 002, ...))
    rem ----------------------------
    set "SG_PS_DV=2"
    set /p SG_PS_UV="Enter Padding size (number), default 2 (1 --> 01): "

    :: variable name shortcut: SG=Single, PS = Padding Size, UV=User Value, DV=Default Value
    :: Use default if user pressed Enter
    if "!SG_PS_UV!"=="" set "SG_PS_UV=!SG_PS_DV!"

    :: Try arithmetic to see if it's numeric
    set /a sg_ps_test=!SG_PS_UV! >nul 2>nul
    if errorlevel 1 (
        echo Invalid input. Using default value: !SG_PS_DV!
        set "SG_PAD_SIZE=!SG_PS_DV!"
    ) else (
        set "SG_PAD_SIZE=!SG_PS_UV!"
    )
    echo SG_PAD_SIZE chosen = !SG_PAD_SIZE!

    rem ----------------------------
    rem Ask for start index
    rem ----------------------------
    set "SG_SI_DV=1"
    set /p SG_SI_UV="Enter start index (number), default 1: "

    :: variable name shortcut: SG=Single, SI=Start Index, UV=User Value, DV=Default Value
    :: Use default if user pressed Enter
    if "!SG_SI_UV!"=="" set "SG_SI_UV=!SG_SI_DV!"

    :: Try arithmetic to see if it's numeric
    set /a sg_si_test=!SG_SI_UV! >nul 2>nul
    if errorlevel 1 (
        echo Invalid input. Using default value: !SG_SI_DV!
        set "SG_START_INDEX=!SG_SI_DV!"
    ) else (
        set "SG_START_INDEX=!SG_SI_UV!"
    )

    echo SG_START_INDEX chosen = !SG_START_INDEX!
    :: Adjust for autonumber starting at 1
    set /a SG_START_INDEX=SG_START_INDEX-1

    rem ----------------------------
    rem Start batch download with indexing
    rem ----------------------------
    yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
        --embed-metadata --embed-thumbnail --add-metadata ^
        -o "%DOWNLOAD_DIR%\%%(autonumber+!SG_START_INDEX!)0!SG_PAD_SIZE!d - %%(title)s.%%(ext)s" %VIDEO_URL%
)

echo.
echo ✅ Download complete.
echo.
pause
goto :single_download

REM ===== BATCH DOWNLOAD FROM URLS.TXT =====
:batch
cls

REM --- CONFIG ---
set "URL_LINKS_FILE=urls.txt"

:: --- check file ---
if not exist "%URL_LINKS_FILE%" (
    echo ❌ File "%URL_LINKS_FILE%" not found in current directory.
    pause
    goto :main_menu
)

:: --- Ask for filename style ---
echo === Batch MP3 Download from urls.txt ===
echo [1] Use default filenames
echo [2] Use indexed filenames (01 - Title.mp3)
set /p index_choice="Choose filename style (1-2): "

if "%index_choice%"=="1" (
    yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
        --embed-metadata --embed-thumbnail --add-metadata ^
        -o "%DOWNLOAD_DIR%\%%(title)s.%%(ext)s" -a "%URL_LINKS_FILE%"
) else (
    rem ----------------------------
    rem Ask for Padding size (number of digits for padding (3 -> 001, 002, ...))
    rem ----------------------------
    set "PS_DEFAULT_VALUE=2"
    set /p PS_USER_VALUE="Enter Padding size (number), default 2 (1 --> 01): "

    :: Use default if user pressed Enter
    if "!PS_USER_VALUE!"=="" set "PS_USER_VALUE=!PS_DEFAULT_VALUE!"

    :: Try arithmetic to see if it's numeric
    set /a ps_test=!PS_USER_VALUE! >nul 2>nul
    if errorlevel 1 (
        echo Invalid input. Using default value: !PS_DEFAULT_VALUE!
        set "PAD_SIZE=!PS_DEFAULT_VALUE!"
    ) else (
        set "PAD_SIZE=!PS_USER_VALUE!"
    )
    echo PAD_SIZE chosen = !PAD_SIZE!
    

    rem ----------------------------
    rem Ask for start index
    rem ----------------------------
    set "DEFAULT_VALUE=1"
    set /p USER_VALUE="Enter start index (number), default 1: "

    :: Use default if user pressed Enter
    if "!USER_VALUE!"=="" set "USER_VALUE=!DEFAULT_VALUE!"

    :: Try arithmetic to see if it's numeric
    set /a test=!USER_VALUE! >nul 2>nul
    if errorlevel 1 (
        echo Invalid input. Using default value: !DEFAULT_VALUE!
        set "START_INDEX=!DEFAULT_VALUE!"
    ) else (
        set "START_INDEX=!USER_VALUE!"
    )

    echo START_INDEX chosen = !START_INDEX!
    :: Adjust for autonumber starting at 1
    set /a START_INDEX=START_INDEX-1

    rem ----------------------------
    rem Start batch download with indexing
    rem ----------------------------
    yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
        --embed-metadata --embed-thumbnail --add-metadata ^
        -o "%DOWNLOAD_DIR%\%%(autonumber+!START_INDEX!)0!PAD_SIZE!d - %%(title)s.%%(ext)s" -a "%URL_LINKS_FILE%"
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

:: -----------------------
:: Ask for Start Index
:: -----------------------
set "PL_DEFAULT_START=1"
set /p PL_USER_START="Enter start index (default %PL_DEFAULT_START%):" 

:: Validate numeric
set /a pl_start_test=!PL_DEFAULT_START! >nul 2>nul
if errorlevel 1 (
    echo Invalid input. Using default start index: !PL_DEFAULT_START!
    set "PL_START_INDEX=!PL_DEFAULT_START!"
) else (
    set "PL_START_INDEX=!PL_USER_START!"
)
echo Start index chosen = !PL_START_INDEX!

:: -----------------------
:: Ask for End Index
:: -----------------------
set /p PL_USER_END="Enter end index (default: last item):" 

:: Validate numeric
set /a pl_end_test=!PL_USER_END! >nul 2>nul
if errorlevel 1 (
    echo No valid end index provided. Using last item in playlist.
    set "PL_END_INDEX="
) else (
    set "PL_END_INDEX=!PL_USER_END!"
)
echo End index chosen = !PL_END_INDEX!

:: -----------------------
:: Build yt-dlp options for start/end index
:: -----------------------
set "PL_RANGE_OPT="
if defined PL_START_INDEX (
    set "PL_RANGE_OPT=--playlist-start !PL_START_INDEX!"
)
if defined PL_END_INDEX (
    set "PL_RANGE_OPT=!PL_RANGE_OPT! --playlist-end !PL_END_INDEX!"
)
:: Padding size fixed at 2 for now (may add code for user input later)
set PL_PADDING_DIGITS=2

:: -----------------------
:: Download playlist
:: -----------------------
yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
    --embed-metadata --embed-thumbnail --add-metadata ^
    -o "%DOWNLOAD_DIR%\%%(playlist_index)0!PL_PADDING_DIGITS!d - %%(title)s.%%(ext)s" !PL_RANGE_OPT! %PLAYLIST_URL%

echo.
echo ✅ Playlist download complete.
pause
goto :main_menu
