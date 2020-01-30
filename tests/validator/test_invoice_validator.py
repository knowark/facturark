from lxml.etree import DocumentInvalid, fromstring
from pytest import fixture, raises
from facturark.validator import InvoiceValidator


@fixture
def invoice_validator(mock_reviewer):
    return InvoiceValidator(mock_reviewer)


def test_invoice_validator_instantiation(invoice_validator):
    assert invoice_validator


def test_invoice_validator_invalid(invoice_validator):
    with raises(DocumentInvalid):
        element = fromstring('<Invalid></Invalid>')
        assert invoice_validator.validate(element)


def test_invoice_validator_valid(invoice_validator, load):
    element = load('V18/Generica.xml')
    assert invoice_validator.validate(element)
