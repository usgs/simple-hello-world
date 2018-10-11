import falcon

from .services import HelloWorld


api = application = falcon.API()

hi = HelloWorld()

api.add_route('/hi/hello-world/', hi)
