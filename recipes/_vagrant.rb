# Ensure vagrant keep its sudo perms
sudo 'vagrant' do
  user 'vagrant'
  nopasswd true
end