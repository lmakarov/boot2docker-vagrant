# Tips

## Automate DOCKER_HOST variable export

This is only necessary for manual instllations. [setup.sh](../scripts/setup.sh) script takes care of this for you.

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

## Vagrant control
Vagrant can be controlled (e.g. `vagrant up`, `vagrant ssh`, `vagrant reload`, etc.) from the root directory of the Vagrantfile as well as from any subdirectory. This is very usefull when working with multiple projects in subdirectories.

## Sublime Text 3 users
Add this to your user settings (Sublime Text > Preferences > Settings - User):

    {
        "atomic_save": false
    }

ST3 does not update the ctime extended file attribute when saving a file. This leads to NFS not seeing the changes in a file unless the file size changes as well (i.e. changing a single symbol in a file with ST3 will not be visible over NFS). The setting above fixes that.
