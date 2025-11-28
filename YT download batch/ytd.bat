@echo off
:: Turns on delayed variable expansion, which lets you safely use !VAR! to get the current value of a variable inside loops or code blocks.
setlocal enabledelayedexpansion

REM ========================================
REM Process command-line arguments, such as "ytd.bat -s -v"
REM ========================================
SET "AR_NO_ASKING=0"
SET "AR_VERBOSE="

REM ========================================
REM Parse command-line arguments with FOR
REM ========================================
FOR %%A IN (%*) DO (

    REM --- Detect -s anywhere in token (NO_ASKING) ---
    echo %%A | findstr /I "n" >nul && (
        echo %%A | findstr /R "^-.*n" >nul && SET "AR_NO_ASKING=1"
    )

    REM --- Detect -v anywhere in token (VERBOSE) ---
    echo %%A | findstr /I "v" >nul && (
        echo %%A | findstr /R "^-.*v" >nul && SET "AR_VERBOSE=--console-title --verbose "
    )
)

REM ========================================
REM Output the results
REM ========================================
echo AR_NO_ASKING = %AR_NO_ASKING%
echo AR_VERBOSE = %AR_VERBOSE%

REM === YT-MP3 Downloader Script ===
REM Downloads MP3s from YouTube with full ID3 metadata

REM Set the download directory
set "DOWNLOAD_DIR=%userprofile%\Downloads\YouTube-MP3"
rem set "DOWNLOAD_DIR=.\YouTube-MP3"

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
set /p br_choice=Enter your choice (1/2/3/4/5) or press Enter to use the default: 

:: Map the choice to the corresponding bitrate or use default (192)
set "BITRATE=192k"
if "%br_choice%"=="1" set "BITRATE=64k"
if "%br_choice%"=="2" set "BITRATE=128k"
if "%br_choice%"=="4" set "BITRATE=256k"
if "%br_choice%"=="5" set "BITRATE=320k"
:: Inform user of the selected bitrate
echo Downloading audio are all set at bitrate of %BITRATE% kbps...
echo.

if "%AR_NO_ASKING%"=="1" (
    set "GL_QUIET=Y"
    goto :skip_ask_quiet_mode
)
:: -----------------------------
:: Ask for quiet mode (default = Y)
:: -----------------------------
set "GL_QUIET=Y"
set /p GL_QUIET="Enable quiet mode? (Y/N) [Y]: "

:: Normalize input
set "GL_QUIET=%GL_QUIET:~0,1%"
set "GL_QUIET=%GL_QUIET:y=Y%"
set "GL_QUIET=%GL_QUIET:n=N%"

if not "%GL_QUIET%"=="N" (
    set "GL_QUIET=Y"
    echo Quiet mode enabled. Defaults will be used automatically.
)

echo.
:skip_ask_quiet_mode

:: set default filename format and embed ID3 if quiet mode is enabled
if /i "%GL_QUIET%"=="Y" (
    set "EMBBED_ID3_CMD=--embed-metadata --embed-thumbnail --add-metadata "
    set "FNAME_FORMAT=%%(title)s.%%(ext)s"
    goto :main_menu
)  

