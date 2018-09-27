

class Signer:
    def __init__(self, canonicalizer):
        self.canonicalizer = canonicalizer

    def sign(self, element, pkcs12_certificate, pkcs12_password):

        # Canonicalize Document
        document = self.canonicalizer.canonicalize(element)

        # Digest Complete Document
        # self.

        return True
