# Ansible adhoc

An Ansible ad hoc command uses the **ansible** commande-line tool to automate a signe task on one or more managed nodes. 

- less used than ansible-playbook

- quick and easy²

- usefull to test connectivity and inventory

## Connection testing

```bash
ansible -i "node2," all -u vagrant -m ping
```

## adhoc syntax

- -u: remote user to use
- -b: execute with root privilege
- -k: ssh password
- -D: get a diff output
- -C: Dry run (test mode)
- -e: define vars
- --key-file: ssh key file to use
- --ask-vault-pass: password to decrpyt vaulted vars
- --vault-password-file: file to decrypt vaulted vars
- -f: forks
- -vvv: verbose

``` bash
ansible all -i "localhost," -c local -m shell -a 'echo Hello World'
```

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

- define ssh parameters

```bash
ansible -i "node2," all -u vagrant -k --ssh-extra-args="-o 'PreferredAuthentications=password'" -m ping
```

- oneline display

```bash
ansible -i "node2," all -u vagrant -m ping --one-line
```

## one line module

- use the ansible command module

```bash
ansible -i "node2," all -u vagrant -m command -a uptime
```

- pass an ansible vars

```bash
ansible -i "node2," all -b -e "var1=xavki" -m debug -a 'msg={{ var1 }}'
```

- use the ansible shell module

```bash
ansible -i "node2," all -u vagrant -m shell -a "ps aux | grep vagrant | wc -l" --one-line
```

- use the ansible raw module (without python)

```bash
sudo apt autoremove --purge git
ansible -i "node2," all -u vagrant -b -K -m raw -a "apt install -y git"
```

- use the ansible apt module

```bash
ansible -i "node2," all -b -m apt -a 'name=nginx state=latest'
```

- stop a service

```bash
ansible -i "node2," all -b -m service -a 'name=nginx state=stopped'
```

- use the ansible copy module

```bash
ansible -i "node2," all -m copy -a 'src=toto.txt dest=/tmp/titi.txt'
```

- fetching a file

```bash
ansible -i "node2," all -m fetch -a 'src=/tmp/titi.txt dest=xavki.txt flat=yes'
```

- get facts about host

```bash
ansible -i "node2," all -m setup -a "filter=ansible_distribution*"
```

## More content

[Ansible adhoc documentation](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html)