:: THE FOLLOWING INDENT CODES ARE FOR OPTIONS BEING SKIPPED IF QUIET MODE IS ENABLED    
    REM ===== CHOOSE IF EMBBED ID3 TAG TO OUTPUT MP3 =====
    set /p EMBBED_ID3_ENABLED="Embed ID3 metadata? [Y/n] (default Y): "
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
    echo    1. ^<title^>.^<ext^> [default]
    echo    2. ^<artist^> ~ ^<title^>.^<ext^>
    echo    3. ^<title^> ~ [^<id^>].^<ext^>
    echo    4. ^<title^> ~ [^<duration^>].^<ext^>
    echo    5. ^<artist^> ~ ^<title^> - [^<duration^>].^<ext^>
    echo ---------------------------------------

    :: Ask user for choice
    set /p fname_format_choice="Enter your choice (1/2/3/4) or press Enter to use the default [1]: "

    :: Map the choice to the corresponding bitrate or use default (192)
    set "FNAME_FORMAT=%%(title)s.%%(ext)s"
    :: %%(artist)s - %%(title)s.%%(ext)s
    if "%fname_format_choice%"=="2" set "FNAME_FORMAT=%%(uploader)s ~ %%(title)s.%%(ext)s"
    if "%fname_format_choice%"=="3" set "FNAME_FORMAT=%%(title)s ~ [%%(id)s].%%(ext)s"
    if "%fname_format_choice%"=="4" set "FNAME_FORMAT=%%(title)s ~ [%%(duration_string)s].%%(ext)s"
    if "%fname_format_choice%"=="5" set "FNAME_FORMAT=%%(uploader)s ~ %%(title)s ~ [%%(duration_string)s].%%(ext)s"
    :: Inform user of the selected format
    echo Output mp3 filename has format of %FNAME_FORMAT% ...

    echo.

REM ===== MAIN MENU =====
:main_menu
cls
echo ---------------------------------------
echo YouTube to MP3 Downloader
echo ---------------------------------------
echo Settings:
if /i "%GL_QUIET%"=="Y" (
    echo   Quiet mode ENABLED. Defaults will be used automatically.
) else (
    echo   Quiet mode DISABLED.
)
echo   Download Directory: "%DOWNLOAD_DIR%"
if defined EMBBED_ID3_CMD (
    echo   Embed ID3 Metadata: "Yes"
) else (
    echo   Embed ID3 Metadata: "No"
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

:: Check if quiet mode is enabled, set the default filename style without ordinal and jump directly to download command
if /i "%GL_QUIET%"=="Y" (
    set "SG_ORDINAL="
    goto :sg_download_command
)

:: THE FOLLOWING INDENT CODES ARE FOR OPTIONS BEING SKIPPED IF QUIET MODE IS ENABLED
    echo [1] Use default filenames (Title.mp3) - [default]
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
:sg_download_command
echo.
yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
    !EMBBED_ID3_CMD! %AR_VERBOSE% ^
    -o "%DOWNLOAD_DIR%\!SG_ORDINAL!!FNAME_FORMAT!" %VIDEO_URL%

echo.
echo Download complete.
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
    echo File "%URL_LINKS_FILE%" not found in current directory.
    pause
    goto :main_menu
)

:: Check if quiet mode is enabled, set the default filename style without ordinal and jump directly to download command
if /i "%GL_QUIET%"=="Y" (
    set "BA_ORDINAL="
    goto :ba_download_command
)
:: THE FOLLOWING INDENT CODES ARE FOR OPTIONS BEING SKIPPED IF QUIET MODE IS ENABLED
    :: --- Ask for filename style ---
    echo === Batch MP3 Download from urls.txt ===
    echo [1] Use default filenames - [default]
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
:ba_download_command
echo.
yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% ^
    !EMBBED_ID3_CMD! %AR_VERBOSE% ^
    -o "%DOWNLOAD_DIR%\!BA_ORDINAL!!FNAME_FORMAT!" -a "%URL_LINKS_FILE%"

echo.
echo Batch download complete.
pause
goto :main_menu

REM ===== PLAYLIST DOWNLOAD =====
:playlist
cls
echo === Playlist MP3 Download ===
set /p PLAYLIST_URL="Enter YouTube playlist URL: "

