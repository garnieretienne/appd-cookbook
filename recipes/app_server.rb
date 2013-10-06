# Manage sysops user creation
include_recipe "appd::_sysops"

# Install git
include_recipe "git"

# Create the Appd user
user node[:appd][:user] do
  username node[:appd][:user]
  comment "Appd git user"
  shell "/usr/bin/git-shell"
  home node[:appd][:home]
  supports manage_home: true
end

# Create the '.ssh' dir for the Appd user
directory "#{node[:appd][:home]}/.ssh" do
  owner node[:appd][:user]
  group node[:appd][:user]
  mode 0775
end

# Allow all devops users to connect to Appd user account
UserDirectory.load(node[:appd][:devops_keys]).each do |user, key|
  execute "allow '#{user}' to deploy applications" do
    command "echo '#{key}' >> #{node[:appd][:home]}/.ssh/authorized_keys"
    not_if "grep '#{key}' #{node[:appd][:home]}/.ssh/authorized_keys"
    action :run
  end
end

# Build a repository template for hooks scrips
directory "#{node[:appd][:home]}/#{node[:appd][:git_template]}" do
  owner node[:appd][:user]
  group node[:appd][:user]
  mode 0775
end

# Build the repository template 'hooks' dir
directory "#{node[:appd][:home]}/#{node[:appd][:git_template]}/hooks" do
  owner node[:appd][:user]
  group node[:appd][:user]
  mode 0775
end

# Build the 'pre-receive' hook
template "#{node[:appd][:home]}/#{node[:appd][:git_template]}/hooks/pre-receive" do
  owner node[:appd][:user]
  group node[:appd][:user]
  mode 0775
end

# Build the Appd shell commands directory
directory "#{node[:appd][:home]}/git-shell-commands" do
  owner node[:appd][:user]
  group node[:appd][:user]
  mode 0775
end

# Build each command scripts
['help', 'create', 'build', 'release', 'run', 'route'].each do |command|
  template "#{node[:appd][:home]}/git-shell-commands/#{command}" do
    owner node[:appd][:user]
    group node[:appd][:user]
    mode 0775
  end
end

# Allow the Appd user to reload nginx configuration
sudo node[:appd][:user] do
  user node[:appd][:user]
  commands ["/usr/sbin/nginx -s reload"]
  nopasswd true
end

# Add the Docker repository by Dotcloud
apt_repository "docker" do
  key "https://get.docker.io/gpg"
  uri "http://get.docker.io/ubuntu"
  distribution 'docker'
  components ['main']
end

# Ensure the kernel support AUFS
# See: http://docs.docker.io/en/latest/installation/ubuntulinux/
# bash "update the linux kernel to support aufs" do
#   code <<-EOF
#     if apt-cache search linux-image-extra-`uname -r` | grep linux-image-extra-`uname -r` &> /dev/null; then
#       apt-get install --assume-yes linux-image-extra-`uname -r`
#     elif apt-cache search linux-image-generic-lts-raring | grep linux-image-generic-lts-raring &> /dev/null; then
#       apt-get install --assume-yes linux-image-generic-lts-raring linux-headers-generic-lts-raring
#     fi
#   EOF
#   not_if "lsmod | grep aufs"
# end

# Install docker
package "lxc-docker"

# Ensure the 'docker' service run at boot and 
# is monitored by 'upstart'
service "docker" do
  provider Chef::Provider::Service::Upstart  
  supports status: true, restart: true, reload: true
  action :enable
end

# Add sysops users and the appd user to the 'docker' group 
# so they can use it without sudo
group "docker" do
  members UserDirectory.load(node[:appd][:sysops_keys]).keys << node[:appd][:user]
  append true
  action :manage
end

# Setup the Nginx stable repo
include_recipe "nginx::repo"

# Tell nginx cookbook to not enable the default site
node.default[:nginx][:default_site_enabled] = false

# Install and configure nginx
include_recipe "nginx"

# Build the directory containing routes for Appd applications
directory node[:appd][:routes] do
  owner node[:appd][:user]
  group node[:appd][:user]
  mode 0775
end

# Enable the route directory in nginx
template "/etc/nginx/conf.d/appd.conf" do
  owner node[:appd][:user]
  group node[:appd][:user]
  mode 0775
end

# Clone the buildstep project
git node[:appd][:buildstep][:dir] do
  repository node[:appd][:buildstep][:repo]
  action :sync
end

# Ensure curl is installed on the host
package 'curl'

# Download the buildstep base container 'progrium/buildstep'
execute 'download the buildstep base container "progrium/buildstep"' do
  command "curl #{node.default[:appd][:buildstep][:base_container]} | gunzip -cd | docker import - progrium/buildstep"
  cwd "/tmp"
  action :run
  not_if "docker images | grep 'progrium/buildstep'"
end