#!/bin/sh

###############################################################################
### PYTHON - DJANGO - UWSGI  ##################################################
###############################################################################
apt -y install libmysqlclient-dev libssl-dev libcrypto++-dev libffi-dev
apt -y install virtualenv python3-mysqldb python3-virtualenv pypy pypy-dev pypy-lib python3-pip python3-dev
##### UWSGI ###################################################################
apt -y install uwsgi uwsgi-plugin-python3
#EOF
