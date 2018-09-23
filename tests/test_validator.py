from lxml.etree import DocumentInvalid, fromstring
from pytest import fixture, raises
from facturark.validator import Validator


@fixture
def validator():
    return Validator()


def test_validator_instantiation(validator):
    assert validator


def test_validator_invalid(validator):
    with raises(DocumentInvalid):
        element = fromstring('<Invalid></Invalid>')
        assert validator.validate(element)
