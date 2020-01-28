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
echo "Website URL/IP (including http:// or https://): "
read website
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
mkdir /var/www/proxy
echo '
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/proxy;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options SAMEORIGIN always;
        add_header X-XSS-Protection "1; mode=block" always;
        proxy_set_header X-Real-IP $remote_addr;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                proxy_pass '$website';
        }
}' >> /etc/nginx/sites-enabled/wse
echo '
server {
        listen 8080 default_server;
        listen [::]:8080 default_server;
        root /var/www/html;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options SAMEORIGIN always;
        add_header X-XSS-Protection "1; mode=block" always;
        proxy_set_header X-Real-IP $remote_addr;
        index index.php index.html index.htm index.nginx-debian.html;
        server_name _;
}' >> /etc/nginx/sites-enabled/control
wget -O /var/www/html/index.html https://raw.githubusercontent.com/brent901/WebsiteSecurityEnchancer/master/index.html
service nginx restart
