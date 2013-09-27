# Appd cookbook

# Requirements

# Usage

## Upload your ssh key on the server

```
vagrant ssh -c "sudo mkdir /root/admin_keys"
PUB_KEY=$(cat ~/.ssh/id_rsa.pub) &&  vagrant ssh -c "sudo bash -c 'echo \"${PUB_KEY}\" > /root/admin_keys/${USER}.pub'"
```

# Attributes

# Recipes

# Author

Author:: Etienne Garnier (<garnier.etienne@gmail.com>)
