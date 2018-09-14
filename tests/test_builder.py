from pytest import fixture
from facturark.builder import Builder
from facturark.serializers import InvoiceSerializer


@fixture
def builder():
    invoice_serializer = InvoiceSerializer
    builder = Builder(invoice_serializer)
    return builder


def test_builder_creation(builder):
    assert builder


def test_build(builder):
    invoice_dict = {}
    result = builder.build(invoice_dict)
    assert result
