# Synced Folders

This box supports all [Synced Folder](http://docs.vagrantup.com/v2/synced-folders/) options provided by Vagrant
as well two custom optimized options :
- vboxsf - native VirtualBox method, cross-platform, convenient and reliable, terribly slow
- nfs: better performance and convenience on Mac
- nfs2: optimized nfs settings, experimental (default on Mac)
- smb: better performance and convenience on Windows. Requires Vagrant to be run with admin privileges (not recommended).
- smb2: does not require running vagrant as admin (default on Windows).
- rsync: best performance, cross-platform platform, one-way only
  
Follow the instructions in the `vagrant.yml` file to switch between different sync options.
The best balance between performance and convenience can be achieved with **nfs2** on Mac (default) and **smb2** on Windows (default).

If you use rsync on Windows, you'll have to run `vagrant gatling-rsync-auto` in a separate terminal to keep the files in sync as you make changes.  
This is automated on Mac with `rsync_auto` set to `true` in `vagrant.yml`.

<a name="mac"></a>
## Mac

Option comparison for Mac Drupal developers (using `time drush si -y` as a test case):
- vboxsf: 6x (slowest)
- nfs: 1.3x
- rsync: 1x (fastest)

NFS provides good performance and convenience (used by default on Mac)

<a name="win"></a>
## Windows

Option comparison for Windows Drupal developers (using `time drush si -y` as a test case):
- vboxsf: 5x (slowest)
- smb: 2x
- rsync: 1x (fastest)

**smb** provides good performance and convenience (used by default on Windows)

**smb vs smb2**

Compared to **smb**, **smb2** does not require running vagrant as admin and does not prompt for username and password.  
You will receive several "elevated command prompt" prompts which you accept. 
Vagrant will automatically create a user, set correct file permissions, create the SMB share, and mount it.  
