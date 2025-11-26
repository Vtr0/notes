@echo off
:: Turns on delayed variable expansion, which lets you safely use !VAR! to get the current value of a variable inside loops or code blocks.
setlocal enabledelayedexpansion

REM === YT-MP3 Downloader Script ===
REM Downloads MP3s from YouTube with full ID3 metadata

REM Set the download directory
rem set "DOWNLOAD_DIR=%userprofile%\Downloads\YouTube MP3"
set "DOWNLOAD_DIR=.\YouTube-MP3"

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

REM ===== CHOOSE IF EMBBED ID3 TAG TO OUTPUT MP3 =====
set /p EMBBED_ID3_ENABLED="Embed ID3 metadata? [Y/n]: "
:: Use first character only
set "EMBBED_ID3_ENABLED=!EMBBED_ID3_ENABLED:~0,1!"
:: default to Y if empty
set "EMBBED_ID3_CMD=--embed-metadata --embed-thumbnail --add-metadata "
if /I "!EMBBED_ID3_ENABLED!"=="N" (
    set "EMBBED_ID3_CMD="
)
::echo ID3 embedding is set to: !EMBBED_ID3_CMD!

REM ===== CHOOSE OUTPUT FILENAME FORMAT =====
:: Display bitrate options
echo ---------------------------------------
echo Choose the desired filename format (default is option 1):
echo 1. ^<title^>.^<ext^> (default)
echo 2. ^<artist^> - ^<title^>.^<ext^>
echo 3. ^<title^> - [^<id^>].^<ext^>
echo 4. ^<title^> - [^<duration^>].^<ext^>
echo 5. ^<artist^> - ^<title^> - [^<duration^>].^<ext^>
echo ---------------------------------------

:: Ask user for choice
set /p fname_format_choice="Enter your choice (1/2/3/4) or press Enter to use the default: "

:: Map the choice to the corresponding bitrate or use default (192)
set "FNAME_FORMAT=%%(title)s.%%(ext)s"
:: %%(artist)s - %%(title)s.%%(ext)s
if "%fname_format_choice%"=="2" set "FNAME_FORMAT=%%(uploader)s - %%(title)s.%%(ext)s"
if "%fname_format_choice%"=="3" set "FNAME_FORMAT=%%(title)s - [%%(id)s].%%(ext)s"
if "%fname_format_choice%"=="4" set "FNAME_FORMAT=%%(title)s - [%%(duration_string)s].%%(ext)s"
if "%fname_format_choice%"=="5" set "FNAME_FORMAT=%%(uploader)s - %%(title)s - [%%(duration_string)s].%%(ext)s"
:: Inform user of the selected format
echo Output mp3 filename has format of %FNAME_FORMAT% ...

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
set /p br_choice=Enter your choice (1/2/3/4/5) or press Enter to use the default: 

:: Map the choice to the corresponding bitrate or use default (192)
set "BITRATE=192k"
if "%br_choice%"=="1" set "BITRATE=64k"
if "%br_choice%"=="2" set "BITRATE=128k"
if "%br_choice%"=="4" set "BITRATE=256k"
if "%br_choice%"=="5" set "BITRATE=320k"
:: Inform user of the selected bitrate
echo Downloading audio are all set at bitrate of %BITRATE% kbps...

REM ===== MAIN MENU =====
:main_menu
cls
echo ---------------------------------------
echo YouTube to MP3 Downloader
echo ---------------------------------------
echo Settings:
echo   Download Directory: "%DOWNLOAD_DIR%"
if defined EMBBED_ID3_CMD (
    echo   Embbed ID3 Metadata: "Yes"
) else (
    echo   Embbed ID3 Metadata: "No"
)
echo   Filename Format: "%FNAME_FORMAT%"
echo   Audio Bitrate: "%BITRATE%bps"
echo ---------------------------------------
echo Select download mode:
echo   [1] Download single videos (loop)
echo   [2] Download from urls.txt
echo   [3] Download playlist
echo   [4] Exit
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

echo [1] Use default filenames (Title.mp3) - default
echo [2] Use indexed filenames (01 - Title.mp3)
set /p sg_index_choice="Choose filename style (1-2): "

:: default there is no ordinal
set "SG_ORDINAL="
if "%sg_index_choice%"=="2" (
    rem ----------------------------
    rem Ask for start index
    rem ----------------------------
    CALL :GetUserInputNumber "Enter start index (number), default 1: " 1
    SET SG_START_INDEX=!ERRORLEVEL!
    echo SG_START_INDEX chosen = !SG_START_INDEX!
    :: Adjust for autonumber starting at 1
    set /a SG_START_INDEX=SG_START_INDEX-1

    
    rem ----------------------------
    rem Ask for Padding size (number of digits for padding (3 --we have 001, 002, ...))
    rem ----------------------------
    CALL :GetUserInputNumber "Enter Padding size (number), default 2 (1 becomes 01): " 2
    SET SG_PAD_SIZE=!ERRORLEVEL!
    echo SG_PAD_SIZE chosen = !SG_PAD_SIZE!

    set "SG_ORDINAL=%%(autonumber+!SG_START_INDEX!)0!SG_PAD_SIZE!d - "
)

rem ----------------------------
rem Start batch download with indexing
rem ----------------------------
yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
    !EMBBED_ID3_CMD! ^
    -o "%DOWNLOAD_DIR%\!SG_ORDINAL!!FNAME_FORMAT!" %VIDEO_URL%


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
echo [1] Use default filenames - default
echo [2] Use indexed filenames (01 - Title.mp3)
set /p index_choice="Choose filename style (1-2): "

