#!/bin/sh

###############################################################################
##### PHP5-FPM Y CLI ##########################################################
###############################################################################
apt -y install php5-fpm php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-memcached php5-ming php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-json
php5enmod imap
php5enmod mcrypt
php5enmod ps
php5enmod readline

cd /etc/php5/fpm/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/php.ini
cp php.ini /etc/php5/cli/php.ini
rm /etc/php5/fpm/pool.d/*

service php5-fpm restart
#EOF
