from OpenSSL import crypto


class Signer:
    def __init__(self, canonicalizer, hasher, signature_composer):
        self.canonicalizer = canonicalizer
        self.hasher = hasher
        self.signature_composer = signature_composer

    def sign(self, element, pkcs12_certificate, pkcs12_password):

        # Canonicalize Document
        document = self.canonicalizer.canonicalize(element)

        print('DOCCC')
        print(document)

        # Create Signature Element
        signature = self.signature_composer.compose({})
        print(self.canonicalizer.canonicalize(signature))

        # Parse PKCS12 Certificate
        certificate = self._parse_certificate(
            pkcs12_certificate, pkcs12_password)

        x509_certificate = result.get_certificate()
        private_key = result.get_privatekey()

        # Digest Complete Document
        # document_digest = self.hasher.hash(hash_method)

        return True

    def _parse_certificate(self, pkcs12_certificate, pkcs12_password):
        certificate = crypto.load_pkcs12(pkcs12_certificate, pkcs12_password)
        return certificate

    def _serialize_certificate(self, certificate_object):
        pem_certificate = crypto.dump_certificate(
            crypto.FILETYPE_PEM, certificate_object)

        pem_certificate_list = pem_certificate.splitlines()[1:-1]
        return '\n'.join(pem_certificate_list)
