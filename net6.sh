#!/bin/sh

###############################################################################
### CONFIGURADOR NET6 Y SQL SERVER ############################################
###############################################################################
apt install -y apt-transport-https
apt update -y
apt -y install dotnet-sdk-6.0
apt -y install dotnet-runtime-6.0
apt -y install unixodbc unixodbc-dev
#EOF
