# Working with playbooks

Playbooks record and execute Ansible’s configuration, deployment, and orchestration functions. They can describe a policy you want your remote systems to enforce, or a set of steps in a general IT process.

If Ansible modules are the tools in your workshop, playbooks are your instruction manuals, and your inventory of hosts is your raw material.

At a basic level, playbooks can be used to manage configurations of and deployments to remote machines. At a more advanced level, they can sequence multi-tier rollouts involving rolling updates and can delegate actions to other hosts, interacting with monitoring servers and load balancers along the way.

Playbooks are designed to be human-readable and are developed in a basic text language. There are multiple ways to organize playbooks and the files they include, and we’ll offer up some suggestions on that and making the most out of Ansible.

## Templating with Jinja2

- Ansible use Jinja2 to enable dynamic expressions and access to variables and facts
- Use it with the module [**ansible.builtin.template**](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
- Used for templating configuration file based on target environment

### Example 

In this example we have a playbook `hostname.yml` that contain a tasks to copy the template `test.j2` on all target. This template contain the vars `{{ ansible_facts['hostname'] }}` an ansible fact that contain the target hostname.

Ansible environement dir:

```plain
├── hostname.yml
├── templates
    └── test.j2
```

hostname.yml file: 

```yml
---
- name: Write hostname
  hosts: host1
  tasks:
  - name: write hostname using jinja2
    ansible.builtin.template:
       src: templates/test.j2
       dest: /tmp/hostname
```

test.j2 file:

```jinja
My name is {{ ansible_facts['hostname'] }}
```

hostname file sample:

```plain
My name is host1
```

###  Ansible jinja special vars

Ansible have special vars that can be used in jinja file:

- ``{{ ansible_managed }}`` is a String to advice that the file is managed by ansible
- ``{{ template_host }}`` contains Ansible controller hostname
- ``{{ template_uid }}`` is the user id of the owner
- ``{{ template_path}}`` is the path of the template
- ``{{ template_fullpath }}`` is the absolute path of the template
- ``{{ template_run_date }}`` is the date taht the template wad rendererd

### Jinja2 syntax

Check out this [link](https://jinja.palletsprojects.com/en/3.1.x/) to learn more about Jinja2 syntax

## Test

Test in Jinja are a way of evaluating expressions and returning True or False.

### Testing syntax

The syntax for using a jinja test is as folows:

```yaml
variable is test_name # if variable == test_name
```

Or with a tasks resukt

```yaml
result is failed # if result == failed
```

### Testing strings

To match strings against a substring or a regular expression, use the match, search or regex tests:

```yaml
vars:
  url: "https://example.com/users/foo/resources/bar"

tasks:
    - debug:
        msg: "matched pattern 1"
      when: url is match("https://example.com/users/.*/resources")

    - debug:
        msg: "matched pattern 2"
      when: url is search("users/.*/resources/.*")

    - debug:
        msg: "matched pattern 3"
      when: url is regex("example\.com/\w+/foo")
```

### Testing task results

```yaml
tasks:

  - shell: /usr/bin/foo
    register: result # register the result in a vars named result
    ignore_errors: True  # tasks dont stop playbook even if tasks failed

  - debug:
      msg: "it failed"
    when: result is failed

  - debug:
      msg: "it changed"
    when: result is changed

  - debug:
      msg: "it succeeded in Ansible >= 2.1"
    when: result is succeeded

  - debug:
      msg: "it succeeded"
    when: result is success

  - debug:
      msg: "it was skipped"
    when: result is skipped
```

### Testing paths

```yaml
- debug:
    msg: "path is a directory"
  when: mypath is directory

- debug:
    msg: "path is a file"
  when: mypath is file

- debug:
    msg: "path is a symlink"
  when: mypath is link

- debug:
    msg: "path already exists"
  when: mypath is exists

- debug:
    msg: "path is {{ (mypath is abs)|ternary('absolute','relative')}}"

- debug:
    msg: "path is the same file as path2"
  when: mypath is same_file(path2)

- debug:
    msg: "path is a mount"
  when: mypath is mount

- debug:
    msg: "path is a directory"
  when: mypath is directory
  vars:
     mypath: /my/path

- debug:
    msg: "path is a file"
  when: "'/my/path' is file"
```

### Testing if a list contains a value

```yaml
vars:
  lacp_groups:
    - master: lacp0
      network: 10.65.100.0/24
      gateway: 10.65.100.1
      dns4:
        - 10.65.100.10
        - 10.65.100.11
      interfaces:
        - em1
        - em2

    - master: lacp1
      network: 10.65.120.0/24
      gateway: 10.65.120.1
      dns4:
        - 10.65.100.10
        - 10.65.100.11
      interfaces:
          - em3
          - em4

tasks:
  - debug:
      msg: "{{ (lacp_groups|selectattr('interfaces', 'contains', 'em1')|first).master }}"
```

### Testing if a list value is True

```yaml
vars:
  mylist:
      - 1
      - "{{ 3 == 3 }}"
      - True
  myotherlist:
      - False
      - True
tasks:

  - debug:
      msg: "all are true!"
    when: mylist is all

  - debug:
      msg: "at least one is true"
    when: myotherlist is any
```

## Lookup

Lookup plugins retrieve data from outside sources such as files, databases, key/value stores, APIs, variable environment, and other services

```yaml
vars:
  motd_value: "{{ lookup('file', '/etc/motd') }}"
tasks:
  - debug:
      msg: "motd value is {{ motd_value }}"
```

You can list all lookups plugins with the ansible-doc command
```bash
ansible-doc -l -t lookup
```

## Loops

Ansible offers the `loop`, `with_<lookup>` and `until` keywords to execute a task multiple times.

### Using loops

```yaml
- name: Add several users
  ansible.builtin.user:
    name: "{{ item }}"
    state: present
    groups: "wheel"
  loop:
     - testuser1
     - testuser2
```

You can also loop a vars:

```yaml
loop: "{{ somelist }}"
```


## Conditionals

## Blocks

## Handlers

## Error handling

## Remote env

## Role

## Re-using ansible artifact

## Module defaults

## Interactive inputs

## Using Vars

## Facts and magic vars

## Using filter

With Ansible you can use using filter to manipulate some kind of data.

### Handling undefined variables

#### Providing default values

You can provide default values for variables directly in your templates using the Jinja2 ‘default’ filter. This is often a better approach than failing if a variable is not defined:

```yaml
{{ some_vars | default(5) }}
```

#### Making variables optional

By default, Ansible requires values for all variables in a templated expression. However, you can make specific module variables optional. For example, you might want to use a system default for some items and control the value for others. To make a module variable optional, set the default value to the special variable `omit`:

```yaml
- name: Touch files with an optional mode
  ansible.builtin.file:
    dest: "{{ item.path }}"
    state: touch
    mode: "{{ item.mode | default(omit) }}"
  loop:
    - path: /tmp/foo
    - path: /tmp/bar
    - path: /tmp/baz
      mode: "0444"
```

### Managing data types

#### Discovering the data type

```yaml
{{ myvar | type_debug }}
```

#### Transforming dictionaries into lists

```yaml
{{ dict | dict2items }}
```

#### Transforming lists into dictionaries

```yaml
{{ tags | items2dict }}
```

### Formatting data: YAML and JSON

Convert

```yaml
{{ some_variable | to_json }}
{{ some_variable | to_yaml }}
```

Convert in human readable

```yaml
{{ some_variable | to_nice_json }}
{{ some_variable | to_nice_yaml }}
```

Extract data 

```yaml
{{ some_variable | from_json }}
{{ some_variable | from_yaml }}
```
