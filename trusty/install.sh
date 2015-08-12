#!/bin/sh

###############################################################################
############# CONFIGURADOR SERVER ESTANDAR LAMP UBUNTU 14.04 ##################
################################################################## v 0.1 ######
##### ejecutar como root (sin sudo) ###########################################
##### requisitos: #############################################################
##### *) ssh y ssh_keys instaladas ############################################
##### *) particiones extras montadas (/home/mysql, swap) ######################
##### *) resolv.conf contiene los dns validos (google o isp) ##################
##### *) OBLIGATORIO: password mariadb/mysql inicial 123456 ###################
##### *) OPCIONAL: bloquear ipv6 ##############################################
###############################################################################
###############################################################################


##### PARAMETROS ##############################################################
read -p "hostname: " MY_HOSTNAME
read -p "interfaz red (ex eth0): " MY_LAN_INTERFAZ
read -p "ip principal: " MY_IP
read -p "gateway: " MY_GATEWAY
read -p "mascara red: " MY_NETMASK


##### DNSMASQ #################################################################
apt -y install dnsmasq
cd /etc/
cp resolv.conf resolv.dnsmasq.conf
wget https://dl.dropboxusercontent.com/u/1201303/trusty/resolv.conf.tmpl
mv resolv.conf.tmpl resolv.conf
wget https://dl.dropboxusercontent.com/u/1201303/trusty/dnsmasq.conf.tmpl
mv dnsmasq.conf.tmpl dnsmasq.conf
service dnsmasq restart


##### NETWORKING ##############################################################
cd /etc/network/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/interfaces.tmpl
rm interfaces
sed -e s/"MY_LAN_INTERFAZ"/"$MY_LAN_INTERFAZ"/g interfaces.tmpl > interfaces.tmpl.1
sed -e s/"MY_IP"/"$MY_IP"/g interfaces.tmpl.1 > interfaces.tmpl.2
sed -e s/"MY_GATEWAY"/"$MY_GATEWAY"/g interfaces.tmpl.2 > interfaces.tmpl.3
sed -e s/"MY_NETMASK"/"$MY_NETMASK"/g interfaces.tmpl.3 > interfaces
rm interfaces.*
service networking restart


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
apt -y install software-properties-common build-essential htop vim zip unzip rar unace p7zip-full p7zip-rar sharutils mpack arj git
vim /etc/hostname
vim /etc/hosts


##### REPOSITORIOS ############################################################
rm /etc/apt/sources.list
cd /etc/apt/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/sources.list.tmpl
mv sources.list.tmpl /etc/apt/sources.list
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 40976EAF437D05B5
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3B4FE6ACC0B21F32
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 16126D3A3E5C1192
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository 'deb http://mirror.1000mbps.com/mariadb/repo/10.0/ubuntu trusty main'
apt-add-repository ppa:sjinks/phalcon
apt update
apt -y full-upgrade


##### LIMPIEZA ################################################################
/etc/init.d/apparmor stop
update-rc.d -f apparmor remove
apt-get -y remove --purge apparmor apparmor-utils
apt-get -y remove --purge lib-apparmor
apt-get -y remove --purge consolekit
apt-get -y remove --purge resolvconf
apt-get -y remove --purge language-pack-en
apt-get -y remove --purge language-pack-en-base
apt-get -y remove --purge sudo
apt-get -y remove --purge landscape-common
apt-get -y remove --purge irqbalance
rm /etc/init.d/tty2.conf /etc/init.d/tty3.conf /etc/init.d/tty4.conf /etc/init.d/tty5.conf /etc/init.d/tty6.conf
rm /etc/init/tty2.conf /etc/init/tty3.conf /etc/init/tty4.conf /etc/init/tty5.conf /etc/init/tty6.conf


##### SSH #####################################################################
cd /etc/ssh/
rm sshd_config
wget https://dl.dropboxusercontent.com/u/1201303/trusty/sshd_config.tmpl
sed -e s/"MY_IP"/"$MY_IP"/g sshd_config.tmpl > sshd_config
rm sshd_config.*
service ssh restart


##### MEMCACHED ###############################################################
apt -y install memcached


##### PROFTPD #################################################################
apt -y install proftpd
cd /etc/proftpd/
rm proftpd.conf
wget https://dl.dropboxusercontent.com/u/1201303/trusty/proftpd.conf.tmpl
sed -e s/"MY_IP"/"$MY_IP"/g proftpd.conf.tmpl > proftpd.conf.1
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g proftpd.conf.1 > proftpd.conf
rm proftpd.conf.*
service proftpd restart


##### FAIL2BAN ################################################################
apt -y install fail2ban
cd /etc/fail2ban/
rm jail.conf
wget https://dl.dropboxusercontent.com/u/1201303/trusty/jail.conf.tmpl
mv jail.conf.tmpl jail.conf
service fail2ban restart


