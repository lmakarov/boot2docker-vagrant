#!/bin/bash

# Docker Host IP
DOCKER_HOST_IP='192.168.10.10'

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

# Download Vagrantfile
echo-green "Downloading Vagrantfile into the current directory..."
curl -sO "https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/Vagrantfile"

# Download vagrant.yml
echo-green "Downloading vagrant.yml into the current directory..."
curl -sO "https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/vagrant.yml"

# Write DOCKER_HOST variable export to a matching .rc file based on the shell (bash or zsh)
SOURCE_FILE=''
DOCKER_HOST_EXPORT="\n# Docker (default for Vagrant based boxes)\nexport DOCKER_HOST=tcp://${DOCKER_HOST_IP}:2375\n"

# Detect shell to write to the right .rc file
if [[ $SHELL == '/bin/bash' || $SHELL == '/bin/sh' ]]; then SOURCE_FILE=".bash_profile"; fi
if [[ $SHELL == '/bin/zsh' ]]; then	SOURCE_FILE=".zshrc"; fi

if [[ $SOURCE_FILE ]]; then
	# See if we already did this and skip if so
	grep -q "export DOCKER_HOST=tcp://${DOCKER_HOST_IP}:2375" $HOME/$SOURCE_FILE
	if [[ $? -ne 0 ]]; then
		echo-green "Adding automatic DOCKER_HOST export to $HOME/$SOURCE_FILE"
		echo -e $DOCKER_HOST_EXPORT >> $HOME/$SOURCE_FILE
	fi
else
	echo-red "Cannot detect your shell. Please manually add the following to your respective .rc or .profile file:"
	echo -e "$DOCKER_HOST_EXPORT"
fi

if [[ $B2D_NO_AUTOSTART == '' ]]; then
	# Start the boot2docker VM
	echo-green "Starting the boot2docker VM..."
	vagrant up

	# Check that Docker works
	echo-green "Checking that everything is in place..."
	docker version && vagrant ssh -c 'docker-compose --version'
	if [[ $? -ne 0 ]]; then
		echo -e "${red}Something went wrong. Please review console output for possible clues.${NC}"
		exit 1
	else
		echo-green "Docker Host is up and running. Please restart your shell."
	fi
fi
