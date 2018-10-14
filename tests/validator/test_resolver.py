from facturark.validator import Validator
from facturark.validator.resolver import resolve_validator


def test_resolve_validator():
    assert isinstance(resolve_validator(''), Validator)
