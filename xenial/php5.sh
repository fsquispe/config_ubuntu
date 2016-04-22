#!/bin/sh

###############################################################################
##### PHP7-FPM Y CLI ##########################################################
###############################################################################
apt -y php7.0 php7.0-curl php7.0-mysql php7.0-gd php7.0-intl php7.0-imap php7.0-mcrypt php7.0-recode php7.0-sqlite3 php7.0-pspell php7.0-xml php7.0-xmlrpc php7.0-xsl php7.0-tidy php7.0-zip php7.0-soap php7.0-mbstring php-pear php-memcache php-memcached php-imagick
php5enmod imap
php5enmod mcrypt
php5enmod ps
php5enmod readline

cd /etc/php7/fpm/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/php.ini
cp php.ini /etc/php5/cli/php.ini
rm /etc/php5/fpm/pool.d/*

service php5-fpm restart
#EOF
