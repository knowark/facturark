from pytest import fixture
from facturark.builder import InvoiceBuilder
from facturark.composers import InvoiceComposer
from facturark.resolver import resolve_invoice_composer


@fixture
def invoice_builder():
    invoice_composer = resolve_invoice_composer()
    builder = InvoiceBuilder(invoice_composer)
    return builder


def test_invoice_builder_creation(invoice_builder):
    assert invoice_builder


def test_invoice_builder_build(invoice_builder):
    invoice_dict = {}
    result = invoice_builder.build(invoice_dict)
    assert result
