# Inventory

**Inventory is the Ansible fundamentals concepts. Its essentials to list and manage servers, computer and other IT stuff that are managed by ansible automation scripts.**

Ansible inventories can be **static**, where host details are defined and stored in YAML or INI files, or **dynamic**, automatically adapting to changing environments by querying external data sources. This duality enables efficient management both in stable environments and in dynamic cloud contexts, where instances can be frequently created and destroyed.

## Static inventories

Static inventories are those most often on which many Ansible automations are based. They allow to define explicitly and immutable hosts and groups with which Ansible will interact. These inventories can be written in two main formats: INI and YAML, each with its advantages and specificities.

A basic Ansible inventory is a file in INI or YAML format. In its simplest form, the inventory file can list hosts under a defined group:

```ini
# INI Format
[web]
192.168.1.101
192.168.1.102
```

This structure already allows specific Ansible tasks to be run on the servers_web group. However, Ansible also allows you to define child groups and assign host or group variables to further customize configurations.

Ansible also allows you to define variables at the host or group level, which provides incredible flexibility to customize the behaviors of Ansible modules without having to write multiple tasks for each host. Variables can be defined directly in the inventory file or in separate files to organize the configuration.

```ini
# INI Format
[web]
web1 ansible_host=192.168.1.101 ansible_user=admin
web2 ansible_host=192.168.1.102 ansible_user=admin

[web:vars]
nginx_version=1.18.0
```

### INI Format

The INI format is the simplest and most direct to create an inventory. It is particularly appreciated for its readability and ease of writing. Here is an example of a static inventory in INI format:

```ini
[web]
web1.example.com ansible_user=admin
web2.example.com ansible_user=admin

[database]
db1.example.com ansible_user=dbadmin
db2.example.com ansible_user=dbadmin

[web:vars]
nginx_version=1.18.0
```

In this example, *web* and *database* are host groups. *web:vars* defines variables that are applied to all hosts in the *web* group.

### YAML Format

The YAML format, on the other hand, offers a richer structure and is often preferred for more complex inventories. YAML allows a more hierarchical representation and is particularly useful for defining nested structures and variables in a more visual way. Here is how the same inventory would be represented in YAML:

```yaml
all:
  children:
    web:
      hosts:
        web1.example.com:
          ansible_user: admin
        web2.example.com:
          ansible_user: admin
      vars:
        nginx_version: "1.18.0"
    database:
      hosts:
        db1.example.com:
          ansible_user: dbadmin
        db2.example.com:
          ansible_user: dbadmin
```

This format allows not only to define hosts and groups, but also to organize subgroups and assign variables to specific levels of the hierarchy.

### Format choice

The choice between INI and YAML depends on the complexity of the environment and personal preferences. The INI format, with its simplicity, is excellent for fast configurations and less complex inventories. The YAML format, on the other hand, is more suited to complex structures and offers better visibility for more elaborate configurations.

In both cases, static inventories are a powerful tool to explicitly define the desired state of the infrastructure targeted by Ansible automations. They form the basis on which tasks are executed, enabling accurate and predictable management of system configurations.

## Dynamic inventories

Unlike static inventories, dynamic inventories are not written manually, but are generated automatically by querying external data sources.

Dynamic inventories allow Ansible to automatically adapt to the infrastructure in real time, which is especially useful in cloud environments where instances can be created or deleted on the fly. Ansible uses scripts or plugins to query external services and build the inventory based on the information collected.

### Dynamic inventories pluging

Ansible supports a wide range of dynamic inventory plugins for different environments and platforms. These plugins allow you to query services such as AWS, Azure, Google Cloud, VMware, Docker and many others. Here is a non-exhaustive list of dynamic inventory plugins available in Ansible:

