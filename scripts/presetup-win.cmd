@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrator OK.
) else (
    echo Error : you must be administrator.
    pause
    exit
)

SET version_docker=1.9.1
SET version_dockercompose=1.5.2

REM *** Installing Chocolatey ***
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

REM *** Installing Packages ***
choco install virtualbox vagrant git -y
choco upgrade virtualbox vagrant git -y
choco install docker -y -version %version_docker%
choco install docker-compose -y -version %version_dockercompose%

REM *** Refresh PATH ***
SET PATH=%PATH%

REM *** Adjusting git defaults ***
git config --global core.autocrlf input
git config --system core.longpaths true

pause
