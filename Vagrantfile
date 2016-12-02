# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rbconfig'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

######################################################################
# Constants for scripting

UNIX_HOME = '/home/vagrant'
SRC = File.expand_path(File.join(File.dirname(__FILE__), 'shared/dotfiles'))
DOTFILES = Dir[File.join(SRC, '.??*')].delete_if{|f| File.extname(f) =~ /\.sw?/ }

######################################################################
# Helper functions

def windows_host?
  host_os = RbConfig::CONFIG['host_os']
  host_os =~ /mswin32/i || host_os =~ /mingw32/i
end

def sync_projects_directory(cfg)
  uppercase_p_projects = File.join(Dir.home, 'Projects')
  lowercase_p_projects = File.join(Dir.home, 'projects')
  all_user_projects = File.join(Dir.home, '**/[Pp]rojects')

  user_projects_found = Dir.glob(all_user_projects)
  projects_directory = lowercase_p_projects if user_projects_found.include?(lowercase_p_projects)
  projects_directory = uppercase_p_projects if user_projects_found.include?(uppercase_p_projects)

  if (projects_directory.nil?)
    root_projects = Dir.glob(File.join('/', '/[Pp]rojects'))
    projects_directory = root_projects[0] unless root_projects.empty?
  end

  if (projects_directory.nil?)
    projs_dir = Dir.glob("c:/**/[Pp]rojects")
    projs_dir = projs_dir.delete_if { |item| (item.include? "Microsoft")}
    projs_dir = projs_dir.delete_if { |item| (item.include? "Visual Studio")}
    projects_directory = projs_dir[0] unless projs_dir.empty?
  end

  if (projects_directory.nil?)
    puts ("Projects directory does not exist. No projects directory will be synced")
  else
    cfg.vm.synced_folder projects_directory, "#{UNIX_HOME}/projects"
    cfg.vm.provision :shell, :privileged => false, :inline => 'ln -s ${HOME}/projects ${HOME}/Projects'
  end
end

def copy_ssh_keys(config, home = UNIX_HOME)
  #
  # add all public keys from ~/.ssh into authorized_keys
  # append, because the vagrant key is already there
  #
  Dir.glob(File.join(Dir.home,'.ssh','*.pub')).each do |public_key|
    private_key = public_key.gsub(".pub","")
    if windows_host?
      # on windows we can't rely on ssh agent forwarding so
      # we'll put (private) key(s) on the vm.
      {private_key => '600', public_key => '644'}.each do |file, mode|
        dest = File.join(home, '.ssh', File.basename(file))
        config.vm.provision :file, source: file, destination: dest
        config.vm.provision :shell, inline: "chmod #{mode} #{dest}"
      end
    end
    config.vm.provision :shell, :privileged => false, :inline => 'ssh-keyscan github.com 10.10.1.81 >> ~/.ssh/known_hosts'
    public_key_value = File.new(public_key).read
    authorized_keys_file = File.join(home,'.ssh','authorized_keys')
    config.vm.provision :shell, inline: "echo '\n#{public_key_value}' >> '#{authorized_keys_file}'"
  end
end

def copy_dotfiles(cfg)
  DOTFILES.each do |file|
    cfg.vm.provision :file do |f|
      f.source = file
      f.destination = File.join(UNIX_HOME, File.basename(file))
    end
  end
end

######################################################################
# Vagrant configuration

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.ssh.forward_agent = true unless windows_host?

  ####################################################################
  #
  # Ubuntu Base Server - 12.04
  #
  ####################################################################

  config.vm.define 'precise', autostart: false do |cfg|

    cfg.vm.box = 'ubuntu/precise64'

    cfg.vm.provider 'virtualbox' do |v|
      v.name = 'Base Ubuntu 12.04'
      v.memory = 2048
      v.cpus = 2
    end

    sync_projects_directory cfg

    cfg.vm.provision :shell, :path => "scripts/install_vagrant.sh"

    copy_dotfiles(cfg)
    copy_ssh_keys(cfg)
  end

  ####################################################################
  #
  #  Ubuntu Base Server - 14.04
  #
  ####################################################################

  config.vm.define 'trusty', autostart: false do |cfg|

    cfg.vm.box = 'ubuntu/trusty64'

    cfg.vm.provider 'virtualbox' do |v|
      v.name = 'trusty'
      v.memory = 4096
      v.cpus = 4
      end

    sync_projects_directory cfg
    
    cfg.vm.provision :shell, :path => "scripts/install_vagrant.sh"
    
    copy_dotfiles(cfg)
    copy_ssh_keys(cfg)
  end

end
