from lxml.etree import tostring


class DocumentBuilder:

    def __init__(self, composer, identifier, validator,
                 signer=None, verifier=None):
        self.composer = composer
        self.identifier = identifier
        self.validator = validator
        self.signer = signer
        self.verifier = verifier

    def build(self, document_dict):
        document = self.composer.compose(document_dict)
        # uuid = self.identifier.identify(document)
        # document = self.validator.validate(document)
        # if self.signer and self.verifier:
        #     document = self.signer.sign(document)
        #     self.verifier.verify(document)
        serialized_document = tostring(
            document, encoding='UTF-8', xml_declaration=True,
            standalone=False, pretty_print=True)
        return serialized_document  # , uuid
