from lxml.etree import tostring


class InvoiceBuilder:

    def __init__(self, invoice_composer, validator,
                 signer=None, verifier=None):
        self.invoice_composer = invoice_composer
        self.validator = validator
        self.signer = signer
        self.verifier = verifier

    def build(self, invoice_dict):
        invoice = self.invoice_composer.compose(invoice_dict)
        invoice, uuid = self.validator.validate(invoice)
        if self.signer and self.verifier:
            invoice = self.signer.sign(invoice)
            self.verifier.verify(invoice)
        serialized_invoice = tostring(
            invoice, encoding='UTF-8', xml_declaration=True,
            standalone=False).replace(b'\n', b'')
        return serialized_invoice, uuid
