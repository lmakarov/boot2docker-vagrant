#!/bin/bash

DOCKER_VERSION=1.8.1
DOCKER_COMPOSE_VERSION=1.4.0

# For testing
if [ ! $B2D_BRANCH == "" ]; then
	echo -e "${red}[b2d-setup] testing mode: environment = \"${B2D_BRANCH}\"$NC"
else
	B2D_BRANCH='develop'
fi

# Install prerequisites via choco (virtualbox and vagrant)
curl -L https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/presetup-win.cmd -o $WINDIR/Temp/presetup-win.cmd
curl -L https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/presetup-win.vbs -o $WINDIR/Temp/presetup-win.vbs
echo "Setup needs administrator privileges to contiue..."
cscript $WINDIR/Temp/presetup-win.vbs

# Install Docker
curl -L https://get.docker.com/builds/Windows/i386/docker-$DOCKER_VERSION.exe -o /usr/local/bin/docker
chmod +x /usr/local/bin/docker

# Install Docker Compose (via pip)
pact install python-setuptools libxml2-devel libxslt-devel libyaml-devel
curl -skS https://bootstrap.pypa.io/get-pip.py | python
pip install virtualenv
curl -skS https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python
pip install -U docker-compose==$DOCKER_COMPOSE_VERSION

# Git settings
echo "Adjusting git defaults"
git config --global core.autocrlf input
git config --system core.longpaths true
