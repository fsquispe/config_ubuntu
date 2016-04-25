#!/bin/sh

###############################################################################
### CONFIGURADOR MARIADB ######################################################
###############################################################################
apt -y install mariadb-server mariadb-client libmariadbclient-dev libmariadbd-dev
systemctl stop mysql
cp ./tmpl/mariadb/my.cnf /etc/mysql/
cp ./tmpl/mariadb/conf.d/mariadb.cnf /etc/mysql/conf.d/
cp ./tmpl/mariadb/root/root.my.cnf /root/.my.cnf
chmod 600 /root/.my.cnf
systemctl start mysql
mysql_secure_installation
#EOF
