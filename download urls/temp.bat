@echo off
setlocal enabledelayedexpansion

:: Check if required arguments are passed
if "%~4"=="" (
    echo Usage: %0 base_url start_number end_number padding_size
    exit /b
)

:: Get the arguments
set baseURL="%~1"
set /a start=%~2
set /a end=%~3
set /a paddingSize=%~4

echo Generating URLs from %start% to %end% with padding size %paddingSize%
echo Base URL: %baseURL%

:: Check if the base URL contains a wildcard (*)
echo %baseURL% | findstr /C:"*" >nul
if errorlevel 1 (
    echo Error: Base URL must contain a wildcard ^(*^) in the place of the number.
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
    :: !formattedNumber!
    set "URL=!baseURL:*=!formattedNumber!!"

    echo !URL!
)

endlocal
pause