# Add deployment rights to devops users
admin_keys = "/root/admin_keys"

if File.directory? admin_keys then
  Dir.foreach admin_keys do |entry|

    if File.file? "#{admin_keys}/#{entry}" and entry =~ /.*\.pub/ then
      user_name = entry.split(/(.*)\.pub/)[1]
      key = "#{admin_keys}/#{entry}"

      # Allow the user to use the git server
      execute "allow '#{user_name}' to deploy applications" do
        command "cat #{key} >> /srv/git/.ssh/authorized_keys"
        not_if "grep \"$(cat #{key})\" /srv/git/.ssh/authorized_keys"
        action :run
      end
    end
  end
end