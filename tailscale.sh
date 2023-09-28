#!/bin/sh

if [ ! -e "/etc/apt/apt.conf.d/99no-recommends" ]
then
  echo 'APT::Install-Recommends \"false\";' | sudo tee /etc/apt/apt.conf.d/99no-recommends
fi

if [ ! -x "/usr/bin/tailscale" ]
then
  sudo apt-get update
  sudo apt-get install -y ca-certificates
  curl -fsSL https://tailscale.com/install.sh | sh
  sudo tailscale up
fi

mkdir -pm 700 ~/.ssh
curl https://github.com/chrismarget-j.keys >> ~/.ssh/authorized_keys
curl https://github.com/bwjuniper.keys >> ~/.ssh/authorized_keys
uniq ~/.ssh/authorized_keys > ~/.ssh/authorized_keys.uniq
mv ~/.ssh/authorized_keys.uniq ~/.ssh/authorized_keys
