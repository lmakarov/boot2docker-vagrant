#!/bin/bash

DOCKER_VERSION=1.11.2
DOCKER_COMPOSE_VERSION=1.7.1

#-------------------------- Helper functions --------------------------------

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

echo-red () { echo -e "${red}$1${NC}"; }
echo-green () { echo -e "${green}$1${NC}"; }
echo-yellow () { echo -e "${yellow}$1${NC}"; }

if_failed ()
{
	if [ ! $? -eq 0 ]; then
		if [[ "$1" == "" ]]; then msg="dsh: error"; else msg="$1"; fi
		echo-red "dsh: $msg"
		exit 1
	fi
}

#-------------------------- Installation --------------------------------

if [ -r /etc/lsb-release ]; then
	lsb_dist="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
	lsb_release="$(. /etc/lsb-release && echo "$DISTRIB_RELEASE")"
fi

if [[ $lsb_dist != 'Ubuntu' || $lsb_release < '14.04' ]]; then
	echo-red "Sorry, this script only supports Ubuntu 14.04+"
	exit 1
fi

echo-green "Installing Docker v${DOCKER_VERSION}..."
curl -sSL https://get.docker.com/ | sh && \
sudo usermod -aG docker $(whoami) && \
sudo docker version
if_failed "Docker installation/upgrade failed."

echo-green "Installing Docker Compose v{DOCKER_COMPOSE_VERSION}..."
sudo curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
sudo chmod +x /usr/local/bin/docker-compose && \
docker-compose --version
if_failed "Docker Compose installation/upgrade failed."

echo-green "Adding a subnet for DockerBox..."
ip_mask="192.168.10.1/24"
# Make sure we don't do this twice
if ! grep -q $ip_mask /etc/network/interfaces; then
	cat > /tmp/dockerbox.ip.addr <<EOF
up   ip addr add 192.168.10.1/24 dev lo label lo:dockerbox
down ip addr del 192.168.10.1/24 dev lo label lo:dockerbox
EOF
	sudo sed -i '/iface lo inet loopback/r /tmp/dockerbox.ip.addr' /etc/network/interfaces
	rm -f /tmp/dockerbox.ip.addr
	sudo ifdown lo && sudo ifup lo
	if_failed "DockerBox subnet configuration failed failed."
fi

echo-green "Creating DockerBox HTTP/HTTPS reverse proxy..."
sudo docker rm -vf vhost-proxy || true
sudo docker run -d --name vhost-proxy --label "group=system" --restart=always \
	-p 192.168.10.10:80:80 -p 192.168.10.10:443:443 \
	-v /var/run/docker.sock:/tmp/docker.sock \
	blinkreaction/nginx-proxy:stable
if_failed "DockerBox HTTP/HTTPS reverse proxy setup failed."

echo-green "Creating Drude ssh-agent service..."
sudo docker rm -f ssh-agent || true
sudo docker run -vd --name ssh-agent --label "group=system" --restart=always \
	-v /var/run/docker.sock:/var/run/docker.sock \
	blinkreaction/ssh-agent:stable
if_failed "Drude ssh-agent service setup failed."

echo-green "Creating DockerBox DNS service..."
sudo docker rm -vf dns || true
sudo docker run -d --name dns --label "group=system" --restart=always \
	-p 192.168.10.10:53:53/udp --cap-add=NET_ADMIN --dns 8.8.8.8 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	blinkreaction/dns-discovery:stable
if [[ $? == 0 ]]; then
	echo-green "Configuring host DNS resolver for .drude domain..."
	echo -e "\n# .drude domain resolution\nnameserver 192.168.10.10" | sudo tee -a  /etc/resolvconf/resolv.conf.d/head 
	sudo resolvconf -u
else
	echo-red "DockerBox DNS service setup failed."
fi

	echo-green "To run docker without sudo log out and back in or run 'newgrp docker' now."