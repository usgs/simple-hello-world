import json

import falcon


class HelloWorld:

    def on_get(self, req, resp):
        resp.body = json.dumps({'greeting': 'Hi!'})
        resp.status = falcon.HTTP_200
