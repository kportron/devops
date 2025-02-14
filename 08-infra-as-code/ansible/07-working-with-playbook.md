Vagrant Provisioning with Ansible

```yaml
- name: Create automation user
  user:
    name: tux
    state: present
    shell: /bin/bash
    password: "{{ 'Password1' | password_hash('sha512') }}"
    update_password: on_create
- name: allow ssh password authentication
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^PasswordAuthentication '
    insertafter: '#PasswordAuthentication'
    line: 'PasswordAuthentication yes'
  notify: restart_sshd

- name: escalation of tux
  copy:
    dest: /etc/sudoers.d/tux
    content: "tux ALL=(root) NOPASSWD: ALL"
```

In vagrant file:

```rb
rhel8.vm.provision "ansible", playbook: "deploy.yaml"
```

