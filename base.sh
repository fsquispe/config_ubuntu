#!/bin/sh

###############################################################################
### CONFIGURADOR UBUNTU 22.04.2 ###############################################
###############################################################################

##### LANG ####################################################################
vim /etc/default/locale
dpkg-reconfigure locales
dpkg-reconfigure tzdata

##### BASE ####################################################################
apt -y install software-properties-common
vim /etc/hostname
vim /etc/hosts

##### REPOSITORIOS ############################################################
cp ./tmpl/base/sources.list /etc/apt/
apt update
apt -y full-upgrade
apt -y install build-essential htop vim zip unzip rar unace p7zip-full p7zip-rar sharutils mpack arj git screen dnsutils goaccess apache2-utils libjpeg-dev certbot net-tools ncdu tree

##### LIMPIEZA ################################################################
/etc/init.d/apparmor stop
update-rc.d -f apparmor remove
apt -y remove --purge needrestart
apt -y remove --purge lxc
apt -y remove --purge lxcfs
apt -y remove --purge lxc*
apt -y remove --purge mdadm
apt -y remove --purge apparmor apparmor-utils
apt -y remove --purge lib-apparmor
apt -y remove --purge consolekit
apt -y remove --purge landscape-common
apt -y remove --purge irqbalance
apt -y remove --purge multipath-tools
apt -y remove --purge policykit-1
apt -y remove --purge fwupd
apt -y remove --purge containerd

##### ACTUALIZACIONES AUTOMATICAS #############################################
apt install unattended-upgrades
dpkg-reconfigure unattended-upgrades
cp ./tmpl/base/20auto-upgrades /etc/apt/apt.conf.d/

##### GOACCESS ################################################################
cp ./tmpl/base/goaccess.conf /etc/goaccess/

##### SSL CERTS ###############################################################
apt -y install ssl-cert
make-ssl-cert generate-default-snakeoil --force-overwrite

##### ROOT UTILS ##############################################################
mkdir /root/bin/
mkdir /root/snippets/
cp ./tmpl/root/bin/* /root/bin/
cp ./tmpl/root/snippets/* /root/snippets/
chmod 500 /root/bin/*
chmod 400 /root/snippets/*

##### LIMPIEZA ################################################################
apt -y autoremove --purge
apt clean
#EOF
