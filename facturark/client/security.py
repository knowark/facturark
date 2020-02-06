import base64
import hashlib
import xmlsec
from lxml import etree
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.hashes import SHA256
from cryptography.hazmat.primitives.asymmetric.utils import Prehashed
from cryptography.hazmat.primitives.asymmetric.padding import PKCS1v15
from cryptography.hazmat.primitives.serialization import load_pem_private_key
from zeep.wsdl.utils import get_or_create_header
from zeep.wsse import utils
from zeep.wsse.signature import (
    MemorySignature, _make_sign_key, _sign_envelope_with_key_binary)
from datetime import datetime, timedelta


class Security():
    """
    Based in https://github.com/mvantellingen/python-zeep/blob/
    master/src/zeep/wsse/signature.py#BinarySignature but
    implemented in memory.
    """

    def __init__(self, key_data=None, cert_data=None,
                 password=None, namespaces=None, methods=None):
        # super(Signature, self).__init__(*args, **kwargs)
        self.key_data = key_data
        self.cert_data = cert_data
        self.password = password
        self.namespaces = {
            "soap-env": "http://www.w3.org/2003/05/soap-envelope",
            "wsa": "http://www.w3.org/2005/08/addressing",
            "wsse": (
                "http://docs.oasis-open.org/wss/2004/01/"
                "oasis-200401-wss-wssecurity-secext-1.0.xsd"),
            "wsu": (
                "http://docs.oasis-open.org/wss/2004/01/"
                "oasis-200401-wss-wssecurity-utility-1.0.xsd"),
            "ds": "http://www.w3.org/2000/09/xmldsig#",
            "ec": "http://www.w3.org/2001/10/xml-exc-c14n#"
        }
        self.methods = {
            "c14n": "http://www.w3.org/2001/10/xml-exc-c14n#",
            "sha256": "http://www.w3.org/2001/04/xmlenc#sha256",
            "rsa_sha256": "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256",
            "x509v3": (
                    "http://docs.oasis-open.org/wss/2004/01/"
                    "oasis-200401-wss-x509-token-profile-1.0#X509v3"),
            "base64binary": (
                "http://docs.oasis-open.org/wss/2004/01/"
                "oasis-200401-wss-soap-message-security-1.0#Base64Binary")

        }
        self.namespaces.update(namespaces or {})
        self.methods.update(methods or {})

    def apply(self, envelope, headers):
        self._attach_timestamp(envelope)

        certificate_id = self._attach_binary_security_token(
            envelope, self.cert_data)

        self._attach_signature(envelope, certificate_id)

        from lxml.etree import tostring

        print('\n\nAPPLY************')
        print(tostring(envelope).decode())

        return envelope, headers

    def verify(self, envelope):
        return envelope

    def _get_security_header(self, envelope):
        header = envelope.find("soap-env:Header", namespaces=self.namespaces)
        security = header.find("wsse:Security", namespaces=self.namespaces)
        if security is None:
            security = etree.Element(
                etree.QName(self.namespaces['wsse'], "Security"),
                # nsmap=self.namespaces

            )
            header.insert(0, security)
        return security

    def _attach_timestamp(self, envelope):
        security = self._get_security_header(envelope)
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
        security = self._get_security_header(envelope)
        certificate = certificate.replace(b'-----BEGIN CERTIFICATE-----', b'')
        certificate = certificate.replace(b'-----END CERTIFICATE-----', b'')
        certificate = certificate.replace(b'\n', b'')
        binary_token = etree.Element(
            etree.QName(self.namespaces['wsse'], "BinarySecurityToken"), {
                "ValueType": self.methods['x509v3'],
                "EncodingType": self.methods['base64binary']})
        binary_token_id = utils.ensure_id(binary_token)
        binary_token.text = certificate
        security.append(binary_token)
        return binary_token_id

    def _attach_signature(self, envelope, certificate_id):
        security = self._get_security_header(envelope)
        signature = etree.SubElement(
            security,
            etree.QName(self.namespaces['ds'], "Signature"))

        reference_id, digest = self._process_reference(envelope)
        signed_info = self._set_signed_info(signature, reference_id, digest)
        signature_text = self._compute_signature(signed_info)
        self._set_signature_value(envelope, signature_text)
        self._set_key_info(signature, certificate_id)

    def _process_reference(self, envelope):
        header = envelope.find(
            etree.QName(self.namespaces['soap-env'], "Header"))
        reference = header.find(etree.QName(self.namespaces['wsa'], "To"))
        reference_id = utils.ensure_id(reference)
        canonicalized_reference = etree.tostring(reference, method="c14n")
        digest = base64.b64encode(
            hashlib.sha256(canonicalized_reference).digest())
        return reference_id, digest

    def _set_signed_info(self, signature, reference_id, digest):
        signed_info = etree.SubElement(
            signature, etree.QName(self.namespaces['ds'], "SignedInfo"))
        canonicalization_method = etree.SubElement(
            signed_info,
            etree.QName(self.namespaces['ds'], "CanonicalizationMethod"), {
                "Algorithm": self.methods['c14n']})
        etree.SubElement(
            canonicalization_method,
            etree.QName(self.namespaces['ec'], "InclusiveNamespaces"), {
                "PrefixList": "wsa soap-env ns0"}

        )
        etree.SubElement(
            signed_info,
            etree.QName(self.namespaces['ds'], "SignatureMethod"), {
                "Algorithm": self.methods['rsa_sha256']})
        self._set_reference(signed_info, reference_id, digest)
        return signed_info

    def _set_reference(self, signed_info, reference_id, digest):
        reference = etree.SubElement(
            signed_info,
            etree.QName(self.namespaces['ds'], "Reference"), {
                "URI": "#" + reference_id})
        transforms = etree.SubElement(
            reference,
            etree.QName(self.namespaces['ds'], "Transforms"))
        transform = etree.SubElement(
            transforms,
            etree.QName(self.namespaces['ds'], "Transform"), {
                "Algorithm": self.methods['c14n']})
        etree.SubElement(
            transform,
            etree.QName(self.namespaces['ec'], "InclusiveNamespaces"), {
                "PrefixList": "soap-env ns0"})
        etree.SubElement(
            reference,
            etree.QName(self.namespaces['ds'], "DigestMethod"), {
                "Algorithm": self.methods['sha256']})
        digest_value = etree.SubElement(
            reference,
            etree.QName(self.namespaces['ds'], "DigestValue"))
        digest_value.text = digest

    def _compute_signature(self, signed_info):
        canonicalized_signed_info = etree.tostring(signed_info, method="c14n")
        private_key = load_pem_private_key(
            self.key_data, password=None, backend=default_backend())

        padding = PKCS1v15()
        hash_algorithm = SHA256()

        signature = private_key.sign(
            canonicalized_signed_info, padding, hash_algorithm)

        return base64.b64encode(signature)

    def _set_signature_value(self, envelope, signature_text):
        security = self._get_security_header(envelope)
        signature = security.find(
            etree.QName(self.namespaces['ds'], "Signature"))
        signature_value = etree.SubElement(
            signature,
            etree.QName(self.namespaces['ds'], "SignatureValue"))
        signature_value.text = signature_text

    def _set_key_info(self, signature, certificate_id):
        key_info = etree.SubElement(
            signature, etree.QName(self.namespaces['ds'], "KeyInfo"))
        security_token_reference = etree.SubElement(
            key_info,
            etree.QName(self.namespaces['wsse'], "SecurityTokenReference"))
        reference = etree.SubElement(
            security_token_reference,
            etree.QName(self.namespaces['wsse'], "Reference"), {
                "URI": "#" + certificate_id,
                "ValueType": self.methods['x509v3']})
