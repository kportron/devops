# Ansible

## What is Ansible ?

Ansible is an open-source tool for configuration management, automation, and orchestration primarily used in the field of system administration and the management of IT infrastructures. It allows system administrators and developers to define, configure, and manage computer systems in a reproducible, efficient, and secure manner.

## Understanding Ansible basics

Ansible automates the management of remote systems and controls their desired state. A basic Ansible environment has three main components:

### Control node

- The control node is the system or server where you install and run Ansible.
- It's the machine from which you manage and orchestrate the automation tasks.
- The control node hosts the Ansible framework and your playbooks.
- You use the command-line tools or an automation script on the control node to execute Ansible playbooks against the managed nodes.
- The control node typically requires Python to be installed (Python 2.7 or Python 3.5+), as Ansible relies on Python to run its tasks.

### Managed node

- A managed node is the target system or server that Ansible interacts with and manages.
- These are the remote hosts where you want to configure, install software, or perform other tasks.
- Managed nodes don't need to have Ansible installed or any specific prerequisites. Ansible connects to them over SSH (or other supported connection methods) and remotely executes tasks on these nodes.
- You define the managed nodes in Ansible's inventory, specifying their hostnames or IP addresses, and grouping them as needed.

### Inventory

An inventory in Ansible is a list of hosts that Ansible can manage. These hosts can be specified by their IP addresses or hostnames, organized into groups, and variables can be assigned to them. The inventory is a key part of defining where Ansible should run tasks.

Ansible concept with a schema:

```jsx
                             +-----------------------+
                             |                       |
                             |    Ansible Control    |
                             |  Node (Control Node)  |
                             |                       |
                             +-----------------------+
                             |                       |
                             |    Ansible Playbooks  |
                             |    and Inventory      |
                             |                       |
                             +-----------------------+
                                          |
                                          | SSH (Port 22)
                                          |
                                          v
                   +------------+   +------------+   +------------+
                   |            |   |            |   |            |
                   |  Managed   |   |  Managed   |   |  Managed   |
                   |   Node 1   |   |   Node 2   |   |   Node 3   |
                   |            |   |            |   |            |
                   +------------+   +------------+   +------------+
```

Other Ansible fundamentals:

- **Playbook**: Playbooks are written in YAML and are a way to define what Ansible should do. A playbook can contain one or more "plays," each of which is a set of tasks to be executed on a defined set of hosts. Playbooks are used to define configuration, orchestrate tasks, and automate processes.

- **Task**: A task is a single unit of work in Ansible, and it's defined in a playbook. Tasks describe a set of actions that should be performed on a target host, like installing a package, copying a file, or restarting a service.

- **Module**: Ansible uses modules to execute tasks on remote hosts. Modules are small programs that Ansible uses to perform specific tasks. For example, the "yum" module is used to manage packages on a Red Hat-based system, and the "apt" module is used for Debian-based systems.

- **Role**: A role is a reusable and self-contained collection of tasks, variables, and templates that can be used in multiple playbooks. Roles help organize and share common configuration and automation across different projects.

- **Play**: A play is a set of tasks to be executed on a defined set of hosts. A playbook can contain multiple plays, allowing you to group related tasks together and specify different sets of hosts for each play.

- **Ad-Hoc Commands**: Ansible allows you to run single tasks or ad-hoc commands without creating a playbook. This is useful for quick, one-off tasks like checking the status of services or running commands on remote hosts.

- **SSH Connectivity**: Ansible uses SSH (Secure Shell) to connect to remote hosts. It doesn't require agents to be installed on the target systems, making it agentless.

- **Idempotence**: Ansible is designed to be idempotent, which means that running the same task multiple times will have the same result as running it once. This is important for ensuring consistency and predictability in system configurations.

- **Templates**: Ansible can use Jinja2 templates to dynamically generate configuration files based on variables. This is useful for customizing configuration files with host-specific information.

- **Fact Gathering**: Ansible can gather facts about remote hosts, such as hardware details, operating system information, and network configuration. These facts can be used in playbooks to make tasks more adaptable.
