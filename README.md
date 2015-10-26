# Boot2docker Vagrant Box
Boot2docker Vagrant box for optimized Docker and Docker Compose use on Mac and Windows.

## What is this?
This is a temporary solution to achieve better performance with synced folders and docker data volumes on Mac and Windows.  
The stock boot2docker currently mounts host volumes via the default VirtualBox Guest Additions (vboxfs) mode, which is terribly slow. Much better performance can be achieved with NFS, SMB or rsync.

<a name="requirements"></a>
## Prerequisites
1. [VirtualBox](https://www.virtualbox.org/) 5.0+
2. [Vagrant](https://www.vagrantup.com/) 1.7.3+
3. [Babun](http://babun.github.io) - A Linux-type shell, **Windows only**

Proceed to [Setup and usage](#setup) if you already have all prerequisites installed or prefer to install some/all manually.  

Automatic **installation** and **updates** of prerequisites is available via the following one-liners.  
Make sure to stop all VirtualBox VMs prior to performing updates.

**Mac**

Prerequisites are installed using **brew/cask** (brew and cask will be installed if missing).

    bash <(curl -s https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/master/presetup-mac.sh)

**Windows**

**On Windows you will need a good Linux-type shell. [Babun](http://babun.github.io) is a great option. All automated scripts and instructions in this project assume using Babun shell and were not tested with other CYGWIN shells.**

Prerequisites are installed using **babun** and **chocolatey** (chocolatey will be installed if missing).

**Docker Compose will be installed natively on Windows via pip!**

1. Download and install [Babun](http://babun.github.io)
2. Run the following in babun

    ```
    bash <(curl -s https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/master/presetup-win.sh)
    ```

<a name="setup"></a>
## Setup and usage

### Automatic installation (Mac and Windows)

Run the following command within your `<Projects>` (shared boo2docker VM for multiple projects, recommended) or `<Project>` (dedicated boot2docker VM) directory:

    bash <(curl -s https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/master/setup.sh)

### Manual installation (Mac and Windows)

1. Copy `Vagrantfile` and `vagrant.yml` files from this repo into your `<Projects>` (shared boo2docker VM for multiple projects, recommended) or `<Project>` (dedicated boot2docker VM) directory.
2. Rename `vagrant.yml.dist` to `vagrant.yml`
3. Launch Terminal (Mac) or Babun (Windows)
4. cd to `</path/to/project>`, start the VM

    ```
    cd </path/to/project>
    vagrant up
    ```

5. Verify installation
    
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

In addition to the stock SMB synced folders option this box provides an experimental one: [SMB2](#synced-folders-smb2).  
With the **SMB2** option you will receive several "elevated command prompt" prompts which you accept.  
No need to enter usernames and passwords unlike the stock SMB option Vagrant ships with.

If you use rsync, you'll have to run `vagrant rsync-auto` in a separate terminal to keep the files in sync as you make changes.

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

<a name="synced-folders-smb2"></a>
**SMB2 (experimental option)**

This is an experimental option.  
Compared to **SMB**, **SMB2** does not require running vagrant as admin and does not prompt for username and password.  
You will receive several "elevated command prompt" prompts which you accept. 
Vagrant will automatically create a user, set correct file permissions, create the SMB share, and mount it.  

**Enabling rsync**

rsync is not natively available on Windows.  
Git for Windows comes with Git Bash shell, which is based on [MinGW/MSYS](http://www.mingw.org/wiki/msys).  
MSYS has a package for rsync, which can be installed and accessed via Git Bash.

To use rsync on Windows:

1. Download and extract the content on this [archive](https://drive.google.com/open?id=0B130F0xKxOWCTUN1d3djZGZ0M2M&authuser=0) into the `bin` directory of your Git installation (e.g. `c:\Program Files (x86)\Git\bin\`).
2. Choose `rsync` as the sync type in the `vagrant.yml` file.
3. Provide an explicit list of folders to sync in the `vagrant.yml` file (`folders` sequence).
4. Reload the VM: `vagrant reload`
5. Run `vagrant rsync-auto` to keep the files in sync as you make changes.

<a name="vm-settings"></a>
## VirtualBox VM settings

Open `vagrant.yml` file and edit respective values.

- `v.gui` - Set to `true` for debugging. This will unhide VM's primary console screen. Default: `false`.
- `v.memory` - Memory settings (MB). Default: `2048`.
- `v.cpus: 1`  - number of virtual CPU cores. Default: `1`.

Please note, VirtualBox works much better with a single CPU in most cases, this it is not recommended to change the `v.cpus` value.

<a name="vm-network"></a>
## Network settings

The default box private network IP is `192.168.10.10`.
To map additional IP addresses for use with multiple projects open `vagrant.yml` and ucomment respective lines:

```yaml
hosts:
    - ip: 192.168.10.11
    - ip: 192.168.10.12
    - ip: 192.168.10.13
```

Project specific `<IP>:<port>` mapping for containers is done in via docker-compose in `docker-compose.yml`

<a name="vhost-proxy"></a>
## vhost-proxy

As an alternative to using dedicated IPs for different projects a built-in vhost-proxy container can be used.  
It binds to `192.168.10.10:80` (the default box IP address) and routes web requests based on the `Host` header.

### How to use
- Set `vhost_proxy: true` in your vagrant.yml file and do a 'vagrant reload'
- Set the `VIRTUAL_HOST` environment variable for the web container in your setup (e.g. `VIRTUAL_HOST=example.com`)
- Add an entry in your hosts file (e.g. `/etc/hosts`) to point the domain to the default box IP (`192.168.10.10`)
  - As an alternative see [Wildcard DNS](#dns) instructions below
- Multiple domain names can be separated by comas: `VIRTUAL_HOST=example.com,www.example.com`

Example docker run

```
docker run --name nginx -d -e "VIRTUAL_HOST=example.com" nginx:latest
```

Example docker-compose.yml entry

```
# Web node
web:
  image: nginx:latest
  ports:
    - "80"
  environment:
    - VIRTUAL_HOST=example.com
```

Example hosts file entry

```
192.168.10.10  example.com
```

It is completely fine to use both the vhost-proxy approach and the dedicated IPs approach concurently:
 - `"80"` - expose port "80", docker will randomly pick an available port on the Docker Host
 - `"192.168.10.11:80:80"` - dedicated IP:port mapping

<a name="dns"></a>
## DNS and service discovery

### DNS resolution

The built-in `dns` container can be used to resolve all `*.drude` domain names to `192.168.10.10` (VM's primary IP address), where vhost-proxy listens on port 80.

**Mac**

```
sudo mkdir -p /etc/resolver
echo -e "\n# .drude domain resolution\nnameserver 192.168.10.10" | sudo tee -a  /etc/resolver/drude
```

**Windows**

On Windows add `192.168.10.10` as the primary DNS server and your LAN/ISP/Google DNS as secondary.


### Service discovery

The built-in `dns` container can also be used for local DNS based service discovery.  
You can define an arbitrary domain name via the `DOMAIN_NAME` environment variable for any container and it will be resolved to the internal IP address of that container.

**Example**

```
docker run --name nginx -d -e "DOMAIN_NAME=my-project.web.docker" nginx:latest
docker run busybox ping my-project.web.docker -c 1
```

```
PING my_project.web.docker (172.17.42.8): 56 data bytes
64 bytes from 172.17.42.8: seq=0 ttl=64 time=0.052 ms
...

```

Multiple domain names can be separated by comas: `DOMAIN_NAME=my-project.web.docker,www.my-project.web.docker`

## Tips

### Automate DOCKER_HOST variable export

This is only necessary for manual instllations. On Mac the [setup.sh](setup.sh) scripts takes care of this for you.

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

<a name="troubleshooting"></a>
## troubleshooting

See [Troubleshooting](docs/troubleshooting.md) section of the docs.

## License

The MIT License (MIT)

Copyright (c) 2015 BlinkReaction

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
