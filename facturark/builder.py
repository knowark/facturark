from lxml.etree import tostring


class InvoiceBuilder:

    def __init__(self, composer, validator,
                 signer=None, verifier=None):
        self.composer = composer
        self.validator = validator
        self.signer = signer
        self.verifier = verifier

    def build(self, document_dict):
        document = self.composer.compose(document_dict)
        document, uuid = self.validator.validate(document)
        if self.signer and self.verifier:
            document = self.signer.sign(document)
            self.verifier.verify(document)
        serialized_document = tostring(
            document, encoding='UTF-8', xml_declaration=True,
            standalone=False).replace(b'\n', b'')
        return serialized_document, uuid
