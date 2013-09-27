# Manage admin users creation
#
# All admin usesr have a public key stored in the admin keys folder.
# Ex: 'kurt' user will have its public key in '/root/admin_keys/kurt.pub'
admin_keys = "/root/admin_keys"
if File.directory? admin_keys then
  Dir.foreach admin_keys do |entry|
    if File.file? "#{admin_keys}/#{entry}" and entry =~ /.*\.pub/ then
      user_name = entry.split(/(.*)\.pub/)[1]
      key = "#{admin_keys}/#{entry}"

      # Create the user and give him admin rights
      user "#{user_name}" do
        username user_name
        comment "sysop user"
        shell "/bin/bash"
        home "/home/#{user_name}"
        supports :manage_home => true
        action :create
        notifies :run, "execute[register '#{user_name}' key]"
        notifies :run, "execute[ask '#{user_name}' to change its password on first login]"
      end
      group "sysop" do
      	members user_name
        system true
        append true
        action :create
      end
 
      # Allow user to connect using its public key
      directory "/home/#{user_name}/.ssh" do
        user user_name
        group user_name
        mode 0700
        action :create
      end
      file "/home/#{user_name}/.ssh/authorized_keys" do
        owner user_name
        group user_name
        mode 0700
        action :create
      end
      execute "register '#{user_name}' key" do
        command "cat #{key} >> /home/#{user_name}/.ssh/authorized_keys"
        action :nothing
      end

      # Ask the user to update its password on its next connection
      execute "ask '#{user_name}' to change its password on first login" do
        command "echo #{user_name}:#{user_name} | chpasswd && chage -d 0 #{user_name}"
        action :nothing
      end
    end
  end
end

# Ensure sysop users can execute command as root
sudo 'sysop' do
  group 'sysop'
  nopasswd true
end