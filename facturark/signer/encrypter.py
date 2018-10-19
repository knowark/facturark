# from OpenSSL import crypto
from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric.padding import (
    PSS, MGF1, PKCS1v15, calculate_max_pss_salt_length)
from cryptography.hazmat.primitives.hashes import SHA256, SHA512
from cryptography.hazmat.primitives.asymmetric.utils import Prehashed
from cryptography.hazmat.primitives.serialization import Encoding, PublicFormat
from base64 import b64decode


class Encrypter:

    def __init__(self):
        self.algorithms = {
            "http://www.w3.org/2001/04/xmlenc#sha512": ('sha512', SHA512),
            "http://www.w3.org/2001/04/xmldsig-more#rsa-sha512": (
                'sha512', SHA512),
            "http://www.w3.org/2001/04/xmlenc#sha256": ('sha256', SHA256),
            "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256": (
                'sha256', SHA256)
        }

    def create_signature(self, private_key, digest_b64, algorithm=(
            "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256")):

        data = b64decode(digest_b64)
        padding = PKCS1v15()

        if hasattr(algorithm, 'encode'):
            algorithm = algorithm.encode('utf8')

        algorithm = algorithm.decode("utf-8")
        hash_algorithm = self.algorithms[algorithm][1]()

        signature = private_key.sign(data, padding, Prehashed(hash_algorithm))

        return signature

    def verify_signature(self, certificate_b64, signature_b64,
                         digest_b64, algorithm):
        certificate = self._parse_certificate(certificate_b64)
        certificate = x509.load_pem_x509_certificate(
            certificate_b64, default_backend())
        public_key = certificate.public_key()

        signature = b64decode(signature_b64)
        digest = b64decode(digest_b64)
        padding = PKCS1v15()

        if hasattr(algorithm, 'encode'):
            algorithm = algorithm.encode('utf8')
        algorithm = algorithm.decode("utf-8")

        hash_algorithm = self.algorithms[algorithm][1]()

        public_key.verify(
            signature,
            digest,
            padding,
            Prehashed(hash_algorithm)
        )

        return True

    def _parse_certificate(self, certificate_b64):
        return x509.load_pem_x509_certificate(
            certificate_b64, default_backend())
