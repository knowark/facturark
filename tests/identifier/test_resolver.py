from facturark.identifier import InvoiceIdentifier, BlankIdentifier
from facturark.identifier.resolver import resolve_identifier


def test_resolve_identifier():
    identifier = resolve_identifier('invoice', 'ABC')
    assert isinstance(identifier, InvoiceIdentifier)
    identifier = resolve_identifier('other')
    assert isinstance(identifier, BlankIdentifier)
