#!/bin/sh

###############################################################################
##### MEMCACHED ###############################################################
###############################################################################
apt -y install memcached
systemctl stop memcached
cp ./tmpl/memcached/memcached.conf /etc/
systemctl start memcached
##### ANACR0N SERVICES ########################################################
cp ./tmpl/anacr0n/memcached /etc/cron.daily/
chmod 750 /etc/cron.daily/memcached
#EOF
