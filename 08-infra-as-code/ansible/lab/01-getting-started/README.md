# 01-getting-started

## Getting started with Ansible fundamentals and basics concepts



### Environement

| VM     | IP            |
|--------|---------------|
| alma8  | 192.168.33.11 |
| centos | 192.168.33.12 |
| ubunu  | 192.168.33.13 |

### Requirements

- Vagrant >= 1.9
- A Vagrant provier (such as VirtualBox, VMWare Workstation, libvirt, ...)

### Set up the lab

```bash
vagrant up
```

### Installing Ansible

- debian based distro with apt

``` bash
vagrant ssh ubuntu

sudo apt update
sudo apt -y upgrade
sudo apt install -y build-essential libssl-dev libffi-dev python3-dev 
sudo apt install ansible
```

- rhel based distro with pip

``` bash
vagrant ssh centos

sudo dnf install python3-pip
sudo pip3 install -U pip --upgrade
pip3 install ansible --user
```

- rhel based distro with dnf

``` bash
vagrant ssh alma8

sudo dnf update
sudo dnf install ansible
```

### Get the Ansible version

``` bash
ansible --version
```

### Testing Ansible

``` bash
ansible all -i "localhost," -c local -m shell -a 'echo Hello World'
```

### Ansible Ad-Hoc Commands

Running quick and easy commands from the command line using the ansible command gives a quick start to Ansible.

On alma8 try these following lines and read the ansible manual:

```bash
ansible all -i "localhost," -c local -m ping
         |          |            |       |
         |          |            |       |---- Ansible module to use
         |          |            |        
         |          |            |---- Connection type    
         |          |
         |          |---- Inventory               
         |                      
         |---- Host-pattern  



ansible all -i "localhost," -b -c local -m package -a 'name=zsh state=absent'
                             |                      |
                             |                      |---- Module option
                             |        
                             |---- Become root                 
```

### Ansible playbook

On alma8 create a file *playbook.yml* with this content:

``` yaml
---
- name: Simple Play
  hosts: localhost
  connection: local
  tasks:
    - name: Ping me
      ping:
```

This playbook have a description (name: Simple Play), an host to target (hosts: localhost) and some tasks.

Then run it with:

```bash
ansible-playbook -i "localhost," playbook.yml 
```

### Ansible facts

By default each time you run a playbook Ansible retreive data of targeted host, you can disable it by adding:

```yaml
- hosts: whatever
  gather_facts: false
```

To see the ‘raw’ information as gathered, run this command at the command line:

```bash
ansible localhost -m setup
```

On each VM run this Ad-Hoc comands:

```bash
ansible localhost -m setup -a "filter=ansible_os_family"
```

Return a specific fact in a playbook:

```yaml
---
- name: Simple Play
  hosts: localhost
  connection: local
  tasks:
    - name: Ping me
      ping:
    - name: Print os
      debug:
        msg: "My OS is {{ ansible_os_family }}" # This is a jinja variable
```

### Ansible configuration

By default when you run Ad-Hoc command or playbook without specify an inventory file, Ansible will search in different place an inventory file with the following hierarchy:

- In the environnment variable **ANSIBLE_CONFIG**
- **$CWD/ansible.cfg**
- **$HOME/.ansible.cfg**
- **/etc/ansible/ansible.cfg**

On alma8 create a file *$HOME/.ansible.cfg* with this content:

```ini
[defaults]
# Inventory file to use
inventory = inventory
# Remote user to use
remote_user = vagrant

[privilege_escalation]
# Run playbook on target with sudo right 
become = True
```

```bash
ansible-config dump --only-changed

# Now you can do sudo action without specify option
ansible localhost -m package -a "name=zsh"
```

You can initate a complete ansible configuration file with:

```bash
ansible-config init --disabled > ansible.cfg
```

### Ansible inventory

When you run some Ad-Hoc command whith no host specified, only localhost will be affected because its an implicit host.

Get ansible inventory list

```bash
ansible-inventory --list
```

Create the inventory file **$HOME/inventory** with the following content:

```ini
192.168.33.11
192.168.33.12
192.168.33.13
```

Then do:

 ```bash
ansible-inventory --graph

ansible --list ungrouped

ansible --list Redhat
 ```

You can see that host are in an ungrouped group. Modify **$HOME/inventory** and redo the previous command:

```ini
[alma]
192.168.33.11
[stream]
192.168.33.12
[ubuntu]
192.168.33.13
[Redhat:children] #group with group
stream
alma
```

Ansible allow you to implement inventory Variables. First create a directory **host_vars** and add in this directory a file named **192.168.33.11** with this content (you have to named the file by the host name tha you to add a vars):

```ini
ansible_connection: local
```

Then run:

```bash
ansible-inventory --host 192.168.33.11

ansible 192.168.33.11 -m ping
```

You can do the same for groups in a directory named **group_vars**.

Remember that ansible will always read the inventory that is specified in the ansible.cfg file. You can also write inventory file in ini, yaml or json.

### Completing The Environment

First generate ssh key on alma8 that will be our Ansible Controller:

```bash
vagrant ssh alma8
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
```

And copy it on each managed node:

```bash
ssh-copy-id vagrant@192.168.33.12
ssh-copy-id vagrant@192.168.33.13
```

> password: vagrant

Now test the good implementation of the ssh pubkey on managed node:

```bash
ansible all -m ping
```

Create a new playbook and run it:

```yaml
---
- name: Simple Play 2
  hosts: all
  tasks:
    - name: Ping me
      ping:
    - name: Print os
      debug:
        msg: "My distribution is {{ ansible_distribution }}" # This is a jinja variable
```

So in this way we understood that ansible use the pubkey authenication mecanism to manage node, the prerequisite tasks its to generate ssh key first and then send the pubkey for the remote user.

### Main Ansible commands

``` bash
# Execute simple ansible module (Ad-Hoc Commands) on an inventory
ansible

# Interactive console
ansible-console

# Get ansible configuration
ansible-config [list|dump|view]

# Run an ansible playbook on an inventory
ansible-playbook

# Encrypt data to use with ansible
ansible-vault

# Get information about the inventory
ansible-inventory

# Install Ansible roles and collections 
ansible-galaxy

# Ansible doc about module
ansible-doc
```

### Clean up the lab

```bash
vagrant destroy -f
```
