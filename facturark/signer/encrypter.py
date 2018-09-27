from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric.padding import (
    PSS, MGF1, PKCS1v15, calculate_max_pss_salt_length)
from cryptography.hazmat.primitives.hashes import SHA256
from cryptography.hazmat.primitives.asymmetric.utils import Prehashed
from cryptography.hazmat.primitives.serialization import Encoding, PublicFormat
from base64 import b64decode


class Encrypter:

    def verify_signature(self, certificate_b64, signature_b64, digest_b64):
        certificate = self._parse_certificate(certificate_b64)
        certificate = x509.load_pem_x509_certificate(
            certificate_b64, default_backend())
        public_key = certificate.public_key()

        signature = b64decode(signature_b64)
        digest = b64decode(digest_b64)
        padding = PKCS1v15()
        hash_algorithm = certificate.signature_hash_algorithm

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
