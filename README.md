# Appd cookbook

# Requirements

# Usage

## Upload your ssh key on the server

```
PUB_KEY=$(cat ~/.ssh/id_rsa.pub) && vagrant ssh -c "sudo mkdir -p /root/admin_keys" &&  vagrant ssh -c "sudo bash -c 'echo \"${PUB_KEY}\" > /root/admin_keys/${USER}.pub'"
```

# Attributes

# Recipes

# Author

Author:: Etienne Garnier (<garnier.etienne@gmail.com>)