:: -----------------------
:: Ask for items to download
:: -----------------------
echo.
echo Choose the range of videos to download from the playlist:
echo ---------------------------------------
echo Press Enter to download whole playlist.
echo -------------------
echo Or specify a range in one of the following formats:
echo  + Format: "item, item, item". Example: 2,4,6 to download item 2, 4, 6
echo  + Format: "[START]-[STOP]". Example: "3-5" to download items 3, 4, 5 
echo  + Format: "[START]:[STOP][:STEP]". Example: "1:6:2" (downloads items 1, 3, 5). "-5::2" to download items from 5th last item to the last item with step size of 2. "::2" to download every even item in the playlist. There can also be missing [START] or [STOP] such as ":5", ":5:3", "139:", "139::2".
echo  + "[START]-" or "[START]:" to download from [START] to the end. Example: "5-" or "5:" to download from item 5 to the end. 
echo -------------------
echo Or comprise of ranges with commas:
echo    Example: 1-3,5:7:2,9- to download items 1,2,3,5,7,and 9 to end
echo.
set /p PL_RANGE_OPT="Choose the range: "
:: set "PL_RANGE_OPT=-2"

if defined PL_RANGE_OPT (
    set "PL_RANGE_OPT=--playlist-items !PL_RANGE_OPT: =!"
    echo   Downloading specified range: !PL_RANGE_OPT!
) else (
    echo   Whole playlist will be downloaded.
)

:: Check if quiet mode is enabled, set the default filename style without ordinal and jump directly to download command
if /i "%GL_QUIET%"=="Y" (
    set "PL_ORDINAL="
    goto :playlist_download_command
)
:: THE FOLLOWING INDENT CODES ARE FOR OPTIONS BEING SKIPPED IF QUIET MODE IS ENABLED
    rem ----------------------------
    rem Ask for using ordinal indexed filename
    rem ----------------------------
    echo.
    echo [1] Use default filenames[default]
    echo [2] Use indexed filenames (Index of the video in the playlist)
    echo [3] Use indexed filenames (Position of the video in the playlist download queue)
    set /p pl_index_choice="Choose filename indexed style (1-3): "
    echo.

    set "PL_ORDINAL="

    if "%pl_index_choice%"=="1" (
        :: for default, no ordinal --> jump to download command
        goto :playlist_download_command
    ) else (
        rem ----------------------------
        rem Ask for Padding size for the ordinal prefix choice (number of digits for padding (3 --we have 001, 002, ...))
        rem ----------------------------
        CALL :GetUserInputNumber "Enter Padding size (number), default 2 (1 becomes 01): " 2
        SET PL_PADDING_DIGITS=!ERRORLEVEL!
        echo Padding size chosen = !PL_PADDING_DIGITS!

        if "%pl_index_choice%"=="2" (
            set "PL_ORDINAL=%%(playlist_index)0!PL_PADDING_DIGITS!d - "
        ) 
        if "%pl_index_choice%"=="3" (
            set "PL_ORDINAL=%%(playlist_autonumber)0!PL_PADDING_DIGITS!d - "
        )
    )
:: -----------------------
:: Download playlist
:: -----------------------
:playlist_download_command
echo.
yt-dlp -x --audio-format mp3 --audio-quality %BITRATE% --yes-playlist ^
    !EMBBED_ID3_CMD! %AR_VERBOSE% ^
    -o "%DOWNLOAD_DIR%\!PL_ORDINAL!!FNAME_FORMAT!" !PL_RANGE_OPT! %PLAYLIST_URL%

echo.
echo Playlist download complete.
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
SET PROMPT=%~1
SET DEFAULT=%~2

REM Prompt the user for input
echo.
SET /P "USER_INPUT=%PROMPT% [default: %DEFAULT%]: "

REM If the user pressed Enter without typing anything, use the default value
IF "%USER_INPUT%"=="" (
    :: SET USER_INPUT=%DEFAULT%
    exit /b %DEFAULT%
)

REM Check if the input is a valid number
:: echo %USER_INPUT% | findstr /R "^[0-9][0-9]*$" >nul

:: ^$ → matches an empty string (Enter key)
:: Quote the entire input to prevent findstr from matching substrings
echo "%USER_INPUT%" | findstr /R "^\"*[0-9][0-9]* *\"*$" >nul
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