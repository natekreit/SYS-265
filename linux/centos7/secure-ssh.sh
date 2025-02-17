#!/bin/bash
#secure-ssh.sh
#author natekreit
#creates a new ssh user using $1 parameter
#adds a public key from the local repo or curled from the remote repo
#removes roots ability to ssh in

#new user
if [ -z "$1" ]; then
  echo "Error: No username provided."
  echo "Usage: $0 <username>"
  exit 1
fi

USERNSME=$1

echo "Creating new user: $USERNAME"
useradd -m -s /bin/bash "$USERNAME"

passwd -l "$USERNAME"


#no root ssh
sed -i '/^PermitRootLogin /c\PermitRootLogin no' /etc/ssh/sshd_config

#adds pub key
sed -i '/^PasswordAuthentication /c\PasswordAuthentication no' /etc/ssh/sshd_config
sed -i '/^PubkeyAuthentication /c\PubkeyAuthentication yes' /etc/ssh/sshd_config

#Creates the user's .ssh directory for ssh keys
mkdir -p /home/"$USERNAME"/.ssh
chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh
chmod 700 /home/"$USERNAME"/.ssh

scp web01:/home/web01/.ssh/id_rsa.pub /home/"$USERNAME"/.ssh/authorized_keys


#Reload SSH service
systemctl reload sshd

#message that says script complete
echo "SSH security config complete."
echo "User '$USERNAME' has been created and configured for SSH access."
