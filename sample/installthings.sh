#!/usr/bin/env bash
apt-get update
apt-get install -y htop \
                   apache2 \
		   python-pip \
		   python-dev \
		   build-essential

#if ! [ -L /var/www ]; then
#  rm -rf /var/www
#  ln -fs /vagrant /var/www
#fi
