from pytest import fixture
from facturark.builder import Builder
from facturark.composers import InvoiceComposer


@fixture
def builder():
    invoice_composer = InvoiceComposer
    builder = Builder(invoice_composer)
    return builder


def test_builder_creation(builder):
    assert builder


def test_build(builder):
    invoice_dict = {}
    result = builder.build(invoice_dict)
    assert result
