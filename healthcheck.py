"""
Simple healthcheck to be used by Docker
to verify that the application is working.

"""
import sys
from urllib import request


with request.urlopen('http://127.0.0.1:9050/hi/hello-world') as resp:
    status_code = resp.status

if status_code == 200:
    sys.exit(0)
else:
    sys.exit(1)
