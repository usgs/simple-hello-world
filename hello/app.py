import falcon

from .services import HelloWorld, Version


api = application = falcon.API()

hi = HelloWorld()
version = Version()

api.add_route('/hi/hello-world/', hi)
api.add_route('/hi/version', version)
