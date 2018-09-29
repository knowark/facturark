from OpenSSL import crypto


class Signer:
    def __init__(self, canonicalizer, hasher, encoder, identifier,
                 signature_composer, key_info_composer, object_composer,
                 qualifying_properties_composer, signed_properties_composer,
                 signed_info_composer):
        self.canonicalizer = canonicalizer
        self.hasher = hasher
        self.encoder = encoder
        self.identifier = identifier
        self.signature_composer = signature_composer
        self.key_info_composer = key_info_composer
        self.qualifying_properties_composer = qualifying_properties_composer
        self.signed_properties_composer = signed_properties_composer
        self.signed_info_composer = signed_info_composer
        self.signature_algorithm = (
            "http://www.w3.org/2001/04/xmlenc#sha512")
        self.digest_algorithm = (
            "http://www.w3.org/2001/04/xmldsig-more#rsa-sha512")

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

        # Prepare Signed Properties Element
        signed_properties, signed_properties_digest = (
            self._prepare_signed_properties(x509_certificate))

        # Prepare Document Element
        document_element, document_digest = (
            self._prepare_document(element))

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

    def _create_reference_dict(self, digest_value, transforms=None):
        reference_dict = {
            "digest_method": {
                "@attributes": {
                    "Algorithm": self.digest_algorithm
                }
            },
            "digest_value": "6F5KPfMMBWPbl8ImvaG9z9NFSLE="
        }
        if transforms:
            reference_dict['transforms'] = transforms
        return reference_dict

    def _prepare_document(self, document_element):
        canonicalized_document = self.canonicalizer.canonicalize(
            document_element)
        document_digest = self.encoder.base64_encode(self.hasher.hash(
            canonicalized_document))

        return document_element, document_digest

    def _prepare_key_info(self, certificate_object, uid):
        serialized_certificate = self._serialize_certificate(
            certificate_object)
        key_info_dict = {
            '@attributes': {'Id': uid},
            'X509_data': {
                'X509_certificate': serialized_certificate
            }
        }
        key_info = self.key_info_composer.compose(key_info_dict)
        canonicalized_key_info = self.canonicalizer.canonicalize(key_info)
        key_info_digest = self.encoder.base64_encode(
            self.hasher.hash(canonicalized_key_info))

        return key_info, key_info_digest

    def _prepare_signed_properties(self, certificate_object, uid):
        signed_properties = self.signed_properties_composer.compose({
            '@attributes': {'Id': uid}
        })
        canonicalized_signed_properties = self.canonicalizer.canonicalize(
            signed_properties)
        signed_properties_digest = self.encoder.base64_encode(
            self.hasher.hash(canonicalized_signed_properties))

        return signed_properties, signed_properties_digest

    def _prepare_signed_info(self, document_digest, key_info_digest,
                             signed_properties_digest):
        signed_info_dict = {
            "canonicalization_method": {
                "@attributes": {
                    "Algorithm": ("http://www.w3.org/TR/"
                                  "2001/REC-xml-c14n-20010315")
                }
            },
            "signature_method": {
                "@attributes": {
                    "Algorithm": self.signature_algorithm
                }
            },
            "references": [
                self._create_reference_dict(document_digest, [{
                    "@attributes": {"Algorithm": (
                        "http://www.w3.org/2000/09/"
                        "xmldsig#enveloped-signature")}}]),
                self._create_reference_dict(key_info_digest),
                self._create_reference_dict(signed_properties_digest)
            ]
        }

        signed_info = self.signed_info_composer.compose(signed_info_dict)
        canonicalized_signed_info = self.canonicalizer.canonicalize(
            signed_info)
        signed_info_digest = self.encoder.base64_encode(self.hasher.hash(
            canonicalized_signed_info))

        return signed_info, signed_info_digest
