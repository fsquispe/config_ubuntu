from ._prod import *

ALLOWED_HOSTS = ['.64k.in']
SECRET_KEY = '2)Ek0^d-pg#ex^j!vt!8oc=3p+8)1^(r5wKv%847sn_*^q6hjr'
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'ink64',
        'USER': 'ink64',
        'PASSWORD': 'W3JVXMptTHbZXtsV',
        'HOST': 'localhost',
    }
}

STATIC_URL = '/static/'
STATIC_ROOT = '/home/ink64/www/static/'

