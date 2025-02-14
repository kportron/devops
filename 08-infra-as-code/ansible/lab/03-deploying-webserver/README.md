# 03-deploying-webserver

This lab goal it's the deployement of a NGINX web server fully automated with Ansible.

## Deploy the lab

Start the vagrant instance

```bash
vagrant up
```

SSH into the ansible-control virtual machine

```bash
vagrant ssh ansible-control
```

Copy host file on ansible-control

```bash
sudo cp /vagrant/hosts /etc/hosts 
```
Install ansible

```bash
sudo apt install ansible
```

Create a SSH key and copy to all servers

>password: vagrant

```bash
ssh-keygen
ssh-copy-id localhost
ssh-copy-id web01
```

Create the Ansible Inventory file and provision it

```bash
echo "web01" >> inventory
```

Test
```bash
ansible all -m ping -i inventory
```

## Web Server installation

The first step is to ensure that the NGINX package is present, for that we will use the **ansible.builtin.package** module in a new playbook.

>*Its a best practice to use this module instead of dnf/yum or apt thanks to distro adaptability*

```yaml
---
- name: "Ensure Nginx is deployed"
  hosts: all
  tasks:

  - name: Ensure Nginx is installed
    ansible.builtin.package:
      name: nginx
      state: present
```

## Customize Web Server data

Now, let's see how to Customize the Web Server data.

Create a templates directory in your ansible environnment and copy the jinja2 html template in the templates directory

```bash
mkdir templates
cp -r /vagrant/templates/* ./templates/
```

And now add the taks that will copies these templates into nginx html directory

```yaml
- name: Ensure all pages are customized
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
  loop:
  - { src: templates/404.html.j2, dest: "{{ nginx.docroot }}/404.html" }
  - { src: templates/50x.html.j2, dest: "{{ nginx.docroot }}/50x.html" }
```
## Starting the service

Now we can start the service

## Adding a pre_tasks to ensure that all package are up to date

We will create a tasks in a
