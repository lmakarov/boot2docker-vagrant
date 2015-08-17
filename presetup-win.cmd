REM Install Chocolatey
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

REM Install babun, virtualbox, vagrant, docker
choco install babun -y
choco install virtualbox -y
choco install vagrant -y
choco install docker -y

REM Git configuration (proper line endings on Windows and support for long paths)
git config --global core.autocrlf input
git config --system core.longpaths true
