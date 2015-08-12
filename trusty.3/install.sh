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
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 40976EAF437D05B5
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3B4FE6ACC0B21F32
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 16126D3A3E5C1192
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository 'deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main'
add-apt-repository 'deb-src http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main'
apt-add-repository ppa:sjinks/phalcon
apt update
apt -y full-upgrade
apt -y install build-essential htop vim zip unzip rar unace p7zip-full p7zip-rar sharutils mpack arj git

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
rm /etc/init.d/tty2.conf /etc/init.d/tty3.conf /etc/init.d/tty4.conf /etc/init.d/tty5.conf /etc/init.d/tty6.conf
rm /etc/init/tty2.conf /etc/init/tty3.conf /etc/init/tty4.conf /etc/init/tty5.conf /etc/init/tty6.conf


##### MEMCACHED ###############################################################
apt -y install memcached


##### MARIADB #################################################################
apt-get -y install mariadb-server
service mysql stop

cd /etc/mysql/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/my.cnf

cd /etc/mysql/conf.d/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/mariadb.cnf

service mysql start

cd /root/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root.my.cnf
mv root.my.cnf .my.cnf
chmod 600 .my.cnf
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/post.sql
mysql -u root -p123456 < post.sql
rm post.sql


##### PYTHON-DJANGO ###########################################################
apt -y install python-dev python-mysqldb python-pip python-virtualenv
apt -y install libmariadbclient-dev libmariadbd-dev libssl-dev libcrypto++-dev libffi-dev
apt -y install nodejs npm
ln -s /usr/bin/nodejs /usr/local/bin/node
npm install -g stylus
npm install -g coffee-script
npm install -g less
npm install -g yuglify


##### WWW-DATA/WWW-SSL DIRECTORY ##############################################
mkdir /home/www-data/
chmod 700 /home/www-data/
chown www-data:www-data /home/www-data/
cd /home/www-data/
mkdir tmp
mkdir www
mkdir www-ssl
chmod 700 *
chown -R www-data:www-data *

cd /home/www-data/www-ssl/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/www-ssl.index.html
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g www-ssl.index.html > index.html
rm www-ssl.index.html


##### PHP5-FPM Y CLI ##########################################################
apt -y install php5-fpm php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-json php5-phalcon
php5enmod imap
php5enmod mcrypt
php5enmod ps
php5enmod readline

cd /etc/php5/fpm/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/php.ini
cp php.ini /etc/php5/cli/php.ini
rm /etc/php5/fpm/pool.d/*

service php5-fpm restart


##### ANACR0N SERVICES ########################################################
cd /etc/cron.daily/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/memcached
chmod 750 ./memcached
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/ntpdate
chmod 750 ./ntpdate


##### UWSGI ###################################################################
apt -y install uwsgi uwsgi-plugin-python


##### NGINX ###################################################################
apt -y install nginx
service nginx stop

cd /etc/nginx/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/nginx/nginx.conf

mkdir /etc/nginx/global.d/
cd /etc/nginx/global.d/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/nginx/global.d/custom.conf

rm /etc/nginx/sites-enabled/*
rm /etc/nginx/sites-available/*
cd /etc/nginx/sites-available/

wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/nginx/sites-available/default
sed -e s/"MY_IP"/"$MY_IP"/g default > default.1
mv default.1 default

wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/nginx/sites-available/default-ssl
sed -e s/"MY_IP"/"$MY_IP"/g default-ssl > default-ssl.1
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g default-ssl.1 > default-ssl.2
mv default-ssl.2 default-ssl
rm default-ssl.1

wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/nginx/sites-available/redirect
sed -e s/"MY_IP"/"$MY_IP"/g redirect > redirect.1
mv redirect.1 redirect

ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/default-ssl /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/redirect /etc/nginx/sites-enabled/

apt -y install ssl-cert
make-ssl-cert generate-default-snakeoil --force-overwrite
service nginx start


##### ROOT UTILS ##############################################################
mkdir /root/bin/
mkdir /root/tmpl/

cd /root/bin/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/bin/delete_user
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/bin/kcleaner
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/bin/new_user_fpm
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/bin/new_user_static
chmod 700 ./*

cd /root/tmpl/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/tmpl/fpm.conf
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/tmpl/vhost.fpm.conf
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/root/tmpl/vhost.static.conf

mv ./vhost.fpm.conf ./vhost.fpm.conf.tmpl
mv ./vhost.static.conf ./vhost.static.conf.tmpl

sed -e s/"MY_IP"/"$MY_IP"/g vhost.fpm.conf.tmpl > vhost.fpm.conf
rm vhost.fpm.conf.*

sed -e s/"MY_IP"/"$MY_IP"/g vhost.static.conf.tmpl > vhost.static.conf
rm vhost.static.conf.*

chmod 600 ./*


##### LIMPIEZA ################################################################
apt-get -y autoremove --purge
apt-get clean
###############################################################################
#eof
