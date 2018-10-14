from lxml.etree import DocumentInvalid, fromstring
from pytest import fixture, raises


def test_validator_instantiation(validator):
    assert validator


def test_validator_invalid(validator):
    with raises(DocumentInvalid):
        element = fromstring('<Invalid></Invalid>')
        assert validator.validate(element)

