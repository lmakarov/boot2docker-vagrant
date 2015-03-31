# Boot2docker Vagrant Box
Boot2docker Vagrant box for optimized Docker and Docker Compose use on Mac and Windows.

## What is this?
This is a temporary solution to achive better performance with synced folders and docker data volumes on Mac and Windows.  
The stock boot2docker currently mounts host volumes via the default VirtualBox Guest Additions (vboxfs) mode, which is terribly slow. Much better performance can be achieved with NFS, SMB or rsync.

Supports all [Synced Folder](http://docs.vagrantup.com/v2/synced-folders/) options provided by Vagrant:
- vboxfs - native VirtualBox method, cross-platform, convenient and reliable, terribly slow
- NFS - better performance and convenience for Mac
- SMB - better performance and convenience for Windows (on par with NFS on Mac)
- rsync - best performance, cross-platform, one-way only

## Requirements
1. [VirtualBox](https://www.virtualbox.org/) 4.3.20+
2. [Vagrant](https://www.vagrantup.com/) 1.6.3+
3. [Git](http://git-scm.com/)

## Setup and usage

### Automatic installation (Mac only)
This installs the following prerequisites and dependencies: brew, cask, virtualbox, vagrant, docker, docker-compose

    curl https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/master/setup.sh | bash

### Manual installation (Windows)

**On Windows** Git Bash is the recommended option to run console commands.  
If you are having any issues, please check if they can be reproduced in Git Bash.

1. Copy the Vagrantfile in this repo into your < Projects > (shared boo2docker VM for multiple projects, recommended) or < Project > (dedicated boot2docker VM) directory.
2. Start the VM and log into it

    ```
    vagrant up
    vagrant ssh
    ```

3. Verify installation (you are in the boot2docker VM at this point)
    
    ```
    docker version
    docker-compose --version
    ```

## Synced Folder options

Follow the instructions in the Vagrantfile (**Synced folders configuration** section) to switch between different options.

    WARNING:
    Make sure only one is enabled at a time (nfs/smb, vboxfs, rsync).
    If several synced folders options are enabled at the same time the last one takes precedence.

### Mac
On Mac NFS provides good performance and convenience. It is the default option configured in the Vagrantfile.

Option comparison for Mac Drupal developers (using `time drush si -y` as a test case):
- vboxfs: 6x (slowest)
- NFS: 1.3x
- rsync: 1x (fastest)

### Windows
On Windows SMB provides good performance and convenience. It is the default option configured in the Vagrantfile.

Option comparison for Windows Drupal developers (using `time drush si -y` as a test case):
- vboxfs: 5x (slowest)
- SMB: 2x
- rsync: 1x (fastest)

**SMB**

SMB requires vagrant to be started as an administrator.
This can be done by launching the Git Bash shell as an administrator, then starting vagrant from there (`vagrant up`).

**rsync**

rsync is not natively available on Windows.  
Git for Windows comes with Git Bash shell, which is based on [MinGW/MSYS](http://www.mingw.org/wiki/msys).  
MSYS has a package for rsync, which can be installed and accessed via Git Bash.

Download and extract the content on this [archive](https://drive.google.com/open?id=0B130F0xKxOWCTUN1d3djZGZ0M2M&authuser=0) into the `bin` directory of your Git installation (e.g. `c:\Program Files (x86)\Git\bin\`).

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
