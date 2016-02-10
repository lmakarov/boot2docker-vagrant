@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrator OK.
) else (
    echo Error : you must be administrator.
    pause
    exit
)

REM *** Installing Chocolatey ***
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

REM *** Installing Packages ***
choco install virtualbox vagrant git docker docker-compose -y
choco upgrade virtualbox vagrant git docker docker-compose -y

REM *** Refresh PATH ***
SET PATH=%PATH%

REM *** Adjusting git defaults ***
git config --global core.autocrlf input
git config --system core.longpaths true

pause
