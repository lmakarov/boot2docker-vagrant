# boot2docker-vagrant
Vagrant based boot2docker box with NFS mounts support for better performance on OSX.  
Windows hosts will fall back to the defaukt vboxfs shared folders in Virtualbox.

## Requirements
1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](https://www.vagrantup.com/) 1.6.3+

## TL;DR. How to use.
Copy the Vagrantfile in this repo into your < Projects > (shared boo2docker VM) or < Project > (dedicated boot2docker VM) directory.

    $ vagrant up
    $ export DOCKER_HOST=tcp://localhost:2375
    $ docker version

### One-liner for the lazy Mac people (OSX only!)

This installs the following prerequisites and dependencies: brew, cask, virtualbox, vagrant, docker

    curl https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/master/setup.sh | bash

## What is this?
This is a temporary solution to get a better performance with docker data volumes mounted from your OSX host.  
Boot2docker currently mounts host volumes via the default VirtualBox Guest Additions (vboxfs) mode, which is terribly slow on OSX. Much better performance can be achieved with NFS.

There is a customzed boot2docker box available on Vagrantcloud which adds support for NFS mounts - [yungsang/boot2docker]( https://vagrantcloud.com/yungsang/boxes/boot2docker)

## How does it work?
Vagrant mounts the root directory (were the Vagrantfile is located) via NFS inside the boot2docker VM with the same path as on the host.  

    /User/<username>/Projects/MyProject on the host => /User/<username>/Projects/MyProject in the boot2docker VM.

Docker containers inside boot2docker can then mount volumes transparently as if they were mounted directry from the host. This is especially important for [Fig](http://www.fig.sh), which otherwise will not work properly with data volumes on Mac.

See [Managing Data in Containers](https://docs.docker.com/userguide/dockervolumes/) for more infor on data volumes with docker.

## Tips

### Automate DOCKER_HOST variable export

Add the following in your .bashrc, .zshrc, etc. file to automate the environment variable export:

    # Docker (default for Vagrant based boxes)
    export DOCKER_HOST=tcp://localhost:2375

If you also have `$(boot2docker shellinit)` there, then make sure those lines go BEFORE it, e.g.:

    # Docker (default for Vagrant based boxes)
    export DOCKER_HOST=tcp://localhost:2375
    
    # boot2docker shellinit
    $(boot2docker shellinit)

This way if boot2docker is NOT running, your `DOCKER_HOST` will default to `tcp://localhost:2375`.
Otherwise `$(boot2docker shellinit)` will overwrite the variables and set `DOCKER_HOST` to point to the boot2docker VM.

### Vagrant control

Vagrant can be controlled (e.g. `vagrant up`, `vagrant ssh`, `vagrant reload`, etc.) from the root directory of the Vagrantfile as well as from any subdirectory. This is very usefull when working with multiple projects in subdirectories.

### Sublime Text 3 users

Add this to your user settings (Sublime Text > Preferences > Settings - User):

    {
        "atomic_save": false
    }

ST3 does not update the ctime extended file attribute when saving a file. This leads to NFS not seeing the changes in a file unless the file size changes as well (i.e. changing a single symbol in a file with ST3 will not be visible over NFS). The setting above fixes that.
