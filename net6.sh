#!/bin/sh

###############################################################################
### CONFIGURADOR NET8 Y SQL SERVER ############################################
###############################################################################
apt install -y apt-transport-https
apt update -y
apt -y install dotnet-sdk-8.0
apt -y install unixodbc unixodbc-dev
#EOF
