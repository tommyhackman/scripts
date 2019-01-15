#!/usr/bin/env bash
set -e
user=$1
sudo adduser ${user}
sudo mkdir /home/${user}/.ssh
sudo cp .ssh/authorized_keys /home/${user}/.ssh/
sudo cp .bash_profile /home/${user}/
sudo chmod 700 /home/${user}/.ssh
sudo chmod 600 /home/${user}/.ssh/authorized_keys /home/${user}/profile
sudo chown ${user} /home/${user}/.ssh/authorized_keys /home/${user}/.ssh /home/${user}/profile
sudo chgrp ${user} /home/${user}/.ssh/authorized_keys /home/${user}/.ssh /home/${user}/profile