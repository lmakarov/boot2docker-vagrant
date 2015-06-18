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
