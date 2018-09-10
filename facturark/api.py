from facturark.builder import Builder


def build(invoice_dict):
    builder = Builder()
    return builder.build(invoice_dict)
