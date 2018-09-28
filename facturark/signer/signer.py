

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


        # Digest Complete Document
        # document_digest = self.hasher.hash(hash_method)

        return True

    # def _parse_pkcs
