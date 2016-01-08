#!/bin/bash

DOCKER_VERSION=1.9.1
DOCKER_COMPOSE_VERSION=1.5.2

# For testing
if [ ! $B2D_BRANCH == "" ]; then
	echo -e "${red}[b2d-setup] testing mode: environment = \"${B2D_BRANCH}\"$NC"
else
	B2D_BRANCH='master'
fi

# Install prerequisites via choco (virtualbox and vagrant)
curl -L https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/scripts/presetup-win.cmd -o $WINDIR/Temp/presetup-win.cmd
curl -L https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/scripts/presetup-win.vbs -o $WINDIR/Temp/presetup-win.vbs
echo "Setup needs administrator privileges to contiue..."
cscript $WINDIR/Temp/presetup-win.vbs

# Install Docker
curl -L https://get.docker.com/builds/Windows/i386/docker-$DOCKER_VERSION.exe -o /usr/local/bin/docker
chmod +x /usr/local/bin/docker

# Install Docker Compose
curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Windows-x86_64.exe > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Git settings
echo "Adjusting git defaults"
git config --global core.autocrlf input
git config --system core.longpaths true
