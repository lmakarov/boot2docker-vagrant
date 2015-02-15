VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.6.3"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "boot2docker"

  config.vm.box = "yungsang/boot2docker"
  config.vm.box_check_update = false

  config.vm.network "private_network", ip: "192.168.33.10"

  # Mount current dir under same path in VM
  config.vm.synced_folder ".", Dir.pwd, type: "nfs", mount_options: ["nolock", "vers=3", "udp"]

  # Uncomment below to use more than one instance at once
  #config.vm.network :forwarded_port, guest: 2375, host: 2375, auto_correct: true
  
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
  # ToDo: For this to work need to use `vagrant reload --provision` whenever restarting the VM.
  config.vm.provision :shell do |s|
    s.inline = <<-EOT
      echo 'alias fig='"'"'docker run --rm -it -v $(pwd):$(pwd) -v /var/run/docker.sock:/var/run/docker.sock -e FIG_PROJECT_NAME=$(basename $(pwd)) -w="$(pwd)" dduportal/fig'"'" >> /home/docker/.ashrc
    EOT
  end

end
