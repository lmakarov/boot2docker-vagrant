# UI Object for console interactions.
@ui = Vagrant::UI::Colored.new

# Determine paths
vagrant_root = File.dirname(__FILE__)  # Vagrantfile location
vagrant_mount_point = vagrant_root.gsub(/[a-zA-Z]:/, '')  # Trim Windows drive letters
vagrant_folder_name = File.basename(vagrant_root)  # Folder name only. Used as the SMB share name 

# Use vagrant.yml for local VM configuration overrides.
require 'yaml'
if !File.exist?(vagrant_root + '/vagrant.yml')
  @ui.error 'Configuration file not found! Please copy vagrant.yml.dist to vagrant.yml and try again.'
end
vconfig = YAML::load_file(vagrant_root + '/vagrant.yml')

# Determine if we are on Windows host or not
is_windows = Vagrant::Util::Platform.windows?
if is_windows
  require 'win32ole'
  # Determine if Vagrant was launched from the elevated command prompt
  running_as_admin = ((`reg query HKU\\S-1-5-19 2>&1` =~ /ERROR/).nil? && is_windows)

  # Method to create a network share on Windows using elevated command prompt
  def windows_net_share(share, path)
    command = 'cmd.exe'
    args = "/C net share #{share}=#{path} /grant:everyone,FULL || timeout 5"
    @ui.info args
    shell = WIN32OLE.new('Shell.Application')
    shell.ShellExecute(command, args, nil, 'runas')
  end
else
  # Determine if Vagrant was launched with sudo (as root).
  running_as_root = (Process.uid == 0)
end

# Vagrant should NOT be run as root/admin.
if running_as_root
# || running_as_admin
  raise "Vagrant should be run as a regular user to avoid issues."
end

######################################################################

# Vagrant Box Configuration #
Vagrant.require_version ">= 1.6.3"

