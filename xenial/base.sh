#!/bin/sh

###############################################################################
### CONFIGURADOR UBUNTU 16.04 #################################################
###############################################################################


##### PARAMETROS ##############################################################
read -p "hostname: " MY_HOSTNAME
read -p "ip principal: " MY_IP


##### LANG ####################################################################
apt -y install language-pack-es language-pack-es-base
/usr/share/locales/install-language-pack es_PE
vim /etc/environment
vim /etc/default/locale
vim /var/lib/locales/supported.d/local
vim /usr/share/i18n/locales/es_ES
dpkg-reconfigure locales
dpkg-reconfigure tzdata


##### BASE ####################################################################
apt -y install software-properties-common
vim /etc/hostname
vim /etc/hosts


##### REPOSITORIOS ############################################################
cd /etc/apt/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/sources.list
apt update
apt -y full-upgrade
apt -y install build-essential htop vim zip unzip rar unace p7zip-full p7zip-rar sharutils mpack arj git screen

##### LIMPIEZA ################################################################
/etc/init.d/apparmor stop
update-rc.d -f apparmor remove
apt -y remove --purge lxc
apt -y remove --purge lxcfs
apt -y remove --purge lxc*
apt -y remove --purge mdadm
apt -y remove --purge apparmor apparmor-utils
apt -y remove --purge lib-apparmor
apt -y remove --purge consolekit
apt -y remove --purge language-pack-en
apt -y remove --purge language-pack-en-base
apt -y remove --purge sudo
apt -y remove --purge landscape-common
apt -y remove --purge irqbalance
