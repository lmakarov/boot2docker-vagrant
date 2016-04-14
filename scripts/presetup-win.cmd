REM Installing Chocolatey
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

REM Installing virtualbox
choco upgrade virtualbox -y

REM Killing the default adapter and DHCP server to avoid network issues down the road
"C:\Program Files\Oracle\VirtualBox\VBoxManage" dhcpserver remove --netname "HostInterfaceNetworking-VirtualBox Host-Only Ethernet Adapter"
"C:\Program Files\Oracle\VirtualBox\VBoxManage" hostonlyif remove "VirtualBox Host-Only Ethernet Adapter"

REM Installing vagrant
choco upgrade vagrant -y
