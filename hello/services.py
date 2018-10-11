import json

import falcon

from . import __version__


class HelloWorld:

    def on_get(self, req, resp):
        resp.body = json.dumps({'greeting': 'Hi!'})
        resp.status = falcon.HTTP_200


class Version:

    def on_get(self, req, resp):
        resp.body = json.dumps({'version': __version__})
        resp.status = falcon.HTTP_200
