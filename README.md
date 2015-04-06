# Boot2docker Vagrant Box
Boot2docker Vagrant box for optimized Docker and Docker Compose use on Mac and Windows.

## What is this?
This is a temporary solution to achive better performance with synced folders and docker data volumes on Mac and Windows.  
The stock boot2docker currently mounts host volumes via the default VirtualBox Guest Additions (vboxfs) mode, which is terribly slow. Much better performance can be achieved with NFS, SMB or rsync.

<a name="requirements"></a>
## Requirements
1. [VirtualBox](https://www.virtualbox.org/) 4.3.20+
2. [Vagrant](https://www.vagrantup.com/) 1.6.3+
3. [Git](http://git-scm.com/)

<a name="setup"></a>
## Setup and usage

### Automatic installation (Mac only)
This installs the following prerequisites and dependencies: brew, cask, virtualbox, vagrant, docker, docker-compose

    curl https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/master/setup.sh | bash

### Manual installation (Windows)

**On Windows** Git Bash is the recommended option to run console commands.
If you are having any issues, please check if they can be reproduced in Git Bash.

1. Copy `Vagrantfile` and `vagrant.yml.dist` files from this repo into your `<Projects>` (shared boo2docker VM for multiple projects, recommended) or `<Project>` (dedicated boot2docker VM) directory.
2. Rename `vagrant.yml.dist` to `vagrant.yml`
3. Launch Git Bash
4. cd to `</path/to/project>`, start the VM and log into it

    ```
    cd </path/to/project>
    vagrant up
    vagrant ssh
    ```

5. Verify installation (you are in the boot2docker VM at this point)
    
    ```
    docker version
    docker-compose --version
    ```

<a name="synced-folders"></a>
## Synced Folders options

This box supports all [Synced Folder](http://docs.vagrantup.com/v2/synced-folders/) options provided by Vagrant:
- vboxfs - native VirtualBox method, cross-platform, convenient and reliable, terribly slow
- NFS - better performance and convenience for Mac
- SMB - better performance and convenience for Windows (on par with NFS on Mac)
- rsync - best performance, cross-platform, one-way only

Follow the instructions in the `vagrant.yml` file to switch between different sync options.
The best balance between performance and convenience can be achieved with NFS on Mac (default) and SMB on Windows (not default).

Additional steps are required to get SMB or rsync to work on Windows. [See below](#synced-folders-win).

<a name="synced-folders-mac"></a>
### Mac

Option comparison for Mac Drupal developers (using `time drush si -y` as a test case):
- vboxfs: 6x (slowest)
- NFS: 1.3x
- rsync: 1x (fastest)

NFS provides good performance and convenience. It is the default and recommended option on Mac.

<a name="synced-folders-win"></a>
### Windows

Option comparison for Windows Drupal developers (using `time drush si -y` as a test case):
- vboxfs: 5x (slowest)
- SMB: 2x
- rsync: 1x (fastest)

SMB provides good performance and convenience. It is the recommended option, but NOT the default one on Windows.

**Enabling SMB**

To use the SMB synced folder type: 

1. Stop the VM with: `vagrant halt`
2. Choose `smb` as the sync type in the `vagrant.yml` file.
3. Launch Git Bash as an administrator
4. Start the VM: `vagrant up`

While using SMB you have to control Vagrant from an elevated (run as admin) Git Bash shell.

**Enabling rsync**

rsync is not natively available on Windows.  
Git for Windows comes with Git Bash shell, which is based on [MinGW/MSYS](http://www.mingw.org/wiki/msys).  
MSYS has a package for rsync, which can be installed and accessed via Git Bash.

To use rsync on Windows:

1. Download and extract the content on this [archive](https://drive.google.com/open?id=0B130F0xKxOWCTUN1d3djZGZ0M2M&authuser=0) into the `bin` directory of your Git installation (e.g. `c:\Program Files (x86)\Git\bin\`).
2. Choose `rsync` as the sync type in the `vagrant.yml` file.
3. Provide an explicit list of folders to sync in the `vagrant.yml` file (`folders` sequence).
4. Reload the VM: `vagrant reload`

**SMB2 (experimental option)**

This is an experimental option.  
Compared to `smb`, `smb2` does not require running vagrant as admin, but requires initial manual setup:

1. Create a Windows user with a password (e.g. `vagrant:<password>`)
2. Share the `<Projects>` directory.
    > The share name has to match the directory name.  
    > E.g. share `C:\Work\Projects` as `Projects`

3. Give the user created in step 1 full access to the share.
4. Update `vagrant.yml`:
    > ...  
    > type: 'smb2'  
    > ...  
    > smb_username: '<username>'  
    > smb_password: '<password>'  
    > ...

5. Reload the VM (`vagrant reload`)

## Tips

### Automate DOCKER_HOST variable export

    This is only necessary for manual instllations. Install script takes care of this for you.

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
