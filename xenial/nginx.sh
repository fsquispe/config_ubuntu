#!/bin/sh

###############################################################################
############# CONFIGURADOR SERVER ESTANDAR LAMP UBUNTU 14.04.3 ################
################################################################## v 0.3 ######
##### ejecutar como root (sin sudo) ###########################################
##### requisitos: #############################################################
##### *) ssh y ssh_keys instaladas ############################################
##### *) particiones extras montadas (/home/mysql, swap) ######################
##### *) dnsmasq y networking funcionado ######################################
##### *) OBLIGATORIO: password mariadb/mysql inicial 123456 ###################
##### *) OPCIONAL: bloquear ipv6 ##############################################
###############################################################################
###############################################################################


##### PARAMETROS ##############################################################
read -p "hostname: " MY_HOSTNAME
read -p "ip principal: " MY_IP


##### WWW-DATA/WWW-SSL DIRECTORY ##############################################
mkdir /home/www-data/
chmod 700 /home/www-data/
chown www-data:www-data /home/www-data/
cd /home/www-data/
mkdir tmp
mkdir www
mkdir www-ssl
chmod 700 *
chown -R www-data:www-data *

cd /home/www-data/www-ssl/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/www-ssl.index.html
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g www-ssl.index.html > index.html
rm www-ssl.index.html


##### NGINX ###################################################################
apt -y install nginx
service nginx stop

cd /etc/nginx/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/nginx/nginx.conf

mkdir /etc/nginx/global.d/
cd /etc/nginx/global.d/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/nginx/global.d/custom.conf

rm /etc/nginx/sites-enabled/*
rm /etc/nginx/sites-available/*
cd /etc/nginx/sites-available/

wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/nginx/sites-available/default
sed -e s/"MY_IP"/"$MY_IP"/g default > default.1
mv default.1 default

wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/nginx/sites-available/default-ssl
sed -e s/"MY_IP"/"$MY_IP"/g default-ssl > default-ssl.1
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g default-ssl.1 > default-ssl.2
mv default-ssl.2 default-ssl
rm default-ssl.1

wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/nginx/sites-available/redirect
sed -e s/"MY_IP"/"$MY_IP"/g redirect > redirect.1
mv redirect.1 redirect

ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/default-ssl /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/redirect /etc/nginx/sites-enabled/


service nginx start


##### ROOT UTILS ##############################################################
mkdir /root/bin/
mkdir /root/tmpl/

cd /root/bin/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/bin/delete_user
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/bin/kcleaner
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/bin/new_user_fpm
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/bin/new_user_static
chmod 700 ./*

cd /root/tmpl/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/tmpl/fpm.conf
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/tmpl/vhost.fpm.conf
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/tmpl/vhost.static.conf

mv ./vhost.fpm.conf ./vhost.fpm.conf.tmpl
mv ./vhost.static.conf ./vhost.static.conf.tmpl

sed -e s/"MY_IP"/"$MY_IP"/g vhost.fpm.conf.tmpl > vhost.fpm.conf
rm vhost.fpm.conf.*

sed -e s/"MY_IP"/"$MY_IP"/g vhost.static.conf.tmpl > vhost.static.conf
rm vhost.static.conf.*

chmod 600 ./*


##### LIMPIEZA ################################################################
apt-get -y autoremove --purge
apt-get clean
###############################################################################
#eof
