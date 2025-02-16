#!/bin/bash
#secure-ssh.sh
#author natekreit
#creates a new ssh user using $1 parameter
#adds a public key from the local repo or curled from the remote repo
#removes roots ability to ssh in
echo "
#new user
if [ -z "$1" ]; then
  echo "Error: No username provided."
  echo "Usage: $0 <username>"
  exit 1
fi

USERNSME=$1

echo "Creating new user: $USERNAME"
useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME:password" | chpasswd
usermod -aG sudo "$USERNAME"


#adds pub key
sed -i '/^PasswordAuthentication /c\PasswordAuthentication no' /etc/ssh/sshd_config
sed -i '/^PubkeyAuthentication /c\PubkeyAuthentication yes' /etc/ssh/sshd_config

#Creates the user's .ssh directory for ssh keys
mkdir -p /home/"$USERNAME"/.ssh
chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh
chmod 700 /home/"$USERNAME"/.ssh

#Reload SSH service
systemctl reload sshd

#message that says script complete
echo "SSH security config complete."
echo "User '$USERNAME' has been created and configured for SSH access."

#no root ssh
sed -i '/^PermitRootLogin /c\PermitRootLogin no' /etc/ssh/sshd_config
