#!/bin/sh

hostname=$(cat /tmp/hostname)
if [ -n "$hostname" ] && [ "$hostname" != "$(cat /tmp/hostname)}" ]
then
  echo "127.0.0.1 $(cat /tmp/hostname)" | sudo tee -a /etc/hosts
  sudo hostnamectl set-hostname "$(cat /tmp/hostname)"
fi

if [ ! -e "/etc/apt/apt.conf.d/99no-recommends" ]
then
  echo 'APT::Install-Recommends \"false\";' | sudo tee /etc/apt/apt.conf.d/99no-recommends
fi

if [ ! -x "/usr/bin/tailscale" ]
then
  sudo apt-get update -q
  touch /tmp/update
  sudo apt-get install -y ca-certificates
  curl -fsSL https://tailscale.com/install.sh | sh
  sudo tailscale up
fi

if [ -e /tmp/github_user ]
then
  mkdir -pm 700 ~/.ssh
  for user in $(cat /tmp/github_user)
  do
    curl -fsSL https://github.com/${user}.keys | sed "s/$/ $user/" >> ~/.ssh/authorized_keys
  done
  sort -u ~/.ssh/authorized_keys > ~/.ssh/authorized_keys.uniq
  mv ~/.ssh/authorized_keys.uniq ~/.ssh/authorized_keys
fi

ip -o link list | grep @eth1 | awk '{print $2}' | sed 's/@.*//' | xargs -rn 1 sudo ip link del
ip -o link list | grep @bond0 | awk '{print $2}' | sed 's/@.*//' | xargs -rn 1 sudo ip link del
ip -o link list | grep ' bond0:' | awk '{print $2}' | sed 's/://' | xargs -rn 1 sudo ip link del

echo "checking for docker..."
if [ ! -x "/usr/bin/docker" ]
then
  echo "setting up docker..."
  sudo apt-get install -y apt-transport-https software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository -y 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'
  sudo apt update -q
  sudo apt-cache policy docker-ce
  sudo apt-get install -y -q docker-ce
  ip=$(ip -4 -o addr list dev tailscale0 | awk '{print $4}' | sed 's:/.*::')
  b64=eyJob3N0cyI6IFsidGNwOi8vJXM6MjM3NSIsICJ1bml4Oi8vL3Zhci9ydW4vZG9ja2VyLnNvY2siXX0K
  printf "$(echo $b64 | base64 --decode)\n" $ip | sudo tee /etc/docker/daemon.json
  sudo sed -i 's| -H fd://||' /lib/systemd/system/docker.service
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  sudo usermod -aG docker admin
fi
