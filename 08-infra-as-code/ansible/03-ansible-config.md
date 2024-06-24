# Ansible config

There is 2 way to configure ansible:

- With a file named ansible.cfg
- Or via the CLI

Ansible configuration file can be placed in different place (precedence => from bottom to top ):

- Defined by ANSIBLE_CONFIG (ENV vars)
- Next to playbook
- ~/.ansible/ansible.cfg
- /etc/ansible/ansible.cfg

Example:

```conf
inventory       = /etc/ansible/hosts
forks           = 5
become_user     = root
ask_pass        = True
gathering       = implicit
gather_subset   = all
roles_path      = /etc/ansible/roles
log_path        = /var/log/ansible.log
vault_password_file = /path/to/vault_password_file
fact_caching_connection =/tmp
pipelining = False
```

docs: <https://docs.ansible.com/ansible/latest/reference_appendices/config.html>

## Ansible config command

```bash
ansible-config
# show the current conf file
ansible-config view
# list all vars and possible vars
ansible-config list 
# show all ansible used vars
ansible-config dump
# show all ansible used and changed vars
ansible-config dump --only-changed
```

## Tuning the ansible configuration file

- Set this to “False” if you want to avoid host key checking by the underlying tools Ansible uses to connect to the host

```conf
[defaults]
host_key_checking = False
```

- Pipelining, if supported by the connection plugin, reduces the number of network operations required to execute a module on the remote server, by executing many Ansible modules without actual file transfer.

```conf
[ssh_connection]
pipelining = True
```

- Path to Ansible inventory

```conf
[defaults]
inventory = /path/to/file
```

- Maximum number of forks Ansible will use to execute tasks on target hosts.

```conf
[defaults]
forks = 30
```

- The user your login/remote user ‘becomes’ when using privilege escalation, most systems will use ‘root’ when no user is specified.

```conf
[privilege_escalation]
become_user = remote_user
```

- This controls whether an Ansible playbook should prompt for a login password. If using SSH keys for authentication, you probably do not need to change this setting.

```conf
[defaults]
ask_pass = False
```

- This setting controls the default policy of fact gathering (facts discovered about remote systems). This option can be useful for those wishing to save fact gathering time. Both ‘smart’ and ‘explicit’ will use the cache plugin.

```conf
[defaults]
gathering = implicit
```

- Colon separated paths in which Ansible will search for Roles.

```conf
[defaults]
role_path = /path/to/roles_dir
```

- File to which Ansible will log on the controller. When empty logging is disabled.

```conf
[defaults]
log_path = /path/to/log_file
```

- The vault password file to use. Equivalent to –vault-password-file or –vault-id If executable, it will be run and the resulting stdout will be used as the password.

```conf
vault_password_file = /path/to/vault_password_file
```

- Defines connection or path information for the cache plugin

```conf
fact_caching_connection =/tmp
```

- Arguments to pass to all SSH CLI tools. Multiple sessions and more persistent connection- with preferred authentication

```conf
[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s PreferredAuthentications=publickey
```

## Understanding pipeling

without pipeling:

- creating python file
- creating directory
- send python file via sftp
- run python
- get result

with pipeling:

- generating python file
- send it to remote interpreter via stdin
- get stdout

## More gather facts options

- Enable/Disable gather facts in the playbook

```yaml
gather_facts: no
```

- fact caching with a file

```conf
fact_caching = jsonfile
fact_caching_timeout = 3600
fact_caching_connection = /tmp/mycachedir
```

- fact caching with redis

```conf
fact_caching = redis
fact_caching_timeout = 3600
fact_caching_connection = localhost:6379:0
```

## Ansible pull

- load ansible code on remote host
- cloud init > cron > ansible-pull
- localhost execution
- problem => get host informations
