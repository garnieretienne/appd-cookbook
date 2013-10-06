# Ensure vagrant keep its sudo permissions
sudo 'vagrant' do
  user 'vagrant'
  nopasswd true
end