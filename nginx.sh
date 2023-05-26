#!/bin/sh

###############################################################################
##### NGINX ###################################################################
###############################################################################

##### NGINX ###################################################################
apt -y install nginx
systemctl stop nginx
cp ./tmpl/nginx/nginx.conf /etc/nginx/
cp ./tmpl/nginx/sites-available/default /etc/nginx/sites-available/default
cp ./tmpl/nginx/sites-available/default-ssl /etc/nginx/sites-available/default-ssl
cp ./tmpl/nginx/sites-available/redirect /etc/nginx/sites-available/redirect
rm /etc/nginx/sites-enabled/*
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/default-ssl /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/redirect /etc/nginx/sites-enabled/
systemctl start nginx

#EOF
