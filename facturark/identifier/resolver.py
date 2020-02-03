from .identifier import BlankIdentifier
from .invoice_identifier import InvoiceIdentifier


def resolve_identifier(kind, technical_key=None):
    if kind == 'invoice':
        return InvoiceIdentifier(technical_key)
    else:
        return BlankIdentifier()
