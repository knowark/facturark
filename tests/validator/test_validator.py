from lxml.etree import DocumentInvalid, fromstring
from pytest import fixture, raises
from facturark.validator import Validator


@fixture
def validator(mock_reviewer):
    return Validator(mock_reviewer)


def test_validator_instantiation(validator):
    assert validator


def test_validator_invalid(validator):
    with raises(DocumentInvalid):
        element = fromstring('<Invalid></Invalid>')
        assert validator.validate(element)
