from pytest import fixture
from facturark.models import Invoice
from facturark.builder import Builder


@fixture
def builder():
    builder = Builder()
    return builder


def test_builder_creation(builder):
    assert builder


def test_build(builder):
    invoice = Invoice()
    result = builder.build(Invoice)
    assert result
