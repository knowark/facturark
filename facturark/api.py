from facturark.builder import Builder
from facturark.serializers import InvoiceSerializer


def build(invoice_dict):
    invoice_serializer = InvoiceSerializer()
    builder = Builder(invoice_serializer)
    return builder.build(invoice_dict)
