#!/usr/bin/env bash

# Declare ssh key
SSH_KEY_PRIVATE="-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAQEA37VnRGgJo9yZUqHWHoIOGEZzOlyBjMTesC5abz8Z7eLIwpgZ2tkK
GfNroVsNBpjRIOYh99QjJID8pz3Vgz6GOIbuYT5rCYGe2l+8MtavmmfnW63RpmMBQrx+wk
dayZBoKcac3rvW9vhg8RnZ5ZxzCK6nm0eqHRP9n8Rw/+vIxLtUd+3kSdZo8jY7hUqPpQqE
mVAsNX06/OMTbD0cw39p0AXdAxNI2qPW5YyiJ+UGn6XeGB9fJDKVH2SBGXb8GfgBCZnC7m
pWS+f/duxzLOBWNygsXw40Z716Zi+4DITZga5BQG5s5/Sqyl4FUtCMXq9rOBGkecJN0WMW
6vnTpbgFnwAAA8jMbVtvzG1bbwAAAAdzc2gtcnNhAAABAQDftWdEaAmj3JlSodYegg4YRn
M6XIGMxN6wLlpvPxnt4sjCmBna2QoZ82uhWw0GmNEg5iH31CMkgPynPdWDPoY4hu5hPmsJ
gZ7aX7wy1q+aZ+dbrdGmYwFCvH7CR1rJkGgpxpzeu9b2+GDxGdnlnHMIrqebR6odE/2fxH
D/68jEu1R37eRJ1mjyNjuFSo+lCoSZUCw1fTr84xNsPRzDf2nQBd0DE0jao9bljKIn5Qaf
pd4YH18kMpUfZIEZdvwZ+AEJmcLualZL5/927HMs4FY3KCxfDjRnvXpmL7gMhNmBrkFAbm
zn9KrKXgVS0Ixer2s4EaR5wk3RYxbq+dOluAWfAAAAAwEAAQAAAQBhDiHEYuKzzdRTLlVo
HQKic4Ywbsvh19PJWgLwOs80Du0Mx9KHyRwB0EME2SzYjNpGTLG2BLpObwuuPzxv2WOACM
JJPDxR/oN9uIU9BTlgYu3UL6BCcLeuTXstLKntwxH99eY/F/2WXoIoeA+591tNDAE5dCkQ
voiNlTt1PMV43AF07heDIkDC+7axTG4r8KCjRdrMtYgEelLazIci1hjUmEGQ5FXD/TcKlL
t2P62NmrKjZi83Wbhe1HfcQwH7JTW9SyfGuqggX/ttg/Aajy3rG3BrIbs+9GSrv2JJ3r4u
1pzUh4a+q9u1796ponSiBi9L/c9uRJxnekGuSMs20+bxAAAAgB6PVMFpfAyA52oNSTLrhb
HOnNBPK6XxFh1OIb+n1yY9e+3JdePIeUmSEY1iP8zKw7Kx6uPmrbpQx3inF3C8WdimPfoI
LVUEWqhXhDQVrjqq9OLvqNGqvQ2brkS3oRR00zlJh8nj/WdzM2d6QzrggalyBXAzlV50dv
WbOdooDRx6AAAAgQD2w8rm6rZELnrYxmMhPOJYszZDiy/RbuAV/791sSkiW3sZS/KmsoBO
66u8Yj1d2yjy3kR36mWY7bxFUX22jut2HFMLTYGILe7n2vwA4TeWrz/GN41hqAZZWO8raE
sW7v3U7zWt4xs32iepQFKd9uiGJGKTi8TEUbb4vme5Wq56qQAAAIEA6BS2rmF6RVQcGwXT
D5PO7CCHwJyvmWr8CUDiAfEhK3TtrUboPy+hRoWG18olfuOex3+uBgyjnbItI4cfLwhgsQ
stn6KLTcd3GYW99SQFzijBGj1YO0QJLGm+8SDvPJEdiDDzEI3Q60qmBGZAZepG7rWMzbU4
37nB/HpJJFFLMwcAAAAPa3BvcnRyb25AZmVkb3JhAQIDBA==
-----END OPENSSH PRIVATE KEY-----"

SSH_KEY_PUBLIC="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDftWdEaAmj3JlSodYegg4YRnM6XIGMxN6wLlpvPxnt4sjCmBna2QoZ82uhWw0GmNEg5iH31CMkgPynPdWDPoY4hu5hPmsJgZ7aX7wy1q+aZ+dbrdGmYwFCvH7CR1rJkGgpxpzeu9b2+GDxGdnlnHMIrqebR6odE/2fxHD/68jEu1R37eRJ1mjyNjuFSo+lCoSZUCw1fTr84xNsPRzDf2nQBd0DE0jao9bljKIn5Qafpd4YH18kMpUfZIEZdvwZ+AEJmcLualZL5/927HMs4FY3KCxfDjRnvXpmL7gMhNmBrkFAbmzn9KrKXgVS0Ixer2s4EaR5wk3RYxbq+dOluAWf ansible-controller"

# vagrant by default creates its own keypair for all the machines. Password based authentication will be disabled by default and enabling it so password based auth can be done.
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Supressing the banner message everytime you connect to the vagrant box.
touch /home/vagrant/.hushlogin

# Updating the hosts file for all the nodes with the IP given in vagrantfile
cat >> /etc/hosts <<EOF
# vagrant environment nodes
192.168.21.100  controller.local.lab
192.168.21.101  node1.local.lab
192.168.21.102  node2.local.lab
192.168.21.103  node3.local.lab
192.168.21.104  node4.local.lab
192.168.21.105  node5.local.lab
192.168.21.106  node6.local.lab
192.168.21.107  node7.local.lab
192.168.21.108  node8.local.lab
192.168.21.109  node9.local.lab
EOF

# Installing necessary packages 
sudo dnf update && sudo dnf -y install curl wget net-tools iputils-ping python3-pip sshpass

# Ansible controller setup
if [[ $(hostname) = "controller" ]]; then
sudo pip3 install --upgrade pip && sudo pip3 install ansible
cat >> /home/vagrant/.ssh/id_rsa <<EOF
$SSH_KEY_PRIVATE
EOF

cat >> /home/vagrant/.ssh/id_rsa.pub <<EOF
$SSH_KEY_PUBLIC
EOF
fi

# Node setup
if [[ ! $(hostname) = "controller" ]]; then
cat >> /home/vagrant/.ssh/authorized_keys <<EOF
$SSH_KEY_PUBLIC
EOF
fi