- AWS EC2 (aws_ec2): To query EC2 instances of Amazon Web Services.
- Azure RM (azure_rm): For Microsoft Azure resources.
- Google Cloud (gcp_compute): For Compute Engine instances of Google Cloud Platform.
- VMware (vmware_vm_inventory): For virtual machines managed by VMware vSphere.
- Docker (docker_container): For Docker containers.
- OpenStack (openstack): For resources in an OpenStack cloud.
- Digital Ocean (digital_ocean): For droplets on Digital Ocean.
- Linode (linode): For Linode instances.
- Oracle Cloud Infrastructure (oci): For resources in Oracle Cloud.
- Kubernetes (k8s): For pods and other resources in a Kubernetes cluster.

For use dynamic inventories, you have to configure Ansible with the plugin that match your environnment. Each plugin have their own configuration requirement, generally in the form of yaml file that specify data about the API to target, the authentication credential and many other relevant parameters. Each plugins have their own variable that sort host in groups.

```yaml
# plugin aws_ec2
plugin: aws_ec2
regions:
  - us-east-1
keyed_groups:
  # add hosts to tag_Name_value groups for each aws_ec2 host's tags.Name variable
  - key: tags.Name
    prefix: tag_Name_
    separator: ""
```

To list all available inventories plugins:

```bash
ansible-doc -t inventory -l

amazon.aws.aws_ec2                                      EC2 inventory source
amazon.aws.aws_rds                                      RDS instance inventory source
ansible.builtin.advanced_host_list                      Parses a 'host list' with ranges
ansible.builtin.auto                                    Loads and executes an inventory plugin specified in a YAML config
ansible.builtin.constructed                             Uses Jinja2 to construct vars and groups based on existing inventory
ansible.builtin.generator                               Uses Jinja2 to construct hosts and groups from patterns
ansible.builtin.host_list                               Parses a 'host list' string
ansible.builtin.ini                                     Uses an Ansible INI file as inventory source
ansible.builtin.script                                  Executes an inventory script that returns JSON
ansible.builtin.toml                                    Uses a specific TOML file as an inventory source
ansible.builtin.yaml                                    Uses a specific YAML file as an inventory source
awx.awx.controller                                      Ansible dynamic inventory plugin for the Automation Platform Controller
azure.azcollection.azure_rm                             Azure Resource Manager inventory plugin
cloudscale_ch.cloud.inventory                           cloudscale.ch inventory source
community.aws.aws_mq                                    MQ broker inventory source
community.digitalocean.digitalocean                     DigitalOcean Inventory Plugin
community.dns.hetzner_dns_records                       Create inventory from Hetzner DNS records
community.dns.hosttech_dns_records                      Create inventory from Hosttech DNS records
community.docker.docker_containers                      Ansible dynamic inventory plugin for Docker containers
community.docker.docker_machine                         Docker Machine inventory source
community.docker.docker_swarm                           Ansible dynamic inventory plugin for Docker swarm nodes
community.general.cobbler                               Cobbler inventory source
community.general.gitlab_runners                        Ansible dynamic inventory plugin for GitLab runners
community.general.icinga2                               Icinga2 inventory source
community.general.linode                                Ansible dynamic inventory plugin for Linode
community.general.lxd                                   Returns Ansible inventory from lxd host
community.general.nmap                                  Uses nmap to find hosts to target
community.general.online                                Scaleway (previously Online SAS or Online.net) inventory source
community.general.opennebula                            OpenNebula inventory source
community.general.proxmox                               Proxmox inventory source
community.general.scaleway                              Scaleway inventory source
community.general.stackpath_compute                     StackPath Edge Computing inventory source
community.general.virtualbox                            virtualbox inventory source
community.general.xen_orchestra                         Xen Orchestra inventory source
community.hrobot.robot                                  Hetzner Robot inventory source
community.libvirt.libvirt                               Libvirt inventory source
community.okd.openshift                                 OpenShift inventory source
community.vmware.vmware_host_inventory                  VMware ESXi hostsystem inventory source
community.vmware.vmware_vm_inventory                    VMware Guest inventory source
community.zabbix.zabbix_inventory                       Zabbix Inventory Plugin
dellemc.openmanage.ome_inventory                        Group inventory plugin on OpenManage Enterprise
google.cloud.gcp_compute                                Google Cloud Compute Engine inventory source
hetzner.hcloud.hcloud                                   Ansible dynamic inventory plugin for the Hetzner Cloud
infoblox.nios_modules.nios_inventory                    Infoblox inventory plugin
kubernetes.core.k8s                                     Kubernetes (K8s) inventory source
microsoft.ad.ldap                                       Inventory plugin for Active Directory
netbox.netbox.nb_inventory                              NetBox inventory source
ngine_io.cloudstack.instance                            Apache CloudStack instance inventory source
ngine_io.vultr.vultr                                    Vultr inventory source
openstack.cloud.openstack                               OpenStack inventory source
ovirt.ovirt.ovirt                                       oVirt inventory source
servicenow.servicenow.now                               ServiceNow Inventory Plugin
t_systems_mms.icinga_director.icinga_director_inventory Returns Ansible inventory from Icinga
telekom_mms.icinga_director.icinga_director_inventory   Returns Ansible inventory from Icinga
theforeman.foreman.foreman                              Foreman inventory source
vultr.cloud.vultr                                       Retrieves list of instances via Vultr v2 API
```

