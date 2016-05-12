#!/bin/bash

DOCKER_VERSION=1.10.3
DOCKER_COMPOSE_VERSION=1.6.2

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

echo-red () { echo -e "${red}$1${NC}"; }
echo-green () { echo -e "${green}$1${NC}"; }
echo-yellow () { echo -e "${yellow}$1${NC}"; }

# # Homebrew installation
# echo-green "Installing Homebrew..."
# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# # Update brew formulae
# echo-green "Updating brew formulae..."
# brew update

# # VirtualBox installation
# echo-green "Installing virtualbox..."
# brew cask install virtualbox
# Kill the default adapter and DHCP server to avoid network issues down the road
echo-green "Configuring virtualbox..."
VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0 > /dev/null 2>&1
VBoxManage hostonlyif remove vboxnet0 > /dev/null 2>&1

# # Vagrant installation
# echo-green "Installing vagrant..."
# brew cask install vagrant

# Install docker
echo-green "Installing docker cli v${DOCKER_VERSION}..."
sudo curl -sSL "https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-$DOCKER_VERSION" -o /usr/local/bin/docker
sudo chmod +x /usr/local/bin/docker

# Install docker-compose
echo-green "Installing docker-compose v${DOCKER_COMPOSE_VERSION}..."
sudo curl -sSL "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
