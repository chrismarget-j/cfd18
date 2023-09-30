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
for user in chrismarget-j bwjuniper
do
  curl -fsSL https://github.com/${user}.keys | sed "s/$/ $user/" >> ~/.ssh/authorized_keys
done
sort -u ~/.ssh/authorized_keys > ~/.ssh/authorized_keys.uniq
mv ~/.ssh/authorized_keys.uniq ~/.ssh/authorized_keys
