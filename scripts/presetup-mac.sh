#!/bin/bash

DOCKER_VERSION=1.9.0
DOCKER_COMPOSE_VERSION=1.5.0

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

# Homebrew installation
echo -e "${green}Installing Homebrew...${NC}"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Update brew formulae
echo -e "${green}Updating brew formulae...${NC}"
brew update

# VirtualBox installation
echo -e "${green}Installing virtualbox...${NC}"
brew cask install virtualbox
# Kill the default adapter and DHCP server to avoid network issues down the road
VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0
VBoxManage hostonlyif remove vboxnet0

# Vagrant installation
echo -e "${green}Installing vagrant...${NC}"
brew cask install vagrant

# Install docker
echo -e "${green}Installing docker...${NC}"
sudo curl -sSL "https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-$DOCKER_VERSION" -o /usr/local/bin/docker
sudo chmod +x /usr/local/bin/docker

# Install docker-compose
echo -e "${green}Installing docker-compose...${NC}"
sudo curl -sSL "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