##### MARIADB #################################################################
apt-get -y install mariadb-server
service mysql stop
mkdir /home/mysql/
cp -r /var/lib/mysql/* /home/mysql/
rm -rf /var/lib/mysql/*
chown -R mysql:mysql /home/mysql/
chmod 700 /home/mysql/
rm /home/mysql/ib_logfile0
rm /home/mysql/ib_logfile1
rm /etc/mysql/my.cnf
rm /etc/mysql/conf.d/mariadb.cnf
rm /var/log/mysql/mariadb-bin.*

cd /etc/mysql/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/my.cnf.tmpl
mv my.cnf.tmpl my.cnf

cd /etc/mysql/conf.d/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/mariadb.cnf.tmpl
mv mariadb.cnf.tmpl mariadb.cnf

service mysql start

cd /root/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/root.my.cnf.tmpl
mv root.my.cnf.tmpl .my.cnf
chmod 600 .my.cnf
wget https://dl.dropboxusercontent.com/u/1201303/trusty/post.sql.tmpl
mv post.sql.tmpl post.sql
mysql -u root -p123456 < post.sql
rm post.sql


##### PYTHON-DJANGO ###########################################################
apt -y install python-mysqldb python-pip python-virtualenv
apt -y install libmariadbclient-dev libmariadbd-dev libssl-dev libcrypto++-dev


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
mkdir /home/www-data/www-ssl/pmadmin/

cd /home/www-data/www-ssl/pmadmin/
wget https://dl.dropboxusercontent.com/u/1201303/pmadmin-4.2.1.zip
unzip pmadmin-4.2.1.zip && rm pmadmin-4.2.1.zip

cd /home/www-data/www-ssl/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/www-ssl.index.html.tmpl
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g www-ssl.index.html.tmpl > index.html
rm www-ssl.index.html.tmpl

cd /home/www-data/www-ssl/pmadmin/
rm config.inc.php
wget https://dl.dropboxusercontent.com/u/1201303/trusty/pmadmin.config.inc.php.tmpl
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g pmadmin.config.inc.php.tmpl > config.inc.php
rm pmadmin.config.inc.php.tmpl
vim config.inc.php


##### WWW-DATA/WWW DIRECTORY ##################################################
cd /home/www-data/www/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/www.tmpl.zip
unzip www.tmpl.zip
rm www.tmpl.zip
vim index.php


##### PHP5-FPM Y CLI ##########################################################
apt -y install php5-fpm php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-json php5-phalcon
php5enmod imap
php5enmod mcrypt
php5enmod ps
php5enmod readline
rm /etc/php5/fpm/php.ini
rm /etc/php5/fpm/pool.d/www.conf

cd /etc/php5/fpm/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/php.ini.tmpl
mv php.ini.tmpl php.ini
cp php.ini /etc/php5/cli/php.ini

cd /etc/php5/fpm/pool.d/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/php.www.conf.tmpl
sed -e s/"MY_HOSTNAME"/"$MY_HOSTNAME"/g php.www.conf.tmpl > www.conf
rm php.www.conf.tmpl
service php5-fpm restart


##### APACHE2.4 ###############################################################
apt -y install apache2
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


##### ANACR0N SERVICES ########################################################
cd /etc/cron.daily/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/memcached.tmpl
mv memcached.tmpl memcached
chmod 755 ./memcached
wget https://dl.dropboxusercontent.com/u/1201303/trusty/ntpdate.tmpl
mv ntpdate.tmpl ntpdate
chmod 755 ./ntpdate


##### ROOT UTILS ##############################################################
mkdir /root/bin/
mkdir /root/tmpl/

cd /root/bin/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/root/bin/delete_user.tmpl
wget https://dl.dropboxusercontent.com/u/1201303/trusty/root/bin/new_user_static.tmpl
wget https://dl.dropboxusercontent.com/u/1201303/trusty/root/bin/new_user_fpm.tmpl
wget https://dl.dropboxusercontent.com/u/1201303/trusty/root/bin/kcleaner.tmpl
mv delete_user.tmpl delete_user
mv new_user_static.tmpl new_user_static
mv new_user_fpm.tmpl new_user_fpm
mv kcleaner.tmpl kcleaner
chmod 700 ./*

cd /root/tmpl/
wget https://dl.dropboxusercontent.com/u/1201303/trusty/root/tmpl/fpm.conf.tmpl
mv fpm.conf.tmpl fpm.conf

wget https://dl.dropboxusercontent.com/u/1201303/trusty/root/tmpl/vhost.fpm.conf.tmpl
sed -e s/"MY_IP"/"$MY_IP"/g vhost.fpm.conf.tmpl > vhost.fpm.conf
rm vhost.fpm.conf.*

wget https://dl.dropboxusercontent.com/u/1201303/trusty/root/tmpl/vhost.static.conf.tmpl
sed -e s/"MY_IP"/"$MY_IP"/g vhost.static.conf.tmpl > vhost.static.conf
rm vhost.static.conf.*

chmod 600 ./*


##### LIMPIEZA ################################################################
apt-get -y autoremove --purge
apt-get clean
###############################################################################
#eof
