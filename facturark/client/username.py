import os
import base64
import hashlib
import datetime

from zeep import ns
from zeep.wsse import utils


class UsernameToken:

    def __init__(self, username, password):
        self.username = username
        self.password = password

    def apply(self, envelope, headers):
        security = utils.get_security_header(envelope)

        # The token placeholder might already exists since it is specified in
        # the WSDL.
        token = security.find('{%s}UsernameToken' % ns.WSSE)
        if token is None:
            token = utils.WSSE.UsernameToken()
            security.append(token)

        # Extra values
        nonce = os.urandom(16)
        timestamp = datetime.datetime.utcnow().isoformat()

        # Create the sub elements of the UsernameToken element
        elements = [
            utils.WSSE.Username(
                self.username
            ),
            utils.WSSE.Password(
                hashlib.sha256(self.password).hexdigest()
            ),
            utils.WSSE.Nonce(
                base64.b64encode(nonce).decode('utf-8')
            ),
            utils.WSU.Created(
                timestamp
            )
        ]

        token.extend(elements)
        return envelope, headers
