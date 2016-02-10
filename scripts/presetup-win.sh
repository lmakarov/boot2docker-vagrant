#!/bin/bash


# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

echo-red () { echo -e "${red}$1${NC}"; }
echo-green () { echo -e "${green}$1${NC}"; }
echo-yellow () { echo -e "${yellow}$1${NC}"; }

# For testing
if [ ! $B2D_BRANCH == "" ]; then
	echo-red "[b2d-setup] testing mode: environment = ${B2D_BRANCH}"
else
	B2D_BRANCH='master'
fi

# Install prerequisites via choco (virtualbox and vagrant)
echo-green "Installing virtualbox and vagrant via choco..."
curl -sSL https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/scripts/presetup-win.cmd -o $WINDIR/Temp/presetup-win.cmd
curl -sSL https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/scripts/presetup-win.vbs -o $WINDIR/Temp/presetup-win.vbs
echo-yellow "Setup needs administrator privileges to contiue..."
cscript $WINDIR/Temp/presetup-win.vbs
