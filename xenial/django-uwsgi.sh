#!/bin/sh

###############################################################################
### PYTHON - DJANGO - UWSGI  ##################################################
###############################################################################
apt -y install python-dev python-mysqldb python-pip python-virtualenv pypy pypy-dev pypy-lib python3-pip python3-dev
apt -y install libssl-dev libcrypto++-dev libffi-dev
apt -y install nodejs npm
ln -s /usr/bin/nodejs /usr/local/bin/node
npm install -g stylus
npm install -g coffee-script
npm install -g less
npm install -g yuglify
##### UWSGI ###################################################################
apt -y install uwsgi uwsgi-plugin-python uwsgi-plugin-python3
#EOF
