from ._prod import *

ALLOWED_HOSTS = ['.svr64.xyz']
SECRET_KEY = '2)Ek0^d-pg#ex^j!vt!9oc=3p+3)4^(r5wKv%847sn_*^q6hjr'
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'xyz64',
        'USER': 'xyz64',
        'PASSWORD': 'WrZheVUiLdD6OFCspd',
        'HOST': 'localhost',
    }
}

STATIC_URL = '/static/'
STATIC_ROOT = '/home/xyz64/www/static/'
