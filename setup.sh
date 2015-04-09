#!/bin/bash

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

# Homebrew installation
echo -e "${green}Installing Homebrew...${NC}"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Cask installation
echo -e "${green}Installing Cask...${NC}"
brew install caskroom/cask/brew-cask

# Update brew formulae
echo -e "${green}Updating brew formulae...${NC}"
brew update

# VirtualBox installation
echo -e "${green}Installing virtualbox...${NC}"
brew cask install virtualbox

# Vagrant installation
echo -e "${green}Installing vagrant...${NC}"
brew cask install vagrant

# Install docker
echo -e "${green}Installing docker...${NC}"
brew install docker

# Install docker-compose
echo -e "${green}Installing docker-compose...${NC}"
brew install docker-compose

# Download Vagrantfile
echo -e "${green}Downloading Vagrantfile into the current directory...${NC}"
curl -sO https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/master/Vagrantfile

# Start the boot2docker VM
echo -e "${green}Starting the boot2docker VM...${NC}"
vagrant up

# Write DOCKER_HOST variable export to a matching .rc file based on the shell (bash or zsh)
SOURCE_FILE='';
DOCKER_HOST_EXPORT='\n# Docker (default for Vagrant based boxes)\nexport DOCKER_HOST=tcp://localhost:2375\n'

# Detect shell to write to the right .rc file
if [[ $SHELL == '/bin/bash' ]]; then SOURCE_FILE=".bashrc"; fi
if [[ $SHELL == '/bin/zsh' ]]; then	SOURCE_FILE=".zshrc"; fi

if [[ $SOURCE_FILE ]]; then
	# See if we already did this and skip if so
	grep -Rq "export DOCKER_HOST=tcp://localhost:2375" $HOME/$SOURCE_FILE
	if [[ $? -ne 0 ]]; then
		echo -e "${green}Adding automatic DOCKER_HOST export to $HOME/$SOURCE_FILE${NC}"
		echo -e $DOCKER_HOST_EXPORT >> $HOME/$SOURCE_FILE
	fi
else
	echo -e "${red}Cannot detect your shell. Please manually add the following to your respective .rc or .profile file:${NC}"
	echo -e "$DOCKER_HOST_EXPORT"
fi

# Check that Docker works
echo -e "${green}Checking that everything is in place...${NC}"
docker version
if [[ $? -ne 0 ]]; then
	echo -e "${red}Something went wrong. Please review console output for possible clues."
fi
