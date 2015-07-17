#!/bin/bash

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

# For testing
if [ ! $B2D_BRANCH == "" ]; then
	echo -e "${red}[b2d-setup] testing mode: environment = \"${B2D_BRANCH}\"$NC"
else
	B2D_BRANCH='master'
fi

# Download Vagrantfile
echo -e "${green}Downloading Vagrantfile into the current directory...${NC}"
curl -sO "https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/Vagrantfile"

# Download vagrant.yml
echo -e "${green}Downloading vagrant.yml into the current directory...${NC}"
curl -sO "https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/vagrant.yml"

# Start the boot2docker VM
echo -e "${green}Starting the boot2docker VM...${NC}"
vagrant up

# Write DOCKER_HOST variable export to a matching .rc file based on the shell (bash or zsh)
SOURCE_FILE='';
DOCKER_HOST_EXPORT='\n# Docker (default for Vagrant based boxes)\nexport DOCKER_HOST=tcp://localhost:2375\n'

# Detect shell to write to the right .rc file
if [[ $SHELL == '/bin/bash' || $SHELL == '/bin/sh' ]]; then SOURCE_FILE=".bash_profile"; fi
if [[ $SHELL == '/bin/zsh' ]]; then	SOURCE_FILE=".zshrc"; fi

if [[ $SOURCE_FILE ]]; then
	# See if we already did this and skip if so
	grep -q "export DOCKER_HOST=tcp://localhost:2375" $HOME/$SOURCE_FILE
	if [[ $? -ne 0 ]]; then
		echo -e "${green}Adding automatic DOCKER_HOST export to $HOME/$SOURCE_FILE${NC}"
		echo -e $DOCKER_HOST_EXPORT >> $HOME/$SOURCE_FILE
	fi
	# Source the file so we can use the DOCKER_HOST variabel right away.
	. $HOME/$SOURCE_FILE
else
	echo -e "${red}Cannot detect your shell. Please manually add the following to your respective .rc or .profile file:${NC}"
	echo -e "$DOCKER_HOST_EXPORT"
fi

# Check that Docker works
echo -e "${green}Checking that everything is in place...${NC}"
docker version && vagrant ssh -c 'docker-compose --version'
if [[ $? -ne 0 ]]; then
	echo -e "${red}Something went wrong. Please review console output for possible clues.${NC}"
	exit 1
else
	echo -e "${green}Docker Host is up and running. Please restart your shell.${NC}"
fi