To get more details about a plugins:

```bash
ansible-doc -t inventory <plugin-name>
```

## Using inventories

Using Ansible inventories, whoever it's static or dynamic, require to understand how to call it when you run Ansible commands and how to enable dynamic inventories plugins.

### With Ansible cli tools

To run taks, playbooks or any other Ansible command on your hosts, you have to indicate to Ansible wich inventories to use. It can be done by using the option -i following the path to your inventory file.

Example:

```bash
ansible-playbook -i /path/to/inventory playbook.yml
```

In this example, the -i option allow to Ansible to kown which inventories to load during the running of the command.

### Specify the inventory in the Ansible configuration file

Its possible to specify a default inventory in the Ansible configuration file (ansible.cfg). By defining the inventory in this file, you don't have to specify the option -i each time you run an Ansible commnd.

```ini
[defaults]
inventory = /chemin/vers/inventaire.ini
```

This way is particulary usefull when you work with a set of host and that you want to avoid to specify the inventory at each command.

### Enabling dynamic inventory plugins

For dynamic inventories, the use of plugins requires an additional step of activation and configuration. Each dynamic inventory plugin has its own configuration requirements, which must be specified in the ansible ansible.cfg configuration file. Example for the libvirt plugin:

```ini
[defaults]
inventory=libvirt.yml
interpreter_python=auto_silent
[inventory]
enable_plugins = community.libvirt.libvirt, auto, host_list, yaml, ini, toml, script
```

You notice that this inventory plugin is not installed by default, so you must install the community.libvirt collection and the python library:

```bash
ansible-galaxy collection install community.libvirt # ansible plugins
pip install libvirt-python # depandancies
```

### Using the ansible-inventory command

The ansible-inventory command is one of the tools of the Ansible ecosystem, allowing users to work with Ansible inventories in an interactive way. It offers the possibility to view, Ansible inventories. Three of its most useful options are --list, --graph and --vars, each providing a different perspective on the structure and details of the inventory.

#### The option: --list

The --list option displays the entire inventory as a JSON. This is especially useful for seeing a complete representation of the inventory, including hosts, groups, and associated variables.

```bash
ansible-inventory -i path/to/inventory.ini --list
```

```json
{
    "_meta": {
        "hostvars": {
            "bastion": {
                "ansible_host": "192.168.1.102",
                "domainname": "robert.local"
            },
            "proxmox1": {
                "ansible_host": "192.168.1.71",
                "domainname": "robert.local"
            }
        }
    },
    "all": {
        "children": [
            "ungrouped",
            "bastions",
            "proxmoxs"
        ]
    },
    "bastions": {
        "hosts": [
            "bastion"
        ]
    },
    "proxmoxs": {
        "hosts": [
            "proxmox1"
        ]
    }
}
```

This command transforms the specified inventory into a structured JSON object, allowing an overview of configurations and facilitating integration with other tools that can handle the JSON format.

