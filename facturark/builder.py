

class InvoiceBuilder:

    def __init__(self, invoice_composer, validator):
        self.invoice_composer = invoice_composer
        self.validator = validator

    def build(self, invoice_dict):
        invoice = self.invoice_composer.compose(invoice_dict)
        self.validator.validate(invoice)
        return invoice
