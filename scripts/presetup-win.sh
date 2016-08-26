#!/bin/bash

DOCKER_VERSION=1.12.1
DOCKER_COMPOSE_VERSION=1.8.0
# These two shouldbe changes together. Always check https://github.com/rprichard/winpty/releases for the current version.
WINPTY_VERSION=0.4.0
CYGWIN_VERSION=2.5.2
##

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

echo-red () { echo -e "${red}$1${NC}"; }
echo-green () { echo -e "${green}$1${NC}"; }
echo-yellow () { echo -e "${yellow}$1${NC}"; }

B2D_BRANCH="${B2D_BRANCH:-master}"
B2D_INSTALL_MODE="${B2D_INSTALL_MODE:-full}"

# VirtualBox and Vagrant dependencies
if [[ "$B2D_INSTALL_MODE" == "full" ]] || [[ "$B2D_INSTALL_MODE" == "vm" ]] ; then
	# Install prerequisites via choco (virtualbox and vagrant)
	echo-green "Installing virtualbox and vagrant via choco..."
	curl -sSL https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/scripts/presetup-win.cmd -o $WINDIR/Temp/presetup-win.cmd
	curl -sSL https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/scripts/presetup-win.vbs -o $WINDIR/Temp/presetup-win.vbs
	echo-yellow "Setup needs administrator privileges to contiue..."
	cscript $WINDIR/Temp/presetup-win.vbs
fi

# Docker and other dependencies
if [[ "$B2D_INSTALL_MODE" == "full" ]] || [[ "$B2D_INSTALL_MODE" == "docker" ]] ; then
	# Remove old docker version
	rm -f /usr/local/bin/docker >/dev/null 2>&1 || true
	# Install Docker
	echo-green "Installing docker cli v${DOCKER_VERSION}..."
	curl -sSL -O https://get.docker.com/builds/Windows/i386/docker-$DOCKER_VERSION.zip
	unzip docker-$DOCKER_VERSION.zip
	mv docker/* /usr/local/bin
	rm -rf docker-$DOCKER_VERSION*

	# Remove old docker-compose version
	rm -f /usr/local/bin/docker-compose >/dev/null 2>&1 || true
	# Install Docker Compose
	echo-green "Installing docker-compose v${DOCKER_COMPOSE_VERSION}..."
	curl -sSL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Windows-x86_64.exe -o /usr/local/bin/docker-compose.exe
	chmod +x /usr/local/bin/docker-compose.exe

	# Install winpty
	echo-green "Installing winpty (console) v$WINPTY_VERSION..."
	curl -sSL -O https://github.com/rprichard/winpty/releases/download/$WINPTY_VERSION/winpty-$WINPTY_VERSION-cygwin-$CYGWIN_VERSION-ia32.tar.gz
	tar -xf winpty-$WINPTY_VERSION-cygwin-$CYGWIN_VERSION-ia32.tar.gz
	mv winpty-$WINPTY_VERSION-cygwin-$CYGWIN_VERSION-ia32/bin/* /usr/local/bin
	rm -rf winpty-$WINPTY_VERSION-cygwin-$CYGWIN_VERSION-ia32*

	# Git settings
	echo-green "Adjusting git defaults..."
	git config --global core.autocrlf input
	git config --system core.longpaths true
fi
