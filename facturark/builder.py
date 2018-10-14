from lxml.etree import tostring


class InvoiceBuilder:

    def __init__(self, invoice_composer, validator, signer=None):
        self.invoice_composer = invoice_composer
        self.validator = validator
        self.signer = signer

    def build(self, invoice_dict):
        invoice = self.invoice_composer.compose(invoice_dict)
        invoice, uuid = self.validator.validate(invoice)
        if self.signer:
            invoice = self.signer.sign(invoice)
        return tostring(invoice, pretty_print=True), uuid
