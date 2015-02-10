# boot2docker-vagrant-nfs
Vagrant and boot2docker with NFS mounts support for better performance on OSX.  

## tldr; How to use.
Copy the Vagrantfile in this repo into your < Projects > (shared boo2docker VM) or < Project > (dedicated boot2docker VM) directory.

    $ vagrant up
    $ export DOCKER_HOST=tcp://localhost:2375`
    $ docker version

## What is this?
This is a temporary solution to get a better performance with docker data volumes mounted from your OSX host.  
Boot2docker currently mounts host volumes via the default VirtualBox Guest Additions (vboxfs) mode, which is terribly slow on OSX.  
You can achieve much better performance with a NFS mount.

There is a customzed boot2docker box available on Vagrantcloud which adds support for NFS mounts - [yungsang/boot2docker]( https://vagrantcloud.com/yungsang/boxes/boot2docker)

## How does it work?
Vagrant mounts the current directory via NFS inside the boot2docker VM with the same path as the curent directory.  
E.g. /User/<username>/Projects/MyProject becomes transparently available at the same path in the boot2docker VM.

This allows docker to mount that same directory as a data volume from its host (boot2docker VM). This is especially important for [Fig](http://www.fig.sh), which otherwise will not work properly with data volumes on Mac.

See [Managing Data in Containers](https://docs.docker.com/userguide/dockervolumes/) for more infor on data volumes with docker.

## Tips

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
