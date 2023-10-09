#!/bin/bash

if [ -e /tmp/public_ip ]
then
  cat /tmp/public_ip
  exit
fi

curl -fsSL 'https://api.ipify.org?format=json' > /tmp/public_ip
cat /tmp/public_ip