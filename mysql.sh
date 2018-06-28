#!/bin/sh

###############################################################################
### CONFIGURADOR MYSQL ########################################################
###############################################################################
apt -y install mysql-server mysql-client libmysqlclient-dev
mysql < ./tmpl/mysql/alter_user.sql
systemctl stop mysql
cp ./tmpl/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/
cp ./tmpl/mysql/root.my.cnf /root/.my.cnf
chmod 600 /root/.my.cnf
systemctl start mysql
mysql_secure_installation
apt -y remove --purge policykit*
#EOF
