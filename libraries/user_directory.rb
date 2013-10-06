class UserDirectory

  def self.load(path, &block)
    users = {}
    if File.directory? path
      Dir.foreach path do |entry|
        if File.file? "#{path}/#{entry}" and entry =~ /.*\.pub/ then
          user        = entry.split(/(.*)\.pub/)[1].to_s
          key         = IO.read "#{path}/#{entry}"
          users[user] = key
        end
      end
    end
    return users
  end
end