VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.6.3"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "boot2docker"

  config.vm.box = "yungsang/boot2docker"
  config.vm.box_check_update = false

  # Map several IP addresses to use with multiple projects
  # Project specific IP:port mapping for containers is done in fig (fig.yml)
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "private_network", ip: "192.168.33.11"
  config.vm.network "private_network", ip: "192.168.33.12"

  # Uncomment below to use more than one instance at once
  #config.vm.network :forwarded_port, guest: 2375, host: 2375, auto_correct: true

  # Synced folder setup
  if Vagrant::Util::Platform.windows?
    # Default/Windows mount (vboxfs)
    config.vm.synced_folder ".", "/vagrant"
    # Uncomment for better performance on Windows (mount via SMB).
    # Requires Vagrant to be run with admin privileges.
    # Will also prompt for the Windows username and password to access the share.
    #config.vm.synced_folder ".", "/vagrant", type: "smb"
  else
    # Mount Vagrantfile directory (<Project_XYZ> or a shared <Projects> folder) under the same path in the VM.
    # Required for fig client to work from the host.
    # NFS mount works much-much faster on OSX compared to the default vboxfs.
    vagrant_root = File.dirname(__FILE__)
    config.vm.synced_folder vagrant_root, vagrant_root, type: "nfs", mount_options: ["nolock", "vers=3", "udp"]
    # This uses uid and gid of the user that started vagrant.
    # config.nfs.map_uid = Process.uid
    # config.nfs.map_gid = Process.gid
  end
  
  config.vm.provider :virtualbox do |v|
    v.cpus = 1  # VirtualBox works much better with a single CPU.
    v.memory = 2048
  end

  # Fix busybox/udhcpc issue
  config.vm.provision :shell do |s|
    s.inline = <<-EOT
      if ! grep -qs ^nameserver /etc/resolv.conf; then
        sudo /sbin/udhcpc
      fi
      cat /etc/resolv.conf
    EOT
  end

  # Adjust datetime after suspend and resume
  config.vm.provision :shell do |s|
    s.inline = <<-EOT
      sudo /usr/local/bin/ntpclient -s -h pool.ntp.org
      date
    EOT
  end

  # Make fig available inside boot2docker via a fig container.
  # https://registry.hub.docker.com/u/dduportal/fig/
  config.vm.provision "shell", run: "always" do |s|
    s.inline = <<-SCRIPT
      echo 'alias fig='"'"'docker run --rm -it -v $(pwd):$(pwd) -v /var/run/docker.sock:/var/run/docker.sock -e FIG_PROJECT_NAME=$(basename $(pwd)) -w="$(pwd)" dduportal/fig'"'" >> /home/docker/.ashrc
    SCRIPT
  end

end
