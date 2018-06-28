#!/bin/sh

###############################################################################
##### PHP7-FPM Y CLI ##########################################################
###############################################################################
apt install -y php7.0 php7.0-curl php7.0-mysql php7.0-gd php7.0-intl php7.0-imap php7.0-mcrypt php7.0-recode php7.0-sqlite3 php7.0-pspell php7.0-xml php7.0-xmlrpc php7.0-xsl php7.0-tidy php7.0-zip php7.0-soap php7.0-mbstring php-pear php-memcache php-memcached php-imagick
##### CONFIGURACION ###########################################################
cp ./tmpl/php7/php.ini /etc/php/7.0/cli/php.ini
cp /etc/php/7.0/cli/php.ini /etc/php/7.0/fpm/php.ini
rm /etc/php/7.0/fpm/pool.d/*
systemctl restart php7.0-fpm
##### PLANTILLAS ##############################################################
mkdir /root/tmpl/
cp ./tmpl/php7/root/tmpl/* /root/tmpl/
#EOF
