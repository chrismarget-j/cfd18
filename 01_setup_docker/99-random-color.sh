#!/bin/sh

touch /tmp/random-color

color=$(openssl rand -hex 3)
sed -i "s/^<body.*/<body style=\"background-color:#$color;\">/" /usr/share/nginx/html/index.html
sed -i "s/Welcome to nginx/Welcome to Cloud Field Day/" /usr/share/nginx/html/index.html
