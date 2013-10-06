# Tell sudo cookbook to include the "sudoers.d" configuration folder
node.default[:authorization][:sudo][:include_sudoers_d] = true

# Install and configure sudo
include_recipe "sudo"

# Create the 'sysop' group
group "sysop" do
  system true
end

# Ensure 'sysop' group members can execute 
# commands as root with no password
sudo 'sysop' do
  group 'sysop'
  nopasswd true
end

# For each users registered in the sysops keys folder
UserDirectory.load(node[:appd][:sysops_keys]).each do |user, key|

  # Create the user
  user "#{user}" do
    username user
    gid "sysop"
    comment "Sysop user"
    shell "/bin/bash"
    home "/home/#{user}"
    supports manage_home: true
  end
 
  # Create the user '.ssh' folder
  directory "/home/#{user}/.ssh" do
    user user
    group "sysop"
    mode 0700
  end

  # Allow the user to connect using its ssh key     
  execute "register '#{user}' key" do
    command "echo '#{key}' >> /home/#{user}/.ssh/authorized_keys"
    not_if "grep '#{key}' /home/#{user}/.ssh/authorized_keys"
  end
end