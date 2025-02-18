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

USERNAME=$1

if ! getent passwd "$USERNAME" > /dev/null 2>&1; then
    echo "User '$USERNAME' does not exist. Proceeding with user creation..."
    useradd -m -d /home/$USERNAME -s /bin/bash $USERNAME
    mkdir /home/$USERNAME/.ssh
    cp SYS-265/linux/public-keys/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
    chmod 700 /home/$USERNAME/.ssh
    chmod 600 /home/$USERNAME/.ssh/authorized_keys
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
    echo "User '$USERNAME' has been created with passwordless SSH access."
    exit 1
fi


passwd -l "$USERNAME"


#no root ssh
sed -i '/^PermitRootLogin /c\PermitRootLogin no' /etc/ssh/sshd_config

#adds pub key
sed -i '/^PasswordAuthentication /c\PasswordAuthentication no' /etc/ssh/sshd_config
sed -i '/^PubkeyAuthentication /c\PubkeyAuthentication yes' /etc/ssh/sshd_config



scp web01:/home/web01/.ssh/id_rsa.pub /home/"$USERNAME"/.ssh/authorized_keys


#Reload SSH service
systemctl reload sshd

#message that says script complete
echo "SSH security config complete."
echo "User '$USERNAME' has been created and configured for SSH access."
