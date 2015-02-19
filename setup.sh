# Homebrew installation
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Cask installation
brew install caskroom/cask/brew-cask

# VirtualBox and Vagrant installation
brew cask install virtualbox vagrant

# Install docker client
brew install docker

# Vagrantfile and boot2docker VM
curl -O https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/master/Vagrantfile && vagrant up

# Export DOCKER_HOST variable in ~/.bash_profile
echo -e '\n# Docker (default for Vagrant based boxes)\nexport DOCKER_HOST=tcp://localhost:2375\n' >> ~/.bash_profile
source ~/.bash_profile

# Check that Docker works
docker version
