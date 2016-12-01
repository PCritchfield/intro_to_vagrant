#!/usr/bin/env bash

apt-add-repository "deb http://download.virtualbox.org/virtualbox/debian precise contrib"
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
apt-get update
apt-get install -y virtualbox-5.0 \
                   dkms
wget https://releases.hashicorp.com/vagrant/1.9.0/vagrant_1.9.0_x86_64.deb
dpkg -i vagrant_1.9.0_x86_64.deb