It is possible to request output in YAML format and not JSON with the -y option:

```bash
ansible-inventory --list -y
```

```yml
all:
  children:
    bastions:
      hosts:
        bastion:
          ansible_host: 192.168.1.102
          domainname: robert.local
    proxmoxs:
      hosts:
        proxmox1:
          ansible_host: 192.168.1.71
          domainname: robert.local
```

#### The option: --graph

The --graph option provides a visual representation of the hierarchy of groups in the inventory, displaying the relationship between groups and subgroups.

```bash

ansible-inventory --graph --vars
@all:
  |--@144f4357-30fe-4bf8-9484-6f3e6ff2312b:
  |  |--test-podman_db
  |  |  |--{ansible_connection = community.libvirt.libvirt_qemu}
  |  |  |--{ansible_libvirt_uri = qemu:///system}
  |--@b02ea6c4-8dfa-4fc6-8a38-735325ff9815:
  |  |--test-dyn_default
  |  |  |--{ansible_connection = community.libvirt.libvirt_qemu}
  |  |  |--{ansible_libvirt_uri = qemu:///system}
  |--@f2c2438a-3371-41ab-8afe-b8bb59374527:
  |  |--build-containers_builder
  |  |  |--{ansible_connection = community.libvirt.libvirt_qemu}
  |  |  |--{ansible_libvirt_uri = qemu:///system}
  |--@f845cd23-8848-4ce8-9666-d01d6abc0c41:
  |  |--staticip
  |  |  |--{ansible_connection = community.libvirt.libvirt_qemu}
  |  |  |--{ansible_libvirt_uri = qemu:///system}
  |--@ungrouped:
```

This command is especially useful for understanding how groups are organized and how they fit together, which can help debug automation policies.

#### The option: --vars

The --vars option is used to display all inventory variables for each host in the inventory. It can be combined with --graph or --list to include variables in the views.

```bash
ansible-inventory --list -y --vars

all:
  children:
    bastions:
      hosts:
        bastion:
          ansible_host: 192.168.1.102
          domainname: robert.local
    proxmoxs:
      hosts:
        proxmox1:
          ansible_host: 192.168.1.71
          domainname: robert.local
```

This option is also extremely useful for checking the values of variables applied to your hosts or groups, which is indispensable for debugging and validating Ansible configurations.

### Management of inventory variables

Managing variables in Ansible is essential to customize and adapt configurations to the specifics of each host or host group. Ansible offers remarkable flexibility through the use of host_vars and group_vars folders. These folders allow you to define variables specific to each host (host_vars) or host group (group_vars), making your playbooks cleaner and your variable management more organized.

#### Folder structure host_vars and group_vars

The host_vars and group_vars folders should be placed at the root next to your inventory file. Ansible automatically searches for these folders to load additional variables.

group_vars : Contains files named after each group defined in your inventory. The variables defined in these files will be applied to all members of the corresponding group.

host_vars : Contains files named after each host defined in your inventory. The variables defined in these files will be applied only to the specific host.

Exemple:

```plain
inventory.ini
group_vars/
    groupe1.yml
    groupe2.yml
host_vars/
    host1.example.com.yml
    host2.example.com.yml
```

#### Defining variable in group_vars and host_vars

Each file in group_vars or host_vars must be in YAML format and can contain any number of Ansible variables you want to apply.

- Example of group_vars/group1.yml:

  nginx_version: "1.18.0"
  php_version: "7.4"

- Example of host_vars/host1.example.com.yml:

  ansible_user: "use"
  ansible_ssh_private_key_file: "/path/to/private/key"

#### Ansible variable priority

Before starting the creation of variable, its important to know the Ansible variable priority apply each time you run Ansible commands.
From the lowest to the highest priority order:

