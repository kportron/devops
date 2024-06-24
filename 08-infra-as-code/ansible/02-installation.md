# Installation

There is multiple way to install Ansible (distro package, python librairies, binaries, container).

## How to install Ansible

### Via binaries

```bash
git clone https://github.com/ansible/ansible.git
cd ansible
source ./hacking/env-setup
sudo apt install python-pip
pip install --user -r ./requirements.txt
echo "127.0.0.1" > ~/ansible_hosts
export ANSIBLE_INVENTORY=~/ansible_hosts
ansible all -m ping --ask-pass
```

### Via pip

```bash
sudo apt install python3-pip
pip3 install ansible
```

### Via distro package manager

#### Debian based

```bash
sudo apt install ansible
```

#### RHEL based

```bash
sudo dnf install ansible
```

## Setting up the SSH keybased authentication

### Generate SSH key pair

```bash
ssh-keygen -t encryption_algorithm -b bits -f keyfile -C comment 
ssh-keygen -t rsa -b 2048 -C "A basic ssh key"
ssh-keygen -t ed25519-sk -b 2048 -f my_key -C "The most secure ssh key"
```

### Adding the key to the remote host

- You can basicly copy and paste it like this

```bash
vim /home/remote_user/.ssh/authorized_keys
# Copy the content of my_key.pub
```

- Alternatively you can copy it with ssh

```bash
ssh-copy-id -i /home/local_user/.ssh/my_key.pub remote_user@remote_host
# The password of remote_user is asked to etablish the ssh connection
```

- Test the good working

```bash
ssh -i /home/local_user/.ssh/my_key.pub remote_user@remote_host
```

If its doesn't work you need to configure the ssh client and the ssh server.

#### ssh client

```bash
touch ~/.ssh/config
chmod 600 ~/.ssh/config
cat ~/.ssh/config

Host remote_host
    User remote_user
    Port 22
    IdentitiesOnly
    IdentityFile /home/local_user/.ssh/my_key.pub
    PasswordAuthentication no
    PubkeyAuthentication yes
    LogLevel INFO
    Compression yes
    ForwardAgent yes
    ForwardX11 yes
```

#### ssh server

```bash
cat /etc/ssh/sshd_config
PasswordAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
```

- Tips for bypassing the ssh client configuration

```bash
ssh -F /dev/null remote_user@remote_host
```
