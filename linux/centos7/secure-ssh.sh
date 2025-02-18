#!/bin/bash
#secure-ssh.sh
#author natekreit
#creates a new ssh user using $1 parameter
#adds a public key from the local repo or curled from the remote repo
#removes roots ability to ssh in

#new user
sudo useradd -m -d /home/${1} -s /bin/bash ${1}
sudo mkdir /home/${1}/.ssh
cd /root
sudo cp SYS-265/linux/public-keys/id_rsa.pub /home/${1}/.ssh/authorized_keys
sudo chmod 700 /home/${1}/.ssh
sudo chmod 600 /home/${1}/.ssh/authorized_keys
sudo chown -R ${1}:${1} /home/${1}/.ssh

if grep -q "PermitRootLogin" /etc/ssh/sshd_config; then
   sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
else
   echo "PermitRootLogin not found in /etc/ssh/sshd_config"
fi


#Reload SSH service
sudo systemctl restart sshd.service