:: default there is no ordinal. "BA" means "Batch"
set "BA_ORDINAL="
if "%index_choice%"=="2" (
    rem ----------------------------
    rem Ask for start index
    rem ----------------------------
    CALL :GetUserInputNumber "Enter start index (number), default 1: " 1
    SET BA_START_INDEX=!ERRORLEVEL!
    echo BA_START_INDEX chosen = !BA_START_INDEX!
    :: Adjust for autonumber starting at 1
    set /a BA_START_INDEX=BA_START_INDEX-1
    
    rem ----------------------------
    rem Ask for Padding size (number of digits for padding (3 --we have 001, 002, ...))
    rem ----------------------------
    CALL :GetUserInputNumber "Enter Padding size (number), default 2 (1 becomes 01): " 2
    SET BA_PAD_SIZE=!ERRORLEVEL!
    echo BA_PAD_SIZE chosen = !BA_PAD_SIZE!

    set "BA_ORDINAL=%%(autonumber+!BA_START_INDEX!)0!BA_PAD_SIZE!d - "
)

rem ----------------------------
rem Start batch download with indexing
rem ----------------------------
yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
    !EMBBED_ID3_CMD! ^
    -o "%DOWNLOAD_DIR%\!BA_ORDINAL!!FNAME_FORMAT!" -a "%URL_LINKS_FILE%"

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
CALL :GetUserInputNumber "Enter start index (number), default 1: " 1
SET PL_START_INDEX=!ERRORLEVEL!
echo Start index chosen = !PL_START_INDEX!

:: -----------------------
:: Ask for End Index
:: -----------------------
CALL :GetUserInputNumber "Enter end index (Enter or 0 for default: last item):" 0
SET PL_END_INDEX=!ERRORLEVEL!
echo End index chosen = !PL_END_INDEX!

:: -----------------------
:: Build yt-dlp options for start/end index
:: -----------------------
set "PL_RANGE_OPT="
:: if start index == 1, no need to set --playlist-start
if !PL_START_INDEX! GTR 1 (
    set "PL_RANGE_OPT=--playlist-start !PL_START_INDEX!"
)
:: if end index == 0, meaning to the end of playlist, so no need to set --playlist-end
if !PL_END_INDEX! GTR 0 (
    set "PL_RANGE_OPT=!PL_RANGE_OPT! --playlist-end !PL_END_INDEX!"
)
::echo Playlist range options: !PL_RANGE_OPT!

rem ----------------------------
rem Ask for Padding size (number of digits for padding (3 --we have 001, 002, ...))
rem ----------------------------
CALL :GetUserInputNumber "Enter Padding size (number), default 2 (1 becomes 01): " 2
SET PL_PADDING_DIGITS=!ERRORLEVEL!
echo Padding size chosen = !PL_PADDING_DIGITS!

rem ----------------------------
rem Ask for using ordinal indexed filename
rem ----------------------------
echo .
echo [1] Use default filenames
echo [2] Use indexed filenames (Index of the video in the playlist)
echo [3] Use indexed filenames (Position of the video in the playlist download queue)
set /p pl_index_choice="Choose filename indexed style (1-3): "

set "PL_ORDINAL="
if "%pl_index_choice%"=="2" (
    set "PL_ORDINAL=%%(playlist_index)0!PL_PADDING_DIGITS!d - "
) 
if "%pl_index_choice%"=="3" (
    set "PL_ORDINAL=%%(playlist_autonumber)0!PL_PADDING_DIGITS!d - "
) 
:: -----------------------
:: Download playlist
:: -----------------------
yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
    !EMBBED_ID3_CMD! ^
    -o "%DOWNLOAD_DIR%\!PL_ORDINAL!%%(title)s.%%(ext)s" !PL_RANGE_OPT! %PLAYLIST_URL%

:: %%(playlist_index)0!PL_PADDING_DIGITS!d
echo.
echo ✅ Playlist download complete.
pause
goto :main_menu


REM -----------------------------------------------------
REM Subroutine: GetUserInputNumber
REM Prompts the user for a number with a default value.
REM Parameters:
REM   %1 - Prompt message
REM   %2 - Default value
REM -----------------------------------------------------
:GetUserInputNumber
SETLOCAL
SET PROMPT=%1
SET DEFAULT=%2

REM Prompt the user for input
SET /P "USER_INPUT=%PROMPT% [default: %DEFAULT%]: "

REM If the user pressed Enter without typing anything, use the default value
IF "%USER_INPUT%"=="" (
    :: SET USER_INPUT=%DEFAULT%
    exit /b %DEFAULT%
)

REM Check if the input is a valid number
:: echo %USER_INPUT% | findstr /R "^[0-9][0-9]*$" >nul
:: Try arithmetic to see if it's numeric, adding prefix 0 for the check to work when user inputs only alphabets such as 'abc'
set /a suin_test=0%USER_INPUT% >nul 2>nul
:: echo USER_INPUT_TEST=%suin_test%
:: echo ERRORLEVEL=%errorlevel%
IF errorlevel 1 (
    REM Invalid input, return an error code (-1) using exit /b
    :: echo DEFAULT=%DEFAULT%
    exit /b %DEFAULT%
)

REM If the input is valid, return the number using exit /b
:: echo USER_INPUT=%USER_INPUT%
exit /b %USER_INPUT%