<a name="vm-settings"></a>
# VirtualBox VM settings

Open `vagrant.yml` file and edit respective values.

- `v.gui` - Set to `true` for debugging. This will unhide VM's primary console screen. Default: `false`.
- `v.memory` - Memory settings (MB). Default: `2048`.
- `v.cpus: 1`  - number of virtual CPU cores. Default: `1`.

Please note, VirtualBox works much better with a single CPU in most cases, this it is not recommended to change the `v.cpus` value.
