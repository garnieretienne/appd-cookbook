# Create the git user
user "deploy" do
  username "deploy"
  comment "GIT receive user"
  shell "/usr/bin/git-shell"
  home "/srv/git"
  supports manage_home: true
  action :create
end

# Create the ssh dir
directory "/srv/git/.ssh" do
  owner "deploy"
  group "deploy"
  mode 0775
  action :create
end
file "/srv/git/.ssh/authorized_keys" do
  owner "deploy"
  group "deploy"
  mode 0700
  action :create
end

# Create the git shell commands directory
directory "/srv/git/git-shell-commands" do
  owner "deploy"
  group "deploy"
  mode 0775
  action :create
end

# Script to create a new repository
template "/srv/git/git-shell-commands/create_repo" do
  owner "deploy"
  group "deploy"
  mode 0775
  action :create
end

# Build a repository template with hooks scrips
directory "/srv/git/appd-template" do
  owner "deploy"
  group "deploy"
  mode 0775
  action :create
end
directory "/srv/git/appd-template/hooks" do
  owner "deploy"
  group "deploy"
  mode 0775
  action :create
end

# Git pre-receive hook
template "/srv/git/appd-template/hooks/pre-receive" do
  owner "deploy"
  group "deploy"
  mode 0775
  action :create
end