Vagrant.configure("2") do |config|
  config.vm.define "boot2docker"

  config.vm.box = "dduportal/boot2docker"
  config.vm.box_check_update = false

  ## Network ##

  # The default box private network IP is 192.168.10.10
  # Configure additional IP addresses in vagrant.yml
  vconfig['hosts'].each do |host|
    config.vm.network "private_network", ip: host['ip']
  end unless vconfig['hosts'].nil?

 ####################################################################
 ## Synced folders configuration ##

  synced_folders = vconfig['synced_folders']
  # nfs: better performance on Mac
  if synced_folders['type'] == "nfs"  && !is_windows
    config.vm.synced_folder vagrant_root, vagrant_mount_point,
      type: "nfs",
      mount_options: ["nolock", "vers=3", "tcp"]
    config.nfs.map_uid = Process.uid
    config.nfs.map_gid = Process.gid
  # smb: better performance on Windows. Requires Vagrant to be run with admin privileges.
  elsif synced_folders['type'] == "smb" && is_windows
    config.vm.synced_folder vagrant_root, vagrant_mount_point,
      type: "smb",
      smb_username: synced_folders['smb_username'],
      smb_password: synced_folders['smb_password']
  # smb2: experimental, does not require running vagrant as admin, requires initial manual setup.
  elsif synced_folders['type'] == "smb2" && is_windows
    # Create the share on the Windows host
    #windows_net_share vagrant_share, vagrant_root
    #Mount the share in boot2docker
    config.vm.provision "shell", run: "always" do |s|
      s.inline = <<-SCRIPT
        mkdir -p vagrant $2
        mount -t cifs -o uid=`id -u docker`,gid=`id -g docker`,sec=ntlm,username=$3,pass=$4 //192.168.10.1/$1 $2
      SCRIPT
      s.args = "#{vagrant_folder_name} #{vagrant_mount_point} #{vconfig['synced_folders']['smb_username']} #{vconfig['synced_folders']['smb_password']}"
    end  
  # rsync: the best performance, cross-platform platform, one-way only. Run `vagrant rsync-auto` to start auto sync.
  elsif synced_folders['type'] == "rsync"
    # Only sync explicitly listed folders.
    if (synced_folders['folders']).nil?
      @ui.warn "WARNING: 'folders' list cannot be empty when using 'rsync' sync type. Please check your vagrant.yml file."
    else
      for synced_folder in synced_folders['folders'] do
        config.vm.synced_folder "#{vagrant_root}/#{synced_folder}", "#{vagrant_mount_point}/#{synced_folder}",
          type: "rsync",
          rsync__exclude: ".git/",
          rsync__args: ["--verbose", "--archive", "--delete", "-z", "--chmod=ugo=rwX"]
      end
    end
  # vboxfs: reliable, cross-platform and terribly slow performance
  else
    @ui.warn "WARNING: defaulting to the slowest folder sync option (vboxfs)"
      config.vm.synced_folder vagrant_root, vagrant_mount_point
  end

  # Make host SSH keys available to containers on /.ssh
  if File.directory?(File.expand_path("~/.ssh"))
    config.vm.synced_folder "~/.ssh", "/.ssh"
  end

  ######################################################################

  ## VirtualBox VM settings
  
  config.vm.provider "virtualbox" do |v|
    v.gui = vconfig['v.gui']  # Set to true for debugging. Will unhide VM's primary console screen.
    v.name = vagrant_folder_name + "_boot2docker"  # VirtualBox VM name
    v.cpus = vconfig['v.cpus']  # CPU settings. VirtualBox works much better with a single CPU.
    v.memory = vconfig['v.memory']  # Memory settings.
  end

  ## Provisioning scripts ##

  # Allow Mac OS X docker client to connect to Docker without TLS auth
  # https://github.com/deis/deis/issues/2230#issuecomment-72701992
  config.vm.provision "shell" do |s|
    s.inline = <<-SCRIPT
      echo 'DOCKER_TLS=no' >> /var/lib/boot2docker/profile
      /etc/init.d/docker restart
    SCRIPT
  end

  # Make docker-compose available inside boot2docker via a container.
  # https://github.com/docker/compose/issues/598#issuecomment-67762456
  config.vm.provision "shell", run: "always" do |s|
    s.inline = <<-SCRIPT
      echo 'docker run --rm -it \
          -v $(pwd):$(pwd) -v /var/run/docker.sock:/var/run/docker.sock \
          -e COMPOSE_PROJECT_NAME=$(basename $(pwd)) -w="$(pwd)" \
          blinkreaction/docker-compose $*' > /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
      echo 'alias fig=docker-compose' >> /home/docker/.ashrc
    SCRIPT
  end

  # Pass vagrant_root variable to the VM and cd into the directory upon login.
  config.vm.provision "shell", run: "always" do |s|
    s.inline = <<-SCRIPT
      echo "export VAGRANT_ROOT=$1" >> /home/docker/.profile
      echo "cd $1" >> /home/docker/.ashrc
    SCRIPT
    s.args = "#{vagrant_mount_point}"
  end
  
  # dsh script lookup wrapper (Drude Shell)
  # https://github.com/blinkreaction/drude
  config.vm.provision "shell", run: "always" do |s|
    s.inline = <<-SCRIPT
      DSH_SCRIPT='
      #/bin/sh

      up="../"
      pathup="./"
      slashes=$(pwd | sed "s/[^\/]//g")
      found=1
      for i in $(seq 0 ${#slashes}) ; do 
        if [ -d "${pathup}.docker" ] ; then
          found=0
          break
        else
          pathup=$pathup$up
        fi
      done

      if [ $found -eq 0 ]; then
        ${pathup}.docker/bin/dsh $*
      else
        echo "error: drude bin utils (.docker/bin) directory was not found"
      fi
      '
      echo "$DSH_SCRIPT" > /usr/local/bin/dsh
      chmod +x /usr/local/bin/dsh
    SCRIPT
  end

end