- command line values (-u my_user)
- role defaults (role/defaults/main.yml)
- inventory file or script group vars
- inventory group_vars/all
- playbook group_vars/all
- inventory group_vars/*
- playbook group_vars/*
- inventory file or script host vars
- inventory host_vars/*
- playbook host_vars/*
- host facts / cached set_facts
- play vars
- play vars_prompt
- play vars_files
- role vars (role/vars/main.yml)
- block vars (only for tasks in bock)
- task vars (only for tasks)
- include_vars
- set_facts / registered vars
- role (et include_role) params
- include params
- extra vars (-e "user=my_user")

We can see tha variable pass trough the ansible-playbook option (-e) is the highest one.

Now imagine an infrastructure managed by tens playbook, with tens variable files, with tens hosts groups, ... There is a risk of quickly losing conyrol if you don't organize youself correctly.

#### Benefits of using host_vars and group_vars

- Modularity: Separates variable logic from task logic, making your playbooks more readable and easy to maintain.
- Organization: Allows a clear organization of variables by directly associating them with the hosts or groups concerned.
- Flexibility: Makes it easy to adjust configurations for specific hosts or groups without changing the playbooks or roles themselves.
- Security: Can be used to store host or group specific sensitive variables, especially when combined with Ansible Vault to encrypt sensitive data.

#### Best practices

- Clearly name your files in group_vars and host_vars to exactly match the names of your groups and hosts in the inventory, avoiding confusion.
- Use Ansible Vault to encrypt files with sensitive information in group_vars and host_vars to improve security.
- Limit the use of host-specific variables to cases where it is absolutely necessary, focusing on group variables for simpler, centralized management.

Variable management via host_vars and group_vars is a powerful method for customizing environments and configurations in Ansible, ensuring that each host or host group receives the settings required for its unique role within your infrastructure.

### Dynamic group management

Ansible offers the ability to dynamically create or modify host groups while a playbook is running, using the add_host and group_by modules. This feature is especially useful for organizing hosts into groups based on conditions or data retrieved during task execution.

#### Using the add_host module

The add_host module allows you to dynamically add hosts to the running inventory, with the ability to associate them to specific groups and define variables for those hosts.

```yaml
- name: Add dynamically host to the inventory
  ansible.builtin.add_host:
    name: "{{ new_host }}"
    groups: dynamic_group
    ansible_host: "{{ dynamic_ip }}"
    foo: vars
```

In this example, a new host is added to the inventory under the name {{ new_host }}, with the IP address defined by {{ dynamic_ip }}. The host is associated with the dynamic_group group and is assigned a variable.

#### Using the group_by module

The module group_by allows you to create new groups or modify existing group members based on a host’s variables or facts. This is an effective way to dynamically group hosts according to specific criteria discovered or defined during playbook execution.

Example of using de group_by:

```yaml
- name: Group host by OS
  ansible.builtin.group_by:
    key: os_{{ ansible_facts['os_family'] }}
```

This example creates groups based on the host operating system family (for example, os_RedHat, os_Debian etc.), using the facts collected by Ansible (ansible_facts['os_family']).

#### Combined scenario: add_host and group_by

You can combine add_host and group_by in a playbook to create highly customized groups based on dynamic conditions or data retrieved during execution.

```yaml
- name: Add dynamically grouped host
  hosts: localhost
  tasks:
    - name: Add dynamically a host
      add_host:
        name: "host{{ item }}"
        groups: "tmp_group"
        ansible_host: "192.168.1.{{ item }}"
      loop: "{{ range(1, 5) | list }}"

    - name: Group host by availability
      group_by:
        key: "davailability_{{ item.status }}"
      loop:
        - { name: "host1", status: "high" }
        - { name: "host2", status: "mid" }
        - { name: "host3", status: "low" }
        - { name: "host4", status: "high" }
```

In this scenario, hosts are first dynamically added to the inventory with add_host and associated with a temporary group. Then, the group_by module is used to reorganize them into groups based on their availability status.

The ability to dynamically create and manipulate host groups provides great flexibility in inventory management and configuration application, enabling Ansible to effectively adapt to complex and changing situations when automating tasks.

## More content

[Ansible inventory documentation](https://docs.ansible.com/ansible/latest/inventory_guide/index.html)