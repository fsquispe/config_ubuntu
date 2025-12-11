#!/bin/sh

###############################################################################
### CONFIGURADOR UBUNTU 24.04 #################################################
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
apt update
apt -y full-upgrade

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
apt -y remove --purge polkitd
apt -y remove --purge postfix

##### ACTUALIZACIONES AUTOMATICAS #############################################
apt install unattended-upgrades
dpkg-reconfigure unattended-upgrades
cp ./tmpl/base/20auto-upgrades /etc/apt/apt.conf.d/

##### SSL CERTS ###############################################################
apt -y install ssl-cert
make-ssl-cert generate-default-snakeoil --force-overwrite

##### LIMPIEZA ################################################################
apt -y autoremove --purge
apt clean
#EOF
