#!/bin/sh

###############################################################################
### CONFIGURADOR MYSQL ########################################################
###############################################################################

##### MARIADB #################################################################
apt -y install mysql-server mysql-client libmysqlclient-dev
systemctl stop mysql
cp ./tmpl/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/
cp ./tmpl/mysql/root.my.cnf /root/.my.cnf
chmod 600 /root/.my.cnf
systemctl start mysql
mysql_secure_installation
#EOF
