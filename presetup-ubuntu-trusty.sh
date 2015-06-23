#!/bin/bash

DOCKER_COMPOSE_VERSION=1.3.1

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'


# Install docker
echo -e "${green}Installing docker...${NC}"
wget -qO- https://get.docker.com/ | sh

# Install docker-compose
echo -e "${green}Installing docker-compose...${NC}"
curl -fsL "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
