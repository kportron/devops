# Ansible playbook

Ansible Playbooks is the name given to Ansible configuration file taht are written in YAML ([syntax guide](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)) and are a way to define what Ansible should do. A playbook can contain one or more "plays," each of which is a set of tasks to be executed on a defined set of hosts. Playbooks are used to define state, configuration, orchestrate tasks, and automate processes.

Ansible playbooks allow you to describe the series of actions that must be executed in order to place the target in the desired state. If a script is functionally similar to a traditional program, the execution of a playbook is more like a state machine.

**A playbook must be idempotent. Running it on an already configured target will not cause any change to its state.**

## Playbook syntax

A playbook runs in order from top to bottom. Within each play, tasks also run in order from top to bottom. Playbooks with multiple ‘plays’ can orchestrate multi-machine deployments, running one play on your webservers, then another play on your database servers, then a third play on your network infrastructure, and so on. At a minimum, each play defines two things:

- the managed nodes to target, using a pattern

- at least one task to execute

There is a simple playbook to show the Ansible playbook syntaxes, that manage an use account on the target host:

```yaml
---
- name: "Ensure user account {{ username }} exists"
  hosts: all
  tasks:
    
    - name: "account {{ username }} exists"
      user:
        name: "{{ username }}"
        state: present
```

The first component to retain in this example is that Ansible enhance the YAML sytanx thanks to **variables**. It allow to Ansible to adpat **task** exectuion depending on target and settings.

By default Ansible will gather facts about target, its a whole of data and informations about target. This features can be costly by degrading performances (negligible). It can be disable with:

```yaml
---
- name: "Ensure user account {{ username }} exists"
  hosts: all
  gather_facts: false
  tasks:
```

More details about the playbook:

```yaml
# Yaml file start always with "---"
---
# Playbook names
- name: "Ensure user account {{ username }} exists"
# Hostname or groupname, "all" mean all hosts defined in the inventory
  hosts: all
# Remote user to use on the targeted host
  remote_user: root
# Tasks list
  tasks:

    # Tasks names
    - name: "account {{ username }} exists"
    # tasks modules and modules options
      ansible.builting.user:
        name: "{{ username }}"
        state: present
```

In this example we have a playbook with 2 play, and each play have two tasks, the first play targets the web servers, the second play targets the database servers.

```yaml
---
- name: Update web servers
  hosts: webservers
  remote_user: root # remote user account used for SSH connection

  tasks:
  - name: Ensure apache is at the latest version
    ansible.builtin.yum:
      name: httpd
      state: latest

  - name: Write the apache config file
    ansible.builtin.template:
      src: /srv/httpd.j2
      dest: /etc/httpd.conf

- name: Update db servers
  hosts: databases
  remote_user: pg_admin

  tasks:
  - name: Ensure postgresql is at the latest version
    ansible.builtin.yum:
      name: postgresql
      state: latest

  - name: Ensure that postgresql is started
    ansible.builtin.service:
      name: postgresql
      state: started
```

[List of all playbook keywords](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html#playbook-keywords), some option can be configured in the Ansible configuration file.

## Running playbooks

To run a playbook, use the ansible-playbook command:

```bash
ansible-playbook playbook.yml
```

## Helpfull Tools for writing playbook

### Check syntax

```bash
ansible-playbook --syntax-check playbook.yml # check only the playbook

ansible-lint verify-apache.yml # check playbook and roles (require the ansible-lint python package)
```

### Dry run / Check mode

```bash
ansible-playbook -C playbook.yml
```

### Increase log level

```bash
ansible-playbook -vvvv playbook.yml
```
