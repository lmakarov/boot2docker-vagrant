# Changelog

## 1.3.1 (2015-11-16)

- Remove /cygdrive prefix
  - /cygdrive prefix was needed for docker-compose installed via pip. The native binary does not expect this prefix.
- Give all permissions on files (777) on the smb mount
  - Allows any script files to be executed

## 1.3.0 (2015-11-10)

- Version updates
  - boot2docker base box v1.9.0
  - Docker v1.9.0
  - Docker Compose v1.5.0 (now installed as a binary on Windows)
- Default to **nfs2** on Mac and **smb2** on Windows
- rsync
  - Switching to vagrant-gatling-rsync for better rsync-auto performance
  - Auto start gatling-rsync-auto **in background** (Mac only)
- Revised vboxsf, smb and rsync settings
- Fixed vagrant user account expiration (smb2 option)
- Added a way to define individual mounts
- Added "group=system" label to dns and vhost-proxy containers
- Added support for authentication against docker hub
- Fixed typo: vboxfs => vboxsf

## 1.2.1 (2015-10-28)

- Update path to shell scripts in README.md

## 1.2.0 (2015-10-26)

- Switched to new base box version 1.8.3
  - Docker v1.8.3, Docker Compose v1.4.2
  - SFTP support (user: docker, password: tcuser or using vagrants insecure key)
- Added nfs2 synced folders option with optimized NFS settings (experimental and default)
- Switched to vhost-proxy [v1.1.0](https://github.com/blinkreaction/docker-nginx-proxy/releases/tag/v1.1.0) and dns-discovery [v1.0.0](https://github.com/blinkreaction/docker-dns-discovery/releases/tag/v1.0.0) container images
- Moved scripts to a subfolder
- Fixed Version requirements for Vagrant and Virtual Box

## 1.1.1 (2015-10-01)

- Fix path to VBoxManage on Windows

## 1.1.0 (2015-09-30)

- Switch to blinkreaction/boot2docker base box v1.8.2
  - Docker v1.8.2
  - Docker Compose v1.4.2
- DNS resolution and service discovery
  - Simple DNS based service discovery using dnsmasq and docker-gen
  - dns service container is required and cannot be disabled
- Default box IP can be configured in vagrant.yml
- vhost-proxy HTTPS support
- Switch to the stable branch for dsh (master)
- Docs updates
  - DNS resolution and service discovery
  - Bumped required/supported VirtualBox (5.0+) and Vagrant (1.7.3+) versions
- Disable default DHCP server and network interface after VirtualBox installation

## 1.0.2 (2015-09-22)

- Fix docker and docker-compose install on mac
- README - mention that preset scripts can be used for updates as well

## 1.0.1 (2015-09-14)

- Host's home directory mapping (`~ => /.home`) to make SSH keys and other credentials and configs available to containers.

## 1.0.0 (2015-09-14)

- SMB mounts on Windows
  - Added `smb2_auto: true/false` option to allow switching to manual provisioning of the smb user and share.
  - Fixed share permissions
- Added Troubleshooting docs

## 1.0.0-rc2 (2015-08-18)

- Upgrade to Docker 1.8.1 base box
  - Docker 1.8.1, Docker Compose 1.4.0
- Switching to Babun shell on Windows
- Now binding to the particular versions of Docker and Docker Compose on both Mac and Windows
- Fully automated setup on Windows (once Babun is installed)
- Minor fixes and cleanup, documentation updates

## 1.0.0-rc1 (2015-07-02)

- Upgrade to Docker 1.7.0 base box
  - moved some provisioning scripts into the base box
- vhost-proxy service is now enabled by default in vagrant.yml (`vhost_proxy: true`)
  - switched vhost-proxy container to a lightweight Alpine Linux base image
- Added dns service to resolve *.drude to VM's primary IP address (`192.168.10.10`)
- Some adjustments in the networking settings
- presetup-mac: Install docker and docker-compose directly instead of brew to match the Docker server version
- Added support to setup scripts to test different branches. E.g. `BOOT2DOCKER_TEST_ENVIRONMENT=develop setup.sh`
- Updated documentation

## 0.13.0 (2015-06-18)

- Split install scripts into two pieces: prerequisites installation (optional) and actual box installation.
- Automatic installation is now supported on Windows!
- vhost-proxy service - adds ability to use a single shared IP address for multiple web projects running concurrently.
- VirtualBox network adapters performance adjustments (using `virtio` on the NAT interface). Resolves #12.
- Added bash to avoid shell script compatibility issues and updated all shell scripts to use `#/bin/bash` header. Resolves #17.
- Documentation updates.

## 0.12.1 (2015-06-06)

- Minor fixes in the setup.sh script for Mac

## 0.12.0 (2015-05-07)

- Use our own vagrant box - [blinkreaction/boot2docker](https://vagrantcloud.com/blinkreaction/boxes/boot2docker)
  - Updated Docker to v1.6.0
  - Updated Docker Compose to v1.2.0
- [SMB2 (experimental)] sync folder option for Windows - complete automation of SMB sharing setup.
- Automatically start containers if docker-compose.yml is present in the Vagrantfile directory (single project mode)
- Miscellaneous code cleanup

## 0.11.1 (2015-04-09)

- Hotfix: added check for empty hosts in vagrant.yml

## 0.11.0 (2015-04-09)

- Using semantic versioning and tracking changes in the CHANGELOG.md file
- All configuration moved into vagrant.yml
- Refactored synced folders setup
  - Focused on better Windows support with SMB and rsync
  - Added an experimental `smb2` synced folder option, which does not require running vagrant as admin, but requires initial manual setup.
  - rsync can now be done per project instead of the whole <Projects> folder
- Documentation overhaul
- Fixes in setup.sh - making sure brew formulae are up to date.
