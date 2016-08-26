#!/bin/bash

DOCKER_VERSION=1.12.1
DOCKER_COMPOSE_VERSION=1.8.0

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
	# Homebrew installation
	echo-green "Installing Homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	# Update brew formulae
	echo-green "Updating brew formulae..."
	brew update

	# VirtualBox installation
	echo-green "Installing virtualbox..."
	brew cask install virtualbox
	# Kill the default adapter and DHCP server to avoid network issues down the road
	VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0 > /dev/null 2>&1
	VBoxManage hostonlyif remove vboxnet0 > /dev/null 2>&1

	# Vagrant installation
	echo-green "Installing vagrant..."
	brew cask install vagrant
fi

# Docker and other dependencies
if [[ "$B2D_INSTALL_MODE" == "full" ]] || [[ "$B2D_INSTALL_MODE" == "docker" ]] ; then
	# Remove old docker version
	sudo rm -f /usr/local/bin/docker >/dev/null 2>&1 || true
	# Install docker
	echo-green "Installing docker cli v${DOCKER_VERSION}..."
	curl -sSL -O "https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-$DOCKER_VERSION.tgz"
	tar zxf docker-$DOCKER_VERSION.tgz
	sudo mv docker/* /usr/local/bin
	rm -rf docker-$DOCKER_VERSION*

	# Remove old docker-compose version
	sudo rm -f /usr/local/bin/docker-compose >/dev/null 2>&1 || true
	# Install docker-compose
	echo-green "Installing docker-compose v${DOCKER_COMPOSE_VERSION}..."
	sudo curl -sSL "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
fi
