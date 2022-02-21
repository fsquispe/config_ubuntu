#!/bin/sh

###############################################################################
### CONFIGURADOR NET5 Y SQL SERVER ############################################
###############################################################################
cd /tmp
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt install -y apt-transport-https
apt update -y
apt -y install dotnet-sdk-6.0
apt -y install dotnet-runtime-6.0
apt -y install unixodbc unixodbc-dev msodbcsql17
#EOF
