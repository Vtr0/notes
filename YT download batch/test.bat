@echo off
:: Turns on delayed variable expansion, which lets you safely use !VAR! to get the current value of a variable inside loops or code blocks.
setlocal enabledelayedexpansion
REM Main script starts here

REM Call the subroutine to ask for input
CALL :GetUserInputNumber "Enter Padding size (number), default 2 (1 becomes 01): " 2

REM Check if the user entered a valid number (ERRORLEVEL stores the return value)
IF !ERRORLEVEL! GEQ 0 (
    echo You entered a Padding size: %ERRORLEVEL%
) ELSE (
    echo Invalid input! Please enter a valid number.
)

CALL :GetUserInputNumber "Enter start index (number), default 1: " 0

REM Check if the user entered a valid number (ERRORLEVEL stores the return value)
IF !ERRORLEVEL! GEQ 0 (
    echo You entered a valid start index: %ERRORLEVEL%
) ELSE (
    echo Invalid input! Please enter a valid number.
)

exit /b

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
:: Try arithmetic to see if it's numeric
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