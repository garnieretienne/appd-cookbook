# Appd cookbook

# Requirements

# Usage

## Upload your ssh key on the server

```
SYSOPS_KEYS=/root/sysops PUB_KEY=$(cat ~/.ssh/id_rsa.pub) && vagrant ssh -c "sudo mkdir -p ${SYSOPS_KEYS}" && vagrant ssh -c "sudo bash -c 'echo \"${PUB_KEY}\" > ${SYSOPS_KEYS}/${USER}.pub'"
DEVOPS_KEYS=/root/devops PUB_KEY=$(cat ~/.ssh/id_rsa.pub) && vagrant ssh -c "sudo mkdir -p ${DEVOPS_KEYS}" && vagrant ssh -c "sudo bash -c 'echo \"${PUB_KEY}\" > ${DEVOPS_KEYS}/${USER}.pub'"
```

# Attributes

# Recipes

# Author

Author:: Etienne Garnier (<garnier.etienne@gmail.com>)
