from pytest import fixture
from facturark.builder import Builder


@fixture
def builder():
    builder = Builder()
    return builder


def test_builder_creation(builder):
    assert builder


def test_build(builder):
    invoice_dict = {}
    result = builder.build(invoice_dict)
    assert result
