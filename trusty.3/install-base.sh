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
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 40976EAF437D05B5
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3B4FE6ACC0B21F32
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 16126D3A3E5C1192
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository 'deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main'
add-apt-repository 'deb-src http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main'
apt-add-repository ppa:sjinks/phalcon
apt-add-repository ppa:pypy/ppa
apt update
apt -y full-upgrade
apt -y install build-essential htop vim zip unzip rar unace p7zip-full p7zip-rar sharutils mpack arj git screen

##### LIMPIEZA ################################################################
/etc/init.d/apparmor stop
update-rc.d -f apparmor remove
apt-get -y remove --purge apparmor apparmor-utils
apt-get -y remove --purge lib-apparmor
apt-get -y remove --purge consolekit
apt-get -y remove --purge language-pack-en
apt-get -y remove --purge language-pack-en-base
apt-get -y remove --purge sudo
apt-get -y remove --purge landscape-common
apt-get -y remove --purge irqbalance
rm /etc/init.d/tty3.conf /etc/init.d/tty4.conf /etc/init.d/tty5.conf /etc/init.d/tty6.conf
rm /etc/init/tty3.conf /etc/init/tty4.conf /etc/init/tty5.conf /etc/init/tty6.conf

##### ROOT UTILS ##############################################################
mkdir /root/bin/
cd /root/bin/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/bin/kcleaner
chmod 600 ./*

##### LIMPIEZA ################################################################
apt-get -y autoremove --purge
apt-get clean
###############################################################################
#eof
