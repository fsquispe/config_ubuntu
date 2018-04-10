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
apt-add-repository ppa:ondrej/apache2
apt-add-repository ppa:sjinks/phalcon
apt update
apt -y full-upgrade
apy -y install build-essential htop vim zip unzip rar unace p7zip-full p7zip-rar sharutils mpack arj git

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
apt -y install libmariadbclient-dev libmariadbd-dev libssl-dev libcrypto++-dev
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

cd /etc/php5/fpm/pool.d/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/php.www.conf
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g php.www.conf > www.conf
rm php.www.conf
service php5-fpm restart


##### ANACR0N SERVICES ########################################################
cd /etc/cron.daily/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/memcached
chmod 750 ./memcached
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/ntpdate
chmod 750 ./ntpdate


##### UWSGI ###################################################################
apt -y install uwsgi uwsgi-plugin-python


##### APACHE2.4 ###############################################################
apt -y install apache2 libapache2-mod-proxy-uwsgi
a2enmod rewrite
a2enmod proxy_fcgi
a2enmod ssl
a2dismod autoindex -f
a2dismod negotiation -f
a2dismod status -f
a2dismod suexec -f
a2dismod fcgid -f
a2disconf serve-cgi-bin
a2disconf other-vhosts-access-log
a2disconf localized-error-pages
a2dissite 000-default
rm /etc/apache2/apache2.conf
rm /etc/apache2/ports.conf
rm /etc/apache2/sites-available/*

cd /etc/apache2/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/apache2/apache2.conf
mv apache2.conf apache2.conf.tmpl
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g apache2.conf.tmpl > apache2.conf
rm apache2.conf.tmpl

wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/apache2/ports.conf
mv ports.conf ports.conf.tmpl
sed -e s/"MY_IP"/"$MY_IP"/g ports.conf.tmpl > ports.conf
rm ports.conf.tmpl

cd /etc/apache2/conf-available/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/apache2/conf-available/charset.conf
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/apache2/conf-available/security.conf

cd /etc/apache2/mods-available/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/apache2/mods-available/dir.conf

cd /etc/apache2/sites-available/
wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/apache2/sites-available/default.conf
mv default.conf default.conf.tmpl
sed -e s/"MY_IP"/"$MY_IP"/g default.conf.tmpl > default.conf.tmpl.1
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g default.conf.tmpl.1 > default.conf
rm default.conf.*

wget -N https://dl.dropboxusercontent.com/u/1201303/trusty.3/tmpl/apache2/sites-available/default-ssl.conf
mv default-ssl.conf default-ssl.conf.tmpl
sed -e s/"MY_IP"/"$MY_IP"/g default-ssl.conf.tmpl > default-ssl.conf.tmpl.1
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g default-ssl.conf.tmpl.1 > default-ssl.conf
rm default-ssl.conf.*

a2ensite default
a2ensite default-ssl
service apache2 restart


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

mv vhost.fpm.conf vhost.fpm.conf.tmpl
mv vhost.static.conf vhost.static.conf.tmpl

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
