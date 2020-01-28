#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
echo "WSE must be installed by itself for compatibility and security reasons. It also works best on a fresh installation of Ubuntu. Type 'y' and enter to continue"
read confirm
if [ $confirm != "y" ]
then
echo "You need to enter 'y' in order to continue"
exit
fi
apt update
apt upgrade -y
apt install net-tools -y

if [ "$(netstat -l | grep http)" != "" ]
then
echo "HTTP Server detected, can not install."
exit
fi
apt install nginx -y
service nginx start
rm /etc/nginx/sites-enabled/*
echo '
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options SAMEORIGIN always;
        add_header X-XSS-Protection "1; mode=block" always;
        proxy_set_header X-Real-IP $remote_addr;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                proxy_pass ;
        }
}' >> /etc/nginx/sites-enabled/wse

service nginx restart
