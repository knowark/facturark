import xmlsec
from lxml import etree
from zeep.wsse import utils
from zeep.wsse.signature import (
    MemorySignature, _make_sign_key, _sign_envelope_with_key_binary)
from datetime import datetime, timedelta


class Signature():
    """
    Signature based in https://github.com/mvantellingen/python-zeep/blob/
    master/src/zeep/wsse/signature.py#BinarySignature but
    implemented in memory.
    """

    def __init__(self, key_data=None, cert_data=None,
                 password=None, namespaces=None):
        # super(Signature, self).__init__(*args, **kwargs)
        self.key_data = key_data
        self.cert_data = cert_data
        self.password = password
        self.namespaces = {
            "wsse": (
                "http://docs.oasis-open.org/wss/2004/01/"
                "oasis-200401-wss-wssecurity-secext-1.0.xsd"
            ),
            "wsu": (
                "http://docs.oasis-open.org/wss/2004/01/"
                "oasis-200401-wss-wssecurity-utility-1.0.xsd"
            ),
            "ds": "http://www.w3.org/2000/09/xmldsig#"
        }
        self.namespaces.update(namespaces or {})

    def apply(self, envelope, headers):
        self._attach_timestamp(envelope)

        self._attach_binary_security_token(envelope, self.cert_data)

        self._attach_signature(envelope)

        from lxml.etree import tostring

        print('\n\nAPPLY************')
        print(tostring(envelope).decode())

        return envelope, headers

    def verify(self, envelope):
        return envelope

    def _attach_timestamp(self, envelope):
        security = utils.get_security_header(envelope)
        created = datetime.utcnow()
        expired = created + timedelta(seconds=600)
        timestamp = utils.WSU('Timestamp')
        timestamp.append(
            utils.WSU('Created',
                      created.replace(microsecond=0).isoformat()+'Z'))
        timestamp.append(
            utils.WSU('Expires',
                      expired.replace(microsecond=0).isoformat()+'Z'))
        security.append(timestamp)

    def _attach_binary_security_token(self, envelope, certificate):
        security = utils.get_security_header(envelope)
        certificate = certificate.replace(b'-----BEGIN CERTIFICATE-----', b'')
        certificate = certificate.replace(b'-----END CERTIFICATE-----', b'')
        certificate = certificate.replace(b'\n', b'')
        binary_token = etree.Element(
            etree.QName(self.namespaces['wsse'], "BinarySecurityToken"),
            {
                "ValueType": (
                    "http://docs.oasis-open.org/wss/2004/01/"
                    "oasis-200401-wss-x509-token-profile-1.0#X509v3"),
                "EncodingType": (
                    "http://docs.oasis-open.org/wss/2004/01/"
                    "oasis-200401-wss-soap-message-security-1.0#Base64Binary")
            }
        )
        utils.ensure_id(binary_token)
        binary_token.text = certificate
        security.append(binary_token)

    def _attach_signature(self, envelope):
        security = utils.get_security_header(envelope)
        signature = etree.Element(
            etree.QName(self.namespaces['ds'], "Signature"))
        security.append(signature)
