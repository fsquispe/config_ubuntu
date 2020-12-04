#!/bin/sh

###############################################################################
##### PHP7.4 -FPM Y CLI #######################################################
###############################################################################
apt install -y php7.4-cli php7.4-fpm php7.4-common php7.4-json php7.4-opcache php7.4-readline php7.4-curl php7.4-mysql php7.4-gd php7.4-intl php7.4-imap php7.4-sqlite3 php7.4-xml php7.4-xmlrpc php7.4-xsl php7.4-tidy php7.4-zip php7.4-soap php7.4-mbstring php-pear php-memcache php-memcached php-imagick
##### CONFIGURACION ###########################################################
cp ./tmpl/php74/php.ini /etc/php/7.4/cli/php.ini
cp /etc/php/7.4/cli/php.ini /etc/php/7.4/fpm/php.ini
rm /etc/php/7.4/fpm/pool.d/*
systemctl restart php7.4-fpm
#EOF