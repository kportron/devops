# Command module

creates: "/var/file" => Dont retrigger tasks if the file created exist.


### Command vs shell modules

- **Command**: The Ansible command module allows execution of the native Linux commands without the need of creating a parent shell. This does not allow access to variables and stream operators

- **Shell**: The Ansible shell module opens the shell .bin.sh to execute the commands. This allows access to variables and stream operators but is considered less secure.

Use **command** over **shell**. The command module is considered more securea as it can prevent injection of commands via variables and strategically place semi-colons.

## Raw module

Used to install Python before configure the system.

```yaml
- name: Bootsrap a host without Python installed
  ansible.builtin.raw: dnf install -y python3
```

Or using Ansible Ad-Hoc

```bash
ansible all -i 192.168.10.1 -b -m raw -a "yum install -y python3"
```