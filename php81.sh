#!/bin/sh

###############################################################################
##### PHP-FPM Y CLI ###########################################################
###############################################################################
apt install -y php-cli php-fpm php-common php-json php-opcache php-readline php-curl php-mysql php-gd php-intl php-imap php-sqlite3 php-xml php-xmlrpc php-xsl php-tidy php-zip php-soap php-mbstring php-pear php-memcache php-memcached php-imagick
##### CONFIGURACION ###########################################################
cp ./tmpl/php/php.ini /etc/php/8.1/cli/php.ini
cp /etc/php/8.1/cli/php.ini /etc/php/8.1/fpm/php.ini
rm /etc/php/8.1/fpm/pool.d/*
systemctl restart php-fpm
#EOF