from facturark.builder import Builder
from facturark.composers import InvoiceComposer


def build(invoice_dict):
    invoice_composer = InvoiceComposer()
    builder = Builder(invoice_composer)
    return builder.build(invoice_dict)
