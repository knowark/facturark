from facturark.models import Invoice


class InvoiceBuilder:

    def __init__(self, invoice_composer):
        self.invoice_composer = invoice_composer

    def build(self, invoice_dict):
        return "INVOICE"
