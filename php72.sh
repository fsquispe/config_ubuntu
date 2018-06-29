#!/bin/sh

###############################################################################
##### PHP7.2 -FPM Y CLI #######################################################
###############################################################################
apt install -y php7.2-cli php7.2-fpm php7.2-common php7.2-json php7.2-opcache php7.2-readline php7.2-curl php7.2-mysql php7.2-gd php7.2-intl php7.2-imap php7.2-recode php7.2-sqlite3 php7.2-xml php7.2-xmlrpc php7.2-xsl php7.2-tidy php7.2-zip php7.2-soap php7.2-mbstring php-pear php-memcache php-memcached php-imagick
##### CONFIGURACION ###########################################################
cp ./tmpl/php72/php.ini /etc/php/7.2/cli/php.ini
cp /etc/php/7.2/cli/php.ini /etc/php/7.2/fpm/php.ini
rm /etc/php/7.2/fpm/pool.d/*
systemctl restart php7.2-fpm
#EOF
