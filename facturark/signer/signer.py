from OpenSSL import crypto


class Signer:
    def __init__(self, canonicalizer, hasher, encoder, identifier,
                 signature_composer, key_info_composer):
        self.canonicalizer = canonicalizer
        self.hasher = hasher
        self.encoder = encoder
        self.identifier = identifier
        self.signature_composer = signature_composer
        self.key_info_composer = key_info_composer

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

        # Prepare KeyInfo Element
        key_info, key_info_digest, key_info_id = (
            self._prepare_key_info(x509_certificate))

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
        return '\n' + '\n'.join(pem_certificate_list) + '\n'

    def _prepare_key_info(self, certificate_object):
        serialized_certificate = self._serialize_certificate(
            certificate_object)
        key_info_id = self.identifier.generate_id(suffix='keyinfo')
        key_info_dict = {
            '@attributes': {'Id': key_info_id},
            'X509_data': {
                'X509_certificate': serialized_certificate
            }
        }
        key_info = self.key_info_composer.compose(key_info_dict)
        canonicalized_key_info = self.canonicalizer.canonicalize(key_info)
        key_info_digest = self.encoder.base64_encode(
            self.hasher.hash(canonicalized_key_info))

        return key_info, key_info_digest, key_info_id
