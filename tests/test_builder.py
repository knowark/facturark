from pytest import fixture
from facturark.builder import Builder
from facturark.composers import InvoiceComposer
from facturark.resolver import resolve_invoice_composer


@fixture
def builder():
    invoice_composer = resolve_invoice_composer()
    builder = Builder(invoice_composer)
    return builder


def test_builder_creation(builder):
    assert builder


def test_build(builder):
    invoice_dict = {}
    result = builder.build(invoice_dict)
    assert result
