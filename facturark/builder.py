from facturark.models import Invoice


class Builder:

    def __init__(self, invoice_serializer):
        self.invoice_serializer = invoice_serializer

    def build(self, invoice_dict):
        return "INVOICE"